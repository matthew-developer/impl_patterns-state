CLASS ycl_controller DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  METHODS: constructor,
           generate_object.
  PRIVATE SECTION.
     DATA: mo_object TYPE REF TO ycl_state.
     CONSTANTS: mc_color_blue TYPE string value 'blue',
                mc_middle_width TYPE i value 20.
ENDCLASS.

CLASS ycl_controller IMPLEMENTATION.

METHOD constructor.
    mo_object = new ycl_state( iv_point_x = 2 iv_point_y = 3 ).
ENDMETHOD.

METHOD generate_object.

    mo_object->set_bounderies( iv_color = 'blue'  iv_round_corners = abap_true iv_width = 20 ).
    mo_object->set_bounderies( iv_color = mc_color_blue  iv_round_corners = abap_true iv_width = mc_middle_width  ).

    DATA(lo_border) = new ycl_border( iv_color = 'blue' iv_rounded_corners = abap_true iv_width = 20 ).
    mo_object->set_bounderies2( lo_border ).

    mo_object->set_bounderies2( lo_border->quadrate_corners(  ) ).

ENDMETHOD.

ENDCLASS.
