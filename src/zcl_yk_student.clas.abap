CLASS zcl_yk_student DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: student_id    TYPE i,
          university_id TYPE i,
          name          TYPE string,
          age           TYPE i,
          major         TYPE string,
          email         TYPE string.

    CLASS-METHODS: create_student
      IMPORTING iv_student_name      TYPE string
                iv_student_age       TYPE i
                iv_major             TYPE string
                iv_email             TYPE string
      RETURNING VALUE(rv_student_id) TYPE i.

    CLASS-METHODS: get_student
      IMPORTING iv_student_id     TYPE i
      RETURNING VALUE(rs_student) TYPE REF TO zcl_yk_student.

    CLASS-METHODS: update_student
      IMPORTING iv_student_id TYPE i
                iv_name       TYPE string
                iv_age        TYPE i
                iv_major      TYPE string
                iv_email      TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: students TYPE TABLE OF REF TO zcl_yk_student.
    CLASS-DATA: student_counter TYPE i VALUE 1.
ENDCLASS.



CLASS ZCL_YK_STUDENT IMPLEMENTATION.


  METHOD create_student.

    DATA(lo_student) = NEW zcl_yk_student( ).
    lo_student->student_id = student_counter.
    lo_student->name       = iv_student_name.
    lo_student->age        = iv_student_age.
    lo_student->major      = iv_major.
    lo_student->email      = iv_email.

    rv_student_id = student_counter.
    APPEND lo_student TO students.
    student_counter = student_counter + 1.

  ENDMETHOD.


  METHOD get_student.

    LOOP AT students INTO DATA(lo_student).
      IF lo_student->student_id = iv_student_id.
        rs_student = lo_student.
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD update_student.

    LOOP AT students INTO DATA(lo_student).
      IF lo_student->student_id = iv_student_id.
        lo_student->name  = iv_name.
        lo_student->age   = iv_age.
        lo_student->major = iv_major.
        lo_student->email = iv_email.
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
