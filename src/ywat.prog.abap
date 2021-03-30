*&---------------------------------------------------------------------*
*& Report YWAT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report ywat.

class wat definition final for testing duration short risk level dangerous.
  private section.
    class-methods class_setup.
    class-data: output type ref to if_demo_output.
    methods break.
    methods show importing value type data.
    "! NUMC generally have numbers only, but not always.
    methods _1 for testing.
    "! Implicit conversion equality not so equals.
    methods _2 for testing.
    "! Behavior in FMs defining tables with LIKE.
    methods tables_bogus for testing.
    "! TBW Behavior in FMs defining tables with LIKE.
    methods tabtype_relaxed_for_like for testing.
    "! Leaking a static reference.
    methods _5 for testing.
    class-methods statics_ref
      returning value(ref) type ref to string.
endclass.
class wat implementation.
  method class_setup.
    output = cl_demo_output=>new( ).
  endmethod.
  method break.
    return.
    break-point at next application statement .
  endmethod.
  method show.
    output->write( | « { value } » | )->display( ).
  endmethod.

  method _1.
    data numchar type n length 3.
    numchar = 'ABC'.
    field-symbols <generic> type data.
    assign numchar to <generic>.
    assign <generic> to field-symbol(<casted_numchar>) casting type c.
    break( ).
    <casted_numchar> = cl_abap_codepage=>convert_from( `574154` ).
  endmethod.

  method _2.
    data(chr_number) = '1'.
    data(str_number) = `1`.
    break( ).
    data(number_equality) = xsdbool( chr_number = str_number ).

    data(chr_letter) = 'A'.
    data(str_letter) = `A`.
    break( ).
    data(letter_equality) = xsdbool( chr_letter = str_letter ).
    show( letter_equality ).

    data(chr_space) = ' '.
    data(str_space) = ` `.
    break( ).
    data(space_equality) = xsdbool( chr_space = str_space ).
    show( space_equality ).
  endmethod.

  method tables_bogus.
    data set type hashed table of ywatheline with unique key primary_key components id.
    insert value #( id = 1 numchar = '1234' ) into table set.
    break( ).
    insert value #( id = 1 numchar = '1234' ) into table set.
    "append value #( id = 1 numchar = '1234' ) to set. " This does a syntax error here
    data(parameters) = value abap_func_parmbind_tab(
        ( kind = abap_func_tables name = 'DATASET_LIKE' value = ref #( set ) )
      ).
    break( ).
    call function 'YWATFUNC' "destination 'NPL'
      parameter-table parameters.
    insert value #( id = 1 numchar = '1234' ) into table set.
  endmethod.

  method tabtype_relaxed_for_like.
    data set type hashed table of ywatheline with unique key primary_key components id.
    data(parameters) = value abap_func_parmbind_tab(
        ( kind = abap_func_tables name = 'DATASET_LIKE' value = ref #( set ) )
      ).
    break( ).
    call function 'YWATFUNC' "destination 'NPL'
      parameter-table parameters.
    break( ).
    insert value #( id = 1 numchar = '1234' ) into table set.
    clear set.
    parameters = value abap_func_parmbind_tab(
        ( kind = abap_func_tables name = 'DATASET_TYPE' value = ref #( set ) )
      ).
    break( ).
    call function 'YWATFUNC' "destination 'NPL'
      parameter-table parameters.
    break( ).
  endmethod.

  method _5.
    data str type ref to string.
    str = statics_ref( ).
    break( ).
    str->* = 'wUt'.
    str = statics_ref( ).
    break( ).
  endmethod.

  method statics_ref.
    statics hideous_thing type string value 'wAt'.
    ref = ref #( hideous_thing ).
  endmethod.
endclass.
