*"* use this source file for your ABAP unit test classes
CLASS ltc_zcl_yk_abap_course_basics DEFINITION FINAL FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PRIVATE SECTION.
    DATA: mo_cut TYPE REF TO zcl_yk_abap_course_basics.

    TYPES: BEGIN OF lts_travel_id,
             travel_id TYPE /dmo/travel_id,
           END OF lts_travel_id.

    METHODS:
      setup,
      test_main                      FOR TESTING,
      test_hello_world               FOR TESTING,
      test_calculator_add            FOR TESTING,
      test_calculator_subtract       FOR TESTING,
      test_calculator_multiply       FOR TESTING,
      test_calculator_divide         FOR TESTING,
      test_calculator_divide_by_zero FOR TESTING,
      test_calculator_invalid_op     FOR TESTING,
      test_fizz_buzz                 FOR TESTING,
      test_date_parsing_full_month   FOR TESTING,
      test_date_parsing_num_month    FOR TESTING,
      test_date_parsing_single_digit FOR TESTING,
      test_scrabble_score            FOR TESTING,
      test_scrabble_score_mixed_case FOR TESTING,
      test_scrabble_score_empty      FOR TESTING,
      test_get_current_date_time     FOR TESTING,
      test_internal_tables           FOR TESTING,
      test_open_sql                  FOR TESTING.
ENDCLASS.

