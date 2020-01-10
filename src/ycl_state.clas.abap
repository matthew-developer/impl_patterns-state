CLASS ycl_state DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  TYPES: BEGIN OF ts_property,
            property_name TYPE string,
            property_value TYPE REF TO data,
         END OF ts_property,
         BEGIN OF ts_value,
            size TYPE i,
         END OF ts_value,
         tt_property TYPE STANDARD TABLE OF ts_property WITH EMPTY KEY,
         tt_value TYPE STANDARD TABLE OF ts_value WITH EMPTY KEY.


  METHODS: constructor
                IMPORTING iv_point_x TYPE i
                          iv_point_y TYPE i,
           set_point_x
                IMPORTING iv_point_x TYPE i,
           update_length,
           calculate_length
                RETURNING VALUE(rv_length) TYPE i,
           set_property
                IMPORTING
                        iv_property_name  TYPE string
                        io_property_value TYPE REF TO data,
           compute_some_values,
           contact_support
                IMPORTING iv_message  TYPE string
                          is_property TYPE ts_property,
           collect_values
                RETURNING VALUE(rv_result) TYPE i,
           calculate_salary
                IMPORTING iv_worker_id   TYPE i optional
                          iv_worker_name TYPE string optional,
           set_bounderies
                IMPORTING iv_width type i
                          iv_color type string
                          iv_round_corners type abap_bool,
           set_bounderies2
                IMPORTING border TYPE REF TO ycl_border,
           count_chars
                IMPORTING iv_input TYPE char10.

  PROTECTED SECTION.
  PRIVATE SECTION.
  DATA: mv_point_x TYPE i,
        mv_point_y TYPE i,
        mv_length  TYPE i,
        mv_register_door TYPE i,
        mt_property TYPE tt_property,
        mt_values   TYPE tt_value.

  DATA: mv_name_string TYPE string,
        mv_id_scope_middle TYPE i,
        mv_name_for_worker TYPE string.

ENDCLASS.



CLASS ycl_state IMPLEMENTATION.

METHOD constructor.
    mv_point_x = iv_point_x.
    mv_point_y = iv_point_y.
    mv_register_door = 1.
ENDMETHOD.

METHOD set_point_x.
    mv_point_x = iv_point_x.
    mv_length  = mv_point_x + mv_point_y.
    update_length(  ).
ENDMETHOD.

METHOD update_length.
    mv_length = mv_point_x + mv_point_y.
ENDMETHOD.

METHOD calculate_length.
    rv_length = mv_point_x + mv_point_y.
ENDMETHOD.

METHOD set_property.
    DATA: ls_property TYPE ts_property.
          ls_property-property_name  = iv_property_name.
          ls_property-property_value = io_property_value.

          APPEND ls_property TO mt_property.
ENDMETHOD.

METHOD compute_some_values.
    DATA: lv_counter TYPE i.
    LOOP AT mt_property INTO DATA(ls_property).
        IF lv_counter = 10.
            contact_support( iv_message = 'ERROR' is_property = ls_property ).
        ELSE.
            lv_counter = lv_counter + 1.
            contact_support( iv_message = 'OK' is_property = ls_property ).
        ENDIF.
    ENDLOOP.
ENDMETHOD.

METHOD contact_support.
ENDMETHOD.

METHOD collect_values.
    LOOP AT mt_values INTO DATA(ls_value).
        rv_result = rv_result + ls_value-size.
    ENDLOOP.
ENDMETHOD.

METHOD calculate_salary.
    calculate_salary( iv_worker_id = 100 ).
    calculate_salary( iv_worker_name = 'Johnson' ).
ENDMETHOD.

METHOD set_bounderies.
ENDMETHOD.

METHOD set_bounderies2.
ENDMETHOD.

METHOD count_chars.
ENDMETHOD.

ENDCLASS.
