CLASS zcl_yk_university DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: id       TYPE i,
          name     TYPE string,
          location TYPE string.

    TYPES ltt_students TYPE STANDARD TABLE OF REF TO zcl_yk_student WITH DEFAULT KEY.

    CLASS-METHODS: create_university
      IMPORTING iv_university_name      TYPE string
                iv_university_location  TYPE string
      RETURNING VALUE(rv_university_id) TYPE i.

    CLASS-METHODS: get_university
      IMPORTING iv_university_id     TYPE i
      RETURNING VALUE(ro_university) TYPE REF TO zcl_yk_university.

    METHODS: add_student
      IMPORTING iv_student_id TYPE i
                university_id TYPE i.

    METHODS: delete_student
      IMPORTING iv_student_id TYPE i.

    METHODS: list_students
      RETURNING VALUE(rt_students) TYPE ltt_students.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA: university_counter TYPE i VALUE 1.
    CLASS-DATA: universities TYPE TABLE OF REF TO zcl_yk_university.
    CLASS-DATA: students TYPE ltt_students.
ENDCLASS.



CLASS zcl_yk_university IMPLEMENTATION.

  METHOD create_university.

    DATA(lo_university) = NEW zcl_YK_university( ).
    lo_university->name     = iv_university_name.
    lo_university->location = iv_university_location.
    lo_university->id       = university_counter.

    APPEND lo_university TO universities.
    rv_university_id = university_counter.
    university_counter += 1.

  ENDMETHOD.

  METHOD get_university.
    LOOP AT universities INTO DATA(lo_university).
      IF lo_university->id = iv_university_id.
        ro_university = lo_university.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD add_student.

    LOOP AT universities INTO DATA(lo_university).
      IF lo_university->id = iv_student_id.
        DATA(lo_student) = zcl_yk_student=>get_student( iv_student_id ).
        IF lo_student IS BOUND.
          lo_student->university_id = id.
          INSERT lo_student INTO TABLE students.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD delete_student.

    DELETE students WHERE table_line->student_id = iv_student_id.

  ENDMETHOD.

  METHOD list_students.

    rt_students = students.

  ENDMETHOD.

ENDCLASS.
