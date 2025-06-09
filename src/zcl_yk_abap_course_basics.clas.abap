CLASS zcl_yk_abap_course_basics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES: zif_abap_course_basics ,
      if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_YK_ABAP_COURSE_BASICS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*   Task 1. Hello World
    out->write( zif_abap_course_basics~hello_world( iv_name = 'Yoana' ) ).

*   Task 2. Calculator
    out->write( zif_abap_course_basics~calculator( iv_first_number  = 10
                                     iv_second_number = 0
                                     iv_operator      = '/' ) ).
*   Task 3. Fizz Buzz
    out->write( zif_abap_course_basics~fizz_buzz( ) ).

*   Task 4. Date Parsing
    out->write( zif_abap_course_basics~date_parsing( iv_date = '12 April 2017' ) ).
    out->write( zif_abap_course_basics~date_parsing( iv_date = '12 4 2017' ) ).

*   Task 5. Scrabble Score
    out->write( zif_abap_course_basics~scrabble_score( iv_word = 'ABC' ) ).

*   Task 6. Current date and time
    out->write( zif_abap_course_basics~get_current_date_time( ) ).

*   Task 7. Internal Tables
    zif_abap_course_basics~internal_tables(
      IMPORTING
        et_travel_ids_task7_1 = DATA(lt_table1)
        et_travel_ids_task7_2 = DATA(lt_table2)
        et_travel_ids_task7_3 = DATA(lt_table3)
    ).
    out->write( 'First 10 travels for agency 070001 with booking fee of 20 JPY' ).
    LOOP AT lt_table1 FROM 1 TO 10 INTO DATA(ls_travel).
      out->write( ls_travel-travel_id ).
    ENDLOOP.
    out->write( 'First 10 travels with a price higher than 2000 USD' ).
    LOOP AT lt_table2 FROM 1 TO 10 INTO ls_travel.
      out->write( ls_travel-travel_id ).
    ENDLOOP.
    out->write( 'First 10 travels with prices not in EUR, sorted by cheapest price and earliest date' ).
    LOOP AT lt_table3 FROM 1 TO 10 INTO ls_travel.
      out->write( ls_travel-travel_id ).
    ENDLOOP.

*   Task 8. OpenSQL
    zif_abap_course_basics~open_sql(
      IMPORTING
        et_travel_ids_task8_1 = DATA(lt_table4)
        et_travel_ids_task8_2 = DATA(lt_table5)
        et_travel_ids_task8_3 = DATA(lt_table6)
    ).
    out->write( 'First 10 travels for agency 070001 with booking fee of 20 JPY' ).
    LOOP AT lt_table4 FROM 1 TO 10 INTO ls_travel.
      out->write( ls_travel-travel_id ).
    ENDLOOP.
    out->write( 'First 10 travels with a price higher than 2000 USD' ).
    LOOP AT lt_table5 FROM 1 TO 10 INTO ls_travel.
      out->write( ls_travel-travel_id ).
    ENDLOOP.
    out->write( 'First 10 travels with prices not in EUR, sorted by cheapest price and earliest date' ).
    LOOP AT lt_table6 FROM 1 TO 10 INTO ls_travel.
      out->write( ls_travel-travel_id ).
    ENDLOOP.