CLASS ltc_zcl_yk_abap_course_basics IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW zcl_yk_abap_course_basics( ).
  ENDMETHOD.

  METHOD test_main.

  cl_abap_unit_assert=>skip( msg = 'I didnt find a way to exclude the main method from coverage' ).

  ENDMETHOD.

  METHOD test_hello_world.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~hello_world( iv_name = 'Test' ).
    cl_abap_unit_assert=>assert_equals(
      exp = |Hello Test, your system user id is { sy-uname }.|
      act = lv_result
      msg = 'Hello World output should match expected format' ).
  ENDMETHOD.

  METHOD test_calculator_add.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~calculator(
      iv_first_number = 5
      iv_second_number = 3
      iv_operator = '+' ).
    cl_abap_unit_assert=>assert_equals(
      exp = 8
      act = lv_result
      msg = 'Addition should return correct sum' ).
  ENDMETHOD.

  METHOD test_calculator_subtract.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~calculator(
      iv_first_number = 5
      iv_second_number = 3
      iv_operator = '-' ).
    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = lv_result
      msg = 'Subtraction should return correct difference' ).
  ENDMETHOD.

  METHOD test_calculator_multiply.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~calculator(
      iv_first_number = 5
      iv_second_number = 3
      iv_operator = '*' ).
    cl_abap_unit_assert=>assert_equals(
      exp = 15
      act = lv_result
      msg = 'Multiplication should return correct product' ).
  ENDMETHOD.

  METHOD test_calculator_divide.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~calculator(
      iv_first_number = 6
      iv_second_number = 3
      iv_operator = '/' ).
    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = lv_result
      msg = 'Division should return correct quotient' ).
  ENDMETHOD.

  METHOD test_calculator_divide_by_zero.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~calculator(
      iv_first_number = 5
      iv_second_number = 0
      iv_operator = '/' ).
    cl_abap_unit_assert=>assert_equals(
      exp = 0
      act = lv_result
      msg = 'Division by zero should return 0' ).
  ENDMETHOD.

  METHOD test_calculator_invalid_op.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~calculator(
      iv_first_number = 5
      iv_second_number = 3
      iv_operator = 'x' ).
    cl_abap_unit_assert=>assert_equals(
      exp = 0
      act = lv_result
      msg = 'Invalid operator should return 0' ).
  ENDMETHOD.

  METHOD test_fizz_buzz.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~fizz_buzz( ).

    DATA(lv_expected_start) ='1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz'.

    DATA(lv_actual_start) = lv_result(57).

    cl_abap_unit_assert=>assert_equals(
      exp = lv_expected_start
      act = lv_actual_start
      msg = 'FizzBuzz output should match expected pattern' ).
  ENDMETHOD.

  METHOD test_date_parsing_full_month.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~date_parsing(
      iv_date = '12 April 2017' ).
    cl_abap_unit_assert=>assert_equals(
      exp = '20170412'
      act = lv_result
      msg = 'Date parsing with full month name should return correct YYYYMMDD' ).
  ENDMETHOD.

  METHOD test_date_parsing_num_month.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~date_parsing(
      iv_date = '12 4 2017' ).
    cl_abap_unit_assert=>assert_equals(
      exp = '20170412'
      act = lv_result
      msg = 'Date parsing with numeric month should return correct YYYYMMDD' ).
  ENDMETHOD.

  METHOD test_date_parsing_single_digit.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~date_parsing(
      iv_date = '5 8 2020' ).
    cl_abap_unit_assert=>assert_equals(
      exp = '20200805'
      act = lv_result
      msg = 'Date parsing with single digit day/month should return correct YYYYMMDD' ).
  ENDMETHOD.

  METHOD test_scrabble_score.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~scrabble_score(
      iv_word = 'Scrabble' ).
    cl_abap_unit_assert=>assert_equals(
      exp = 62
      act = lv_result
      msg = 'Scrabble score should calculate correctly' ).
  ENDMETHOD.

  METHOD test_scrabble_score_mixed_case.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~scrabble_score(
      iv_word = 'aBcDe' ).
    cl_abap_unit_assert=>assert_equals(
      exp = 15
      act = lv_result
      msg = 'Scrabble score should handle mixed case correctly' ).
  ENDMETHOD.

  METHOD test_scrabble_score_empty.
    DATA(lv_result) = mo_cut->zif_abap_course_basics~scrabble_score(
      iv_word = '' ).
    cl_abap_unit_assert=>assert_equals(
      exp = 0
      act = lv_result
      msg = 'Empty word should return score 0' ).
  ENDMETHOD.

  METHOD test_get_current_date_time.
    DATA(lv_timestamp) = mo_cut->zif_abap_course_basics~get_current_date_time( ).

    DATA(lv_timestamp_str) = CONV string( lv_timestamp ).

    cl_abap_unit_assert=>assert_equals(
         exp = strlen( 'yyyymmddhhmmss.ssssssss' )
         act = strlen( lv_timestamp_str ) ).
  ENDMETHOD.

  METHOD test_internal_tables.
    DATA: lt_table1 TYPE TABLE OF lts_travel_id,
          lt_table2 TYPE TABLE OF lts_travel_id,
          lt_table3 TYPE TABLE OF lts_travel_id.

    mo_cut->zif_abap_course_basics~internal_tables(
      IMPORTING
        et_travel_ids_task7_1 = lt_table1
        et_travel_ids_task7_2 = lt_table2
        et_travel_ids_task7_3 = lt_table3 ).

    cl_abap_unit_assert=>assert_not_initial(
      act = lt_table1
      msg = 'First internal table should not be initial' ).

    cl_abap_unit_assert=>assert_not_initial(
      act = lt_table2
      msg = 'Second internal table should not be initial' ).

    cl_abap_unit_assert=>assert_not_initial(
      act = lt_table3
      msg = 'Third internal table should not be initial' ).

  ENDMETHOD.

  METHOD test_open_sql.
    DATA: lt_table4 TYPE TABLE OF lts_travel_id,
          lt_table5 TYPE TABLE OF lts_travel_id,
          lt_table6 TYPE TABLE OF lts_travel_id.

    mo_cut->zif_abap_course_basics~open_sql(
      IMPORTING
        et_travel_ids_task8_1 = lt_table4
        et_travel_ids_task8_2 = lt_table5
        et_travel_ids_task8_3 = lt_table6 ).

    cl_abap_unit_assert=>assert_not_initial(
      act = lt_table4
      msg = 'First OpenSQL table should not be initial' ).

    cl_abap_unit_assert=>assert_not_initial(
      act = lt_table5
      msg = 'Second OpenSQL table should not be initial' ).

    cl_abap_unit_assert=>assert_not_initial(
      act = lt_table6
      msg = 'Third OpenSQL table should not be initial' ).

  ENDMETHOD.

ENDCLASS.
