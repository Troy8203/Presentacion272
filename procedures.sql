--BASE
CREATE OR REPLACE PROCEDURE procedure_name (param1 datatype, param2 datatype)
IS
BEGIN
    -- cuerpo del procedimientos
END procedure_name;
EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('No data found');
            param1 := value_default;
            param2 := value_default;
---QUERY1
SELECT name || ' ' || last_name as complete_name
FROM customer
WHERE id=1
---QUERY2
SELECT convert_to_dolar(id) as dollar
FROM customer
WHERE id=1
--QUERY3
SELECT (EXTRACT(YEAR FROM SYSDATE) - age) AS year_of_birth
FROM customer
WHERE id=1
---FUNCTION SOLUTION
CREATE OR REPLACE PROCEDURE procedure_name 
(xid IN NUMBER, xname OUT VARCHAR2, xdollar OUT NUMBER, xyear OUT NUMBER)
IS
BEGIN
    -- cuerpo del procedimientos
    SELECT name || ' ' || last_name as complete_name INTO xname
        FROM customer
        WHERE id=xid;
    
    SELECT convert_to_dolar(id) as dollar INTO xdollar
        FROM customer
        WHERE id=xid;

    SELECT (EXTRACT(YEAR FROM SYSDATE) - age) AS year_of_birth INTO xyear
        FROM customer
        WHERE id=xid;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('No data found');
            xname := 'No data found';
            xdollar := 0;
            xyear := 0;
END procedure_name;
---EXE
DECLARE
    xid NUMBER;
    xname VARCHAR2(50);
    xdollar NUMBER;
    xyear NUMBER;
BEGIN
    xid := 1;
    procedure_name(xid, xname, xdollar, xyear);
    dbms_output.put_line('Nombre completo: '||xname);
    dbms_output.put_line('Salario en Dolares: '||xdollar);
    dbms_output.put_line('Año de nacimiento: '||xyear);
END;




--postgress
CREATE OR REPLACE FUNCTION procedure_name
(xid NUMERIC, OUT xname VARCHAR, OUT xdollar NUMERIC, OUT xyear NUMERIC)
AS $$
BEGIN
    -- cuerpo del procedimiento
    SELECT name || ' ' || last_name INTO xname
        FROM customer
        WHERE id = xid;
    
    SELECT convert_to_dollar(id) INTO xdollar
        FROM customer
        WHERE id = xid;

    SELECT EXTRACT(YEAR FROM CURRENT_DATE) - age INTO xyear
        FROM customer
        WHERE id = xid;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE NOTICE 'No data found';
            xname := 'No data found';
            xdollar := 0;
            xyear := 0;
END $$ LANGUAGE plpgsql;


--mysql
DELIMITER //

CREATE PROCEDURE procedure_name 
(IN xid INT, OUT xname VARCHAR(255), OUT xdollar DECIMAL(10,2), OUT xyear INT)
BEGIN
    -- cuerpo del procedimiento
    SELECT CONCAT(name, ' ', last_name) INTO xname
        FROM customer
        WHERE id = xid;
    
    SELECT convert_to_dollar(id) INTO xdollar
        FROM customer
        WHERE id = xid;

    SELECT YEAR(CURDATE()) - age INTO xyear
        FROM customer
        WHERE id = xid;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No data found';
        SET xname = 'No data found';
        SET xdollar = 0;
        SET xyear = 0;
    END IF;
END //

DELIMITER ;


--sql server
CREATE OR ALTER PROCEDURE procedure_name
    @xid INT,
    @xname VARCHAR(255) OUTPUT,
    @xdollar NUMERIC OUTPUT,
    @xyear INT OUTPUT
AS
BEGIN
    -- cuerpo del procedimiento
    SELECT @xname = name + ' ' + last_name
        FROM customer
        WHERE id = @xid;
    
    SELECT @xdollar = dbo.convert_to_dollar(@xid)
        FROM customer
        WHERE id = @xid;

    SELECT @xyear = YEAR(GETDATE()) - age
        FROM customer
        WHERE id = @xid;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No data found';
        SET @xname = 'No data found';
        SET @xdollar = 0;
        SET @xyear = 0;
    END
END;