*   Task 9. Unit test
  ENDMETHOD.


  METHOD zif_abap_course_basics~calculator.
    TRY.
        CASE iv_operator.
          WHEN '+'.
            rv_result = iv_first_number + iv_second_number.
          WHEN '-'.
            rv_result = iv_first_number - iv_second_number.
          WHEN '*'.
            rv_result = iv_first_number * iv_second_number.
          WHEN '/'.
            IF iv_second_number = 0.
              RAISE EXCEPTION TYPE cx_sy_zerodivide.
            ELSE.
              rv_result = iv_first_number / iv_second_number.
            ENDIF.
          WHEN OTHERS.
            rv_result = 0.
        ENDCASE.

      CATCH cx_sy_zerodivide INTO DATA(lx_zero_div).
        rv_result = 0.
    ENDTRY.
  ENDMETHOD.


  METHOD zif_abap_course_basics~date_parsing.
    DATA: lv_day       TYPE c LENGTH 2,
          lv_month_num TYPE c LENGTH 2,
          lv_month     TYPE string,
          lv_year      TYPE c LENGTH 4.

    SPLIT iv_date AT space INTO lv_day lv_month lv_year.

    IF strlen( lv_day ) = 1.
      CONCATENATE '0' lv_day INTO lv_day.
    ENDIF.

    IF NOT ( lv_month CO '0123456789' ).

      TRY.
          cl_scal_utils=>month_names_get(
            EXPORTING
              iv_language = 'E'
            IMPORTING
              et_month_names   =  DATA(lt_months) ).
        CATCH cx_scal INTO DATA(lx_scal).
      ENDTRY.

      READ TABLE lt_months INTO DATA(ls_month) WITH KEY ltx = lv_month.
      IF sy-subrc = 0.
        lv_month = ls_month-mnr.
      ENDIF.

    ELSE.
      IF strlen( lv_month ) = 1.
        CONCATENATE '0' lv_month INTO lv_month.
      ENDIF.

    ENDIF.

    CONCATENATE lv_year lv_month lv_day INTO rv_result.
  ENDMETHOD.


  METHOD zif_abap_course_basics~fizz_buzz.

    DATA lv_string TYPE string.

    DO 100 TIMES.
      lv_string = sy-index.
      CONDENSE lv_string.
      IF sy-index MOD 3 = 0 AND sy-index MOD 5 = 0.
        CONCATENATE rv_result 'FizzBuzz' INTO rv_result SEPARATED BY ''.
      ELSEIF sy-index MOD 3 = 0.
        CONCATENATE rv_result 'Fizz' INTO rv_result SEPARATED BY ''.
      ELSEIF sy-index MOD 5 = 0.
        CONCATENATE rv_result 'Buzz' INTO rv_result SEPARATED BY ''.
      ELSE.
        CONCATENATE rv_result lv_string INTO rv_result SEPARATED BY ''.
      ENDIF.
    ENDDO.

    SHIFT rv_result LEFT DELETING LEADING space.

  ENDMETHOD.


  METHOD zif_abap_course_basics~get_current_date_time.
    GET TIME STAMP FIELD rv_result.
  ENDMETHOD.


  METHOD zif_abap_course_basics~hello_world.
    rv_result = |Hello { iv_name }, your system user id is { sy-uname }.|.
  ENDMETHOD.


  METHOD zif_abap_course_basics~internal_tables.

    SELECT * FROM ztravel_yk INTO TABLE @DATA(lt_ztravel).

    LOOP AT lt_ztravel ASSIGNING FIELD-SYMBOL(<fs_ztravel>).

      IF <fs_ztravel>-agency_id = '070001' AND <fs_ztravel>-booking_fee = 20 AND <fs_ztravel>-currency_code = 'JPY'.
        APPEND <fs_ztravel>-travel_id TO et_travel_ids_task7_1.
      ENDIF.

      IF <fs_ztravel>-currency_code NE 'USD'.

        DATA lv_usd  TYPE p DECIMALS 2.
        DATA: lv_rate TYPE p DECIMALS 5.

        SELECT SINGLE ExchangeRate FROM I_ExchangeRateRawData
        WHERE SourceCurrency = @<fs_ztravel>-currency_code
        AND TargetCurrency = 'USD'
        AND ValidityStartDate <= @sy-datum
        INTO @lv_rate.

        IF sy-subrc = 0.
          lv_usd = <fs_ztravel>-total_price * lv_rate.
        ENDIF.

        IF lv_usd > 2000.
          APPEND <fs_ztravel>-travel_id TO et_travel_ids_task7_2.
        ENDIF.

      ELSEIF <fs_ztravel>-total_price > 2000.
        APPEND <fs_ztravel>-travel_id TO et_travel_ids_task7_2.

      ENDIF.

      IF <fs_ztravel>-currency_code <> 'EUR'.
        DELETE lt_ztravel INDEX sy-tabix.
      ENDIF.

    ENDLOOP.

    SORT lt_ztravel BY total_price ASCENDING
                        begin_date ASCENDING.

    et_travel_ids_task7_3 = CORRESPONDING #( lt_ztravel MAPPING travel_id = travel_id ).

* i would have used this method, but we have no authorization for TCURR and it doesnt work
*        TRY.
*            cl_exchange_rates=>convert_to_local_currency(
*              EXPORTING
*                date              = sy-datum
*                foreign_amount    = lv_price
*                foreign_currency  = lv_curr
*                local_currency    = 'USD'
*                do_read_tcurr     = abap_true
*                rate_type         = 'M'
*              IMPORTING
*                local_amount      = lv_usd
*            ).
*          CATCH cx_exchange_rates.

  ENDMETHOD.


  METHOD zif_abap_course_basics~open_sql.

    SELECT travel_id FROM ztravel_yk
      WHERE agency_id = '070001'
        AND booking_fee = 20
        AND currency_code = 'JPY'
      INTO TABLE @et_travel_ids_task8_1.

    SELECT travel_id FROM ztravel_yk AS travel
      LEFT JOIN I_ExchangeRateRawData AS rate
        ON rate~SourceCurrency = travel~currency_code
        AND rate~TargetCurrency = 'USD'
        AND rate~ValidityStartDate <= @sy-datum
      WHERE ( travel~currency_code = 'USD' AND travel~total_price > 2000 )
         OR ( travel~currency_code <> 'USD' AND travel~total_price * rate~ExchangeRate > 2000 )
      INTO TABLE @et_travel_ids_task8_2.

    SELECT travel_id FROM ztravel_yk
      WHERE currency_code = 'EUR'
      ORDER BY total_price ASCENDING, begin_date ASCENDING
      INTO TABLE @et_travel_ids_task8_3.
  ENDMETHOD.


  METHOD zif_abap_course_basics~scrabble_score.

    DATA lv_char  TYPE c LENGTH 1.
    DATA lv_idx   TYPE i.
    DATA lv_letter_score TYPE i.

    rv_result = 0.

    DO strlen( iv_word ) TIMES.

      lv_idx = sy-index - 1.
      lv_char = iv_word+lv_idx.
      lv_char = to_upper( lv_char ).

      IF lv_char CA sy-abcde.

        FIND lv_char IN sy-abcde MATCH OFFSET lv_letter_score.

        IF sy-subrc = 0.
          lv_letter_score += 1.
        ENDIF.

      ENDIF.

      rv_result += lv_letter_score.

    ENDDO.

  ENDMETHOD.
ENDCLASS.
