
CREATE OR REPLACE FUNCTION F_ValidateDPI(CUI IN VARCHAR)
RETURN CHAR
IS
    VALID CHAR(1);
    DEPARTMENT CHAR(2);
    MUNICIPALITY CHAR(2);
    NUM CHAR(8);
    CHECKER CHAR(1);
    TOTAL INT;
    MODULO INT;
        
    i INT;
        
    TYPE NumList IS TABLE OF NUMBER;
    DEPARTMENTS NumList := NumList(17, 8, 16, 16, 13, 14, 19, 8, 24, 21, 9, 30, 32, 21, 8, 17, 14, 5, 11, 11, 7, 17);
BEGIN
    DEPARTMENT := SUBSTR(CUI,10,2);
    MUNICIPALITY := SUBSTR(CUI,12,2);
    NUM := SUBSTR(CUI,1,8);
    CHECKER := SUBSTR(CUI,9,1);
   
   IF F_Is_Numeric(CUI) = 1 THEN
     IF LENGTH(CUI) <> 13 THEN
      VALID := 'N';
      RAISE_APPLICATION_ERROR( -20001, 'CUI con un número incorrecto de caracteres.' );
     ELSE 
        IF TO_NUMBER(DEPARTMENT) = 0 OR TO_NUMBER(MUNICIPALITY)= 0 THEN
          VALID := 'N';
          RAISE_APPLICATION_ERROR( -20001, 'CUI con código de municipio o departamento inválido.' );
        ELSE
          IF TO_NUMBER(DEPARTMENT) > DEPARTMENTS.COUNT THEN
            VALID := 'N';
            RAISE_APPLICATION_ERROR( -20001, 'CUI con código de departamento inválido.' );
          ELSE
            IF TO_NUMBER(MUNICIPALITY) > DEPARTMENTS(DEPARTMENT) THEN
              VALID := 'N';
              RAISE_APPLICATION_ERROR( -20001, 'CUI con código de municipio inválido.' );
            ELSE
              i := 0;
              TOTAL := 0;
              
              WHILE i < LENGTH(NUM) LOOP
                TOTAL := TOTAL + TO_NUMBER(SUBSTR(NUM, i + 1, 1)) * (i + 2);
                i := i + 1;
              END LOOP;
              
              MODULO := MOD(TOTAL, 11);
              IF MODULO = CHECKER THEN
                VALID := 'S';
              ELSE
                VALID := 'N';
                RAISE_APPLICATION_ERROR( -20001, 'CUI no ha superado las pruebas de verificación.' );
              END IF;
            END IF;
          END IF;
        END IF;
     END IF;
   ELSE 
    VALID := 'N';
    RAISE_APPLICATION_ERROR( -20001, 'CUI con caracteres no validos.' );
   END IF;
   RETURN VALID;
END;
