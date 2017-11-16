CREATE OR REPLACE FUNCTION F_Is_Numeric( str IN VARCHAR2 )
  RETURN NUMBER
IS
  num NUMBER;
BEGIN
  num := to_number( str );
  RETURN 1;
EXCEPTION
  WHEN value_error
  THEN
    RETURN 0;
END;