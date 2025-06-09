CLASS zcl_yk_student_vers_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_student,
             student_id    TYPE i,
             university_id TYPE i,
             name          TYPE string,
             age           TYPE i,
             major         TYPE string,
             email         TYPE string,
           END OF ty_student.

    DATA: student TYPE ty_student.

    CLASS-METHODS:
      create_student
        IMPORTING iv_name              TYPE string
                  iv_age               TYPE i
                  iv_major             TYPE string
                  iv_email             TYPE string
        RETURNING VALUE(rv_student_id) TYPE i,

      get_student
        IMPORTING iv_student_id     TYPE i
        RETURNING VALUE(ro_student) TYPE REF TO zcl_yk_student_vers_2,

      update_student
        IMPORTING iv_student_id TYPE i
                  iv_name       TYPE string
                  iv_age        TYPE i
                  iv_major      TYPE string
                  iv_email      TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_YK_STUDENT_VERS_2 IMPLEMENTATION.


  METHOD create_student.

    DATA: ls_student TYPE ty_student.

    SELECT MAX( student_id )
    FROM zstudent_yk
    INTO @DATA(lv_max_id) .
    rv_student_id = lv_max_id + 1.

    ls_student-student_id    = rv_student_id.
    ls_student-university_id = 0. " default
    ls_student-name          = iv_name.
    ls_student-age           = iv_age.
    ls_student-major         = iv_major.
    ls_student-email         = iv_email.

    INSERT zstudent_yk FROM @ls_student.

  ENDMETHOD.


  METHOD get_student.

    SELECT SINGLE *
    FROM zstudent_yk
    WHERE student_id = @iv_student_id
    INTO @DATA(ls_student).

    IF sy-subrc = 0.
      CREATE OBJECT ro_student.
      ro_student->student = ls_student.
    ELSE.
      CLEAR ro_student.
    ENDIF.

  ENDMETHOD.


  METHOD update_student.

    UPDATE zstudent_yk
      SET name  = @iv_name,
          age   = @iv_age,
          major = @iv_major,
          email = @iv_email
      WHERE student_id = @iv_student_id.

  ENDMETHOD.
ENDCLASS.
