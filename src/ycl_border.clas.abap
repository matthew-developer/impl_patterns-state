CLASS ycl_border DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  METHODS: constructor
                IMPORTING iv_color TYPE string
                          iv_width TYPE i
                          iv_rounded_corners TYPE abap_bool,
           quadrate_corners
                RETURNING VALUE(ro_object) TYPE REF TO ycl_border.

  PRIVATE SECTION.
     DATA: mv_color  TYPE string,
           mv_width TYPE i,
           mv_rounded_corners TYPE abap_bool.
ENDCLASS.

CLASS ycl_border IMPLEMENTATION.

METHOD constructor.
    mv_color = iv_color.
    mv_width = iv_width.
    mv_rounded_corners = iv_rounded_corners.
ENDMETHOD.

METHOD quadrate_corners.
    ro_object = new ycl_border( iv_color = mv_color iv_rounded_corners = abap_false iv_width = mv_width ).
ENDMETHOD.

ENDCLASS.
