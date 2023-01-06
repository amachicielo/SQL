BEGIN WORK;
SET SEARCH_PATH TO olympic;

-- Modify the current name register_date to register_ts
ALTER TABLE tb_register RENAME register_date TO register_ts;

-- Change date type to timestamp
ALTER TABLE tb_register ALTER COLUMN register_ts TYPE TIMESTAMP;

-- Automatically update when inserting a new row of information, 
-- Do not allow storing null values
CREATE FUNCTION verify_data() 
RETURNS TRIGGER AS $$ 
DECLARE 
    valor_nuevo TIMESTAMP;
BEGIN
    IF (NEW.register_ts IS NOT NULL) THEN
        valor_nuevo = NEW.register_ts; 
    ELSE 
        valor_nuevo = OLD.register_ts;
    END IF;
    RETURN valor_nuevo;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER TB_REGISTER_BU
BEFORE UPDATE OF register_ts ON tb_register
FOR EACH ROW
EXECUTE PROCEDURE verify_data();

COMMIT WORK;
---------------------------------------------------------------------------------------------------------
BEGIN WORK;
SET SEARCH_PATH TO olympic;

-- New attribute register_updated of type timestamp (allows NULLs) in the REGISTER(tb_register) table.
ALTER TABLE tb_register ADD register_updated TIMESTAMP default NULL;

-- Create function fn_register_inserted to fill the register_updated attribute.
CREATE FUNCTION fn_register_inserted() 
RETURNS TRIGGER AS $$ 
DECLARE 
    valor_nuevo TIMESTAMP;
BEGIN
    IF (NEW.register_ts <> OLD.register_updated) THEN
        valor_nuevo = NEW.register_ts; 
    ELSE 
        RAISE EXCEPTION
            'El valor % ya está en el registro', NEW.register_ts;
    END IF;
    RETURN valor_nuevo;
END
$$ LANGUAGE plpgsql;

-- This function will be executed by the tg_register_inserted trigger
-- whenever a new record is entered.
CREATE TRIGGER tg_register_inserted
BEFORE UPDATE OF register_ts ON tb_register
FOR EACH ROW
EXECUTE PROCEDURE fn_register_inserted();

-- Value register_updated same as entered in register_ts.
UPDATE tb_register SET register_updated = register_ts;

COMMIT WORK;
---------------------------------------------------------------------------------------------------------
BEGIN WORK;
SET SEARCH_PATH TO olympic;

-- Function fn_register_updated to update the value of the register_updated attribute,
-- from the REGISTER(tb_register) table, when there is ONE modification of ANY other value
-- of the attributes of the information TUPLE.
CREATE OR REPLACE FUNCTION fn_register_updated()
RETURNS TRIGGER AS $$ 
BEGIN 
-- The value of the register_updated attribute will be the current date and time.
-- The function must use an update statement to update the register_updated attribute
UPDATE tb_register SET register_updated = CURRENT_TIMESTAMP;
RETURN NULL;
END
$$ LANGUAGE plpgsql;

-- This function will be executed by the tg_register_updated trigger.
CREATE TRIGGER tg_register_updated
AFTER UPDATE ON tb_register
FOR EACH STATEMENT
EXECUTE PROCEDURE fn_register_updated();

COMMIT WORK;
