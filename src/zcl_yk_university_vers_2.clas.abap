CLASS zcl_yk_university_vers_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_university,
             id       TYPE i,
             name     TYPE string,
             location TYPE string,
           END OF ty_university.

    TYPES: BEGIN OF ty_student,
             student_id    TYPE i,
             university_id TYPE i,
             name          TYPE string,
             age           TYPE i,
             major         TYPE string,
             email         TYPE string,
           END OF ty_student.

    TYPES: tt_student TYPE STANDARD TABLE OF ty_student WITH DEFAULT KEY.

    DATA: university TYPE ty_university.

    CLASS-METHODS:
      create_university
        IMPORTING iv_name                 TYPE string
                  iv_location             TYPE string
        RETURNING VALUE(rv_university_id) TYPE i.

    METHODS:
      add_student
        IMPORTING iv_student_id TYPE i,

      delete_student
        IMPORTING iv_student_id TYPE i,

      list_students
        RETURNING VALUE(rt_students) TYPE tt_student.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_YK_UNIVERSITY_VERS_2 IMPLEMENTATION.


  METHOD add_student.

    UPDATE zstudent_yk
      SET university_id = @university-id
      WHERE student_id = @iv_student_id.

  ENDMETHOD.


  METHOD create_university.

    DATA: ls_university TYPE ty_university.

    SELECT MAX( id )
    FROM zuniversity_yk
    INTO @DATA(lv_max_id).

    rv_university_id = lv_max_id + 1.

    ls_university-id       = rv_university_id.
    ls_university-name     = iv_name.
    ls_university-location = iv_location.

    INSERT zuniversity_yk FROM @ls_university.

  ENDMETHOD.


  METHOD delete_student.

    UPDATE zstudent_yk
      SET university_id = 0
      WHERE student_id = @iv_student_id AND university_id = @university-id.

  ENDMETHOD.


  METHOD list_students.
    SELECT *
    FROM zstudent_yk
    WHERE university_id = @university-id
    INTO TABLE @rt_students.
  ENDMETHOD.
ENDCLASS.
