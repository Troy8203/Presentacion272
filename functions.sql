--BASE
CREATE OR REPLACE FUNCTION function_name(param1 datatype, param2 datatype)
RETURN return_datatype
IS
    output_value return_datatype;
BEGIN
    -- cuerpo de la función
    RETURN output_value;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN value_default;
END function_name;
--QUERY
SELECT ROUND(SUM(SALARY/6.91), 2) AS salary_dolar
FROM customer
WHERE id = 1;
---FUNCTION SOLUTION
CREATE OR REPLACE FUNCTION convert_to_dolar(xid IN NUMBER)
RETURN NUMBER
IS
    salary_dolar NUMBER;
BEGIN
    -- cuerpo de la función
    SELECT ROUND(SUM(SALARY/6.91), 2) AS salary_dolar INTO salary_dolar
      FROM customer
      WHERE id = xid;

    RETURN salary_dolar;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END convert_to_dolar;
---EXE
SELECT convert_to_dolar(1) FROM dual;
---EXE
SELECT customer.*, convert_to_dolar(id) AS dolar
FROM customer;


--postgress
CREATE OR REPLACE FUNCTION convert_to_dolar(xid NUMERIC)
RETURNS NUMERIC AS $$
DECLARE
    salary_dolar NUMERIC;
BEGIN
    -- Cuerpo de la función
    SELECT ROUND(SUM(SALARY/6.91), 2) INTO salary_dolar
    FROM customer
    WHERE id = xid;

    RETURN salary_dolar;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
$$ LANGUAGE plpgsql;

--mysql
DELIMITER //

CREATE FUNCTION convert_to_dolar(xid INT)
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE salary_dolar DECIMAL(10, 2);

    -- Cuerpo de la función
    SELECT ROUND(SUM(SALARY/6.91), 2) INTO salary_dolar
    FROM customer
    WHERE id = xid;

    IF salary_dolar IS NULL THEN
        RETURN 0;
    ELSE
        RETURN salary_dolar;
    END IF;
END//

DELIMITER ;

--sql server
CREATE OR ALTER FUNCTION convert_to_dolar(@xid INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @salary_dolar DECIMAL(10, 2);

    -- Cuerpo de la función
    SELECT @salary_dolar = ROUND(SUM(SALARY/6.91), 2)
    FROM customer
    WHERE id = @xid;

    IF @salary_dolar IS NULL
        RETURN 0;
    ELSE
        RETURN @salary_dolar;
END;
GO