CLASS zcl_yk_order_complexity DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_yk_order_complexity IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA:
          lt_orders     TYPE STANDARD TABLE OF zc_rap_order_yk,
          lv_complexity TYPE string.

    lt_orders = CORRESPONDING #( it_original_data ).

    LOOP AT lt_orders ASSIGNING FIELD-SYMBOL(<order>).

      READ ENTITIES OF zc_rap_order_yk
        ENTITY Order BY \_Item
        FIELDS ( Orderuuid )
        WITH VALUE #( ( OrderUuid = <order>-orderuuid ) )
        RESULT DATA(items).

      DATA(count) = lines( items ).

      CASE count.
        WHEN 0 OR 1 OR 2.
          lv_complexity = 'Easy'.
        WHEN 3 OR 4.
          lv_complexity = 'Medium'.
        WHEN OTHERS.
          lv_complexity = 'Complex'.
      ENDCASE.

      <order>-complexity = lv_complexity.
    ENDLOOP.


    ct_calculated_data = CORRESPONDING #( lt_orders ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.

ENDCLASS.
