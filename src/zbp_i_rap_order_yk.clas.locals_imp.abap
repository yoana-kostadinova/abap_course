CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF lt_status,
        in_process TYPE zstatusyk VALUE 'O', " In Process
        completed  TYPE zstatusyk VALUE 'C', " Completed
        cancelled  TYPE zstatusyk VALUE 'X', " Cancelled
      END OF lt_status.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Order RESULT result.

    METHODS global_authorization FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Order
      RESULT result.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Order RESULT result.

    METHODS setIdOrder FOR DETERMINE ON SAVE
      IMPORTING keys FOR Order~setIdOrder.

    METHODS setCreationDateOrder FOR DETERMINE ON SAVE
      IMPORTING keys FOR Order~setCreationDateOrder.

    METHODS setStatusOrder FOR DETERMINE ON SAVE
      IMPORTING keys FOR Order~setStatusOrder.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validatecustomer.

    METHODS orderCancelled FOR MODIFY
      IMPORTING keys FOR ACTION Order~orderCancelled RESULT result.

    METHODS orderCompleted FOR MODIFY
      IMPORTING keys FOR ACTION Order~orderCompleted RESULT result.

    METHODS recalctotalprice FOR MODIFY
      IMPORTING keys FOR ACTION Order~recalcTotalPrice.

    METHODS validateOrderItems FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateOrderItems.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD get_instance_features.
    " Read the order status of the existing orders
    READ ENTITIES OF zi_rap_order_yk IN LOCAL MODE
      ENTITY Order
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders)
      FAILED failed.

    result =
      VALUE #(
        FOR order IN orders
          LET is_enabled = COND #( WHEN order-Status = lt_status-in_process
                                   THEN if_abap_behv=>fc-o-enabled
                                   ELSE if_abap_behv=>fc-o-disabled )
              is_readonly = COND #( WHEN order-Status <> lt_status-in_process
                                   THEN if_abap_behv=>fc-f-read_only
                                   ELSE if_abap_behv=>fc-f-unrestricted )
          IN
            ( %tky                   = order-%tky
              %action-orderCompleted = is_enabled
              %action-orderCancelled = is_enabled
             ) ).
  ENDMETHOD.

  METHOD global_authorization.
    result = VALUE #( %create = if_abap_behv=>auth-allowed ).
  ENDMETHOD.

  METHOD get_authorizations.



  ENDMETHOD.


  METHOD setIdOrder.

    " Check if OrderID is already filled
    READ ENTITIES OF zi_rap_order_yk IN LOCAL MODE
      ENTITY Order
        FIELDS ( OrderId ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    " Remove lines where OrderID is already filled.
    DELETE orders WHERE OrderId IS NOT INITIAL.

    " anything left ?
    CHECK orders IS NOT INITIAL.

    " Select max Order ID
    SELECT SINGLE
        FROM  zrap_order_yk
        FIELDS MAX( order_id ) AS OrderID
        INTO @DATA(max_orderid).

    " Set the Order ID
    MODIFY ENTITIES OF zi_rap_order_yk IN LOCAL MODE
    ENTITY Order
      UPDATE
        FROM VALUE #( FOR order IN orders INDEX INTO i (
          %tky              = order-%tky
          OrderID          = max_orderid + i
          %control-OrderID = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).


  ENDMETHOD.

  METHOD setCreationDateOrder.

    " Read relevant order creation date
    READ ENTITIES OF zi_rap_order_yk IN LOCAL MODE
      ENTITY Order
        FIELDS ( CreationDate  ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    " Set order Creation Date
    MODIFY ENTITIES OF zi_rap_order_yk IN LOCAL MODE
    ENTITY Order
      UPDATE
        FIELDS ( CreationDate )
        WITH VALUE #( FOR order IN orders
                      ( %tky         = order-%tky
                        CreationDate   = cl_abap_context_info=>get_system_date( ) ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD setStatusOrder.

    " Read relevant order status
    READ ENTITIES OF zi_rap_order_yk IN LOCAL MODE
      ENTITY Order
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    " Set order status
    MODIFY ENTITIES OF zi_rap_order_yk IN LOCAL MODE
    ENTITY Order
      UPDATE
        FIELDS ( Status )
        WITH VALUE #( FOR order IN orders
                      ( %tky         = order-%tky
                        Status   = lt_status-in_process ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD validateCustomer.
    " Read relevant order instance data
    READ ENTITIES OF zi_rap_order_yk IN LOCAL MODE
      ENTITY Order
        FIELDS ( Customer ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    DATA customers TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    " Optimization of DB select: extract distinct non-initial customer IDs
    customers = CORRESPONDING #( orders DISCARDING DUPLICATES MAPPING customer_id = Customer EXCEPT * ).
    DELETE customers WHERE customer_id IS INITIAL.
    IF customers IS NOT INITIAL.
      " Check if customer ID exist
      SELECT FROM /dmo/customer FIELDS customer_id
        FOR ALL ENTRIES IN @customers
        WHERE customer_id = @customers-customer_id
        INTO TABLE @DATA(customers_db).
    ENDIF.

    " Raise msg for non existing and initial customerID
    LOOP AT orders INTO DATA(order).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = order-%tky
                       %state_area = 'VALIDATE_CUSTOMER' )
        TO reported-order.

      IF order-Customer IS INITIAL OR NOT line_exists( customers_db[ customer_id = order-Customer ] ).
        APPEND VALUE #(  %tky = order-%tky ) TO failed-order.

        APPEND VALUE #(  %tky        = order-%tky
                         %state_area = 'VALIDATE_CUSTOMER'
                         %msg        = NEW zcm_rap_yk(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_rap_yk=>customer_unknown
                                           customerid = order-Customer )
                         %element-Customer = if_abap_behv=>mk-on )
          TO reported-order.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD orderCancelled.
    MODIFY ENTITIES OF zi_rap_order_yk IN LOCAL MODE
    ENTITY Order
       UPDATE
         FIELDS ( Status )
         WITH VALUE #( FOR key IN keys
                         ( %tky         = key-%tky
                           Status = lt_status-cancelled ) )
    FAILED failed
    REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zi_rap_order_yk IN LOCAL MODE
      ENTITY Order
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    result = VALUE #( FOR order IN orders
                        ( %tky   = order-%tky
                          %param = order ) ).
  ENDMETHOD.

  METHOD orderCompleted.
    MODIFY ENTITIES OF zi_rap_order_yk IN LOCAL MODE
 ENTITY Order
    UPDATE
      FIELDS ( Status )
      WITH VALUE #( FOR key IN keys
                      ( %tky         = key-%tky
                        Status = lt_status-completed ) )
 FAILED failed
 REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zi_rap_order_yk IN LOCAL MODE
      ENTITY Order
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    result = VALUE #( FOR order IN orders
                        ( %tky   = order-%tky
                          %param = order ) ).
  ENDMETHOD.

  METHOD recalctotalprice.
    TYPES: BEGIN OF ty_amount_per_currencycode,
             amount        TYPE /dmo/total_price,
             currency_code TYPE /dmo/currency_code,
           END OF ty_amount_per_currencycode.

    DATA: amount_per_currencycode TYPE STANDARD TABLE OF ty_amount_per_currencycode.

    " Read all relevant order instances.
    READ ENTITIES OF zi_rap_order_yk IN LOCAL MODE
         ENTITY Order
            FIELDS ( TotalPrice Currency )
            WITH CORRESPONDING #( keys )
         RESULT DATA(orders).

    DELETE orders WHERE Currency IS INITIAL.

    LOOP AT orders ASSIGNING FIELD-SYMBOL(<order>).
      amount_per_currencycode = VALUE #( ( amount        = 0
                                           currency_code = <order>-Currency ) ).

      " Read all associated items and add them to the total price.
      READ ENTITIES OF ZI_RAP_order_YK IN LOCAL MODE
        ENTITY order BY \_Item
          FIELDS ( Quantity TotalPrice Currency )
        WITH VALUE #( ( %tky = <order>-%tky ) )
        RESULT DATA(items).

      LOOP AT items INTO DATA(item) WHERE Currency IS NOT INITIAL.
        COLLECT VALUE ty_amount_per_currencycode( amount        = item-TotalPrice * item-Quantity
                                                  currency_code = item-Currency ) INTO amount_per_currencycode.
      ENDLOOP.

      CLEAR <order>-TotalPrice.
      LOOP AT amount_per_currencycode INTO DATA(single_amount_per_currencycode).

        IF single_amount_per_currencycode-currency_code = <order>-Currency.
          <order>-TotalPrice += single_amount_per_currencycode-amount.
        ELSE.
          /dmo/cl_flight_amdp=>convert_currency(
             EXPORTING
               iv_amount                   =  single_amount_per_currencycode-amount
               iv_currency_code_source     =  single_amount_per_currencycode-currency_code
               iv_currency_code_target     =  <order>-Currency
               iv_exchange_rate_date       =  cl_abap_context_info=>get_system_date( )
             IMPORTING
               ev_amount                   = DATA(total_booking_price_per_curr)
            ).
          <order>-TotalPrice += total_booking_price_per_curr.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    " write back the modified total_price of orders
    MODIFY ENTITIES OF ZI_RAP_order_YK IN LOCAL MODE
      ENTITY order
        UPDATE FIELDS ( TotalPrice )
        WITH CORRESPONDING #( orders ).
  ENDMETHOD.

  METHOD validateorderitems.

*   Read orders
    READ ENTITIES OF zi_rap_order_yk IN LOCAL MODE
     ENTITY Order
     FIELDS ( OrderUuid OrderId Name ) WITH CORRESPONDING #( keys )
     RESULT DATA(orders).

    " Read items
    READ ENTITIES OF zi_rap_order_yk IN LOCAL MODE
       ENTITY Order BY \_Item
       FIELDS ( OrderUuid ItemUuid ) WITH CORRESPONDING #( keys )
       RESULT DATA(items).

    SORT items BY orderuuid.

    LOOP AT orders INTO DATA(order).

      APPEND VALUE #(  %tky        = order-%tky
                     %state_area = 'validateorderitems' )
      TO reported-order.

      READ TABLE items WITH KEY orderuuid = order-orderuuid TRANSPORTING NO FIELDS.


      IF sy-subrc <> 0.

        APPEND VALUE #(  %tky = order-%tky ) TO failed-order.

        APPEND VALUE #(  %tky        = order-%tky
                         %state_area = 'validateorderitems'
                         %msg        = NEW zcm_rap_yk(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_rap_yk=>no_items )
                         %element-name = if_abap_behv=>mk-on )
          TO reported-order.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.


ENDCLASS.
