CLASS zcl_rap_eml_yk DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rap_eml_yk IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

**step 1 - READ
*    READ ENTITIES OF zi_rap_travel_yk
*    ENTITY Travel
*    FROM VALUE #( ( TravelUUID = '19BB82807F7CE16B190063564DDEDAF3' ) )
*    RESULT DATA(travels).
*
*    out->write( travels ).

**step 2 - READ with Fields
*    READ ENTITIES OF zi_rap_travel_yk
*    ENTITY Travel
*    FIELDS ( AgencyID CustomerID )
*    WITH VALUE #( ( TravelUUID = '19BB82807F7CE16B190063564DDEDAF3' ) )
*    RESULT DATA(travels).
*
*    out->write( travels ).

**step 3 - READ with  All Fields
*    READ ENTITIES OF zi_rap_travel_yk
*    ENTITY Travel
*    ALL FIELDS
*    WITH VALUE #( ( TravelUUID = '19BB82807F7CE16B190063564DDEDAF3' ) )
*    RESULT DATA(travels).
*
*    out->write( travels ).

**step 4 - READ by Association
*    READ ENTITIES OF zi_rap_travel_yk
*    ENTITY Travel by \_Booking
*    ALL FIELDS
*    WITH VALUE #( ( TravelUUID = '19BB82807F7CE16B190063564DDEDAF3' ) )
*    RESULT DATA(bookings).
*
*    out->write( bookings ).

**step 5 - Unsuccessful READ
*    READ ENTITIES OF zi_rap_travel_yk
*    ENTITY Travel BY \_Booking
*    ALL FIELDS
*    WITH VALUE #( ( TravelUUID = '11111111111111111111111111111111' ) )
*    RESULT DATA(bookings)
*    FAILED DATA(failed)
*    REPORTED DATA(reported).
*
*    out->write( bookings ).
*    out->write( failed ).
*    out->write( reported ).

**step 6 - MODIFY Update
*    MODIFY ENTITIES OF zi_rap_travel_yk
*    ENTITY Travel
*    UPDATE
*     SET FIELDS WITH VALUE #( ( TravelUUID = '19BB82807F7CE16B190063564DDEDAF3'
*                                Description = 'I hate RAP') )
*    FAILED DATA(failed)
*    REPORTED DATA(reported).
*
*    out->write( 'Update done' ).
*
*    COMMIT ENTITIES
*    RESPONSE OF zi_rap_travel_yk
*    FAILED DATA(failed_commit)
*    REPORTED DATA(reported_commit).

**step 7 - MODIFY Create
    MODIFY ENTITIES OF zi_rap_travel_yk
      ENTITY travel
        CREATE
          SET FIELDS WITH VALUE
            #( ( %cid        = 'MyContentID_1'
                 AgencyID    = '70012'
                 CustomerID  = '14'
                 BeginDate   = cl_abap_context_info=>get_system_date( )
                 EndDate     = cl_abap_context_info=>get_system_date( ) + 10
                 Description = 'I like RAP@openSAP' ) )

     MAPPED DATA(mapped)
     FAILED DATA(failed)
     REPORTED DATA(reported).

    out->write( mapped-travel ).

    COMMIT ENTITIES
      RESPONSE OF zi_rap_travel_yk
      FAILED     DATA(failed_commit)
      REPORTED   DATA(reported_commit).

    out->write( 'Create done' ).

*   " step 8 - MODIFY Delete
*    MODIFY ENTITIES OF zi_rap_travel_yk
*      ENTITY travel
*        DELETE FROM
*          VALUE
*            #( ( TravelUUID  = '<your uuid>' ) )
*
*     FAILED DATA(failed)
*     REPORTED DATA(reported).
*
*    COMMIT ENTITIES
*      RESPONSE OF zi_rap_travel_yk
*      FAILED     DATA(failed_commit)
*      REPORTED   DATA(reported_commit).
*
*    out->write( 'Delete done' ).



  ENDMETHOD.
ENDCLASS.
