FUNCTION YWATFUNC.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      DATASET_LIKE STRUCTURE  YWATHELINE OPTIONAL
*"      DATASET_TYPE TYPE  YWATHETABLE OPTIONAL
*"----------------------------------------------------------------------
" Declaring tables with a defined standard table TYPE properly raises a dump, but with LIKE...
  append value #( id = 1 numchar = '1234' ) to dataset_like.
  append value #( id = 1 numchar = '1234' ) to dataset_type.

endfunction.
