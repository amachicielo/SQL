BEGIN WORK;
SET SEARCH_PATH TO olympic;

-- Domain email_type
CREATE DOMAIN email_type AS CHARACTER VARYING(320) DEFAULT NULL;

-- Create a new column "email" of type email_type in SPONSORS(tb_sponsor) and COLLABORATORS(tb_collaborator).
ALTER TABLE tb_sponsor ADD email email_type;
ALTER TABLE tb_collaborator ADD email email_type;

-- Check if the entered value is correct.
CREATE FUNCTION verificar_email() 
RETURNS TRIGGER AS $$ 
DECLARE 
    valor_nuevo email_type;
BEGIN

    IF (NEW.email LIKE "%@%") THEN
        valor_nuevo = NEW.email; 
    ELSE 
        RAISE EXCEPTION
            'El email % introducido es incorrecto', NEW.email;
    END IF;
    RETURN valor_nuevo;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_email_updated
BEFORE UPDATE OF email ON tb_sponsor
FOR EACH ROW
EXECUTE PROCEDURE verificar_email();

CREATE TRIGGER tg_email_updated
BEFORE UPDATE OF email ON tb_collaborator
FOR EACH ROW
EXECUTE PROCEDURE verificar_email();

COMMIT WORK;
---------------------------------------------------------------------------------------------------------
BEGIN WORK;
SET SEARCH_PATH TO olympic;

CREATE TABLE tb_athletes_info_log(
    athlete_id CHAR(7) NOT NULL,
    discipline_id INTEGER NOT NULL,
    round_number INTEGER NOT NULL,
    athlete_name VARCHAR(50) NOT NULL,
    discipline_name VARCHAR(50) NOT NULL,
    mark VARCHAR(12) NOT NULL,
    rating INTEGER NOT NULL,
    info_log_dt DATE,

    CONSTRAINT pk_tb_athletes_info_log PRIMARY KEY (athlete_id, discipline_id, round_number),
    CONSTRAINT fk_tb_register FOREIGN KEY (athlete_id, discipline_id, round_number) REFERENCES tb_register(athlete_id, discipline_id, round_number)
);

CREATE OR REPLACE FUNCTION insert_tb_athletes_info_log()
RETURNS TRIGGER AS $$ 
DECLARE
register_ts DATE;
BEGIN
register_ts = to_date(NEW.info_log_dt, 'DD Mon YYYY');
INSERT INTO tb_athletes_info_log VALUES(
    NEW.athlete_id, NEW.discipline_id, NEW.round_number, NEW.athlete_name, 
    NEW.discipline_name, NEW.mark, NEW.rating, register_ts
    );
    RETURN NULL;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tb_athletes_info_log_updated
AFTER UPDATE ON tb_register
FOR EACH ROW
EXECUTE PROCEDURE insert_tb_athletes_info_log();

COMMIT WORK;
---------------------------------------------------------------------------------------------------------
BEGIN WORK;
SET SEARCH_PATH TO olympic;

CREATE OR REPLACE FUNCTION fn_athletes_info()
RETURNS TRIGGER AS $$ 

BEGIN
IF (NEW.register_time IS NULL) THEN
    NEW.mark = to_char(NEW.register_measure::real, '999D99');
ELSE
    NEW.mark = to_char(NEW.register_time);
END IF;
INSERT INTO tb_athletes_info_log VALUES(NEW.athlete_id, NEW.round_number, NEW.discipline_id, 
tb_athlete.name, tb_discipline.name, NEW.mark, NEW.rating, to_date(NEW.info_log_dt, 'DD Mon YYYY'));
RETURN NULL;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_athletes_info_U
AFTER INSERT OR UPDATE OR DELETE ON tb_register
FOR EACH STATEMENT
EXECUTE PROCEDURE fn_athletes_info();

COMMIT WORK;
---------------------------------------------------------------------------------------------------------
BEGIN WORK;
SET SEARCH_PATH TO olympic;

CREATE TYPE info_by_sponsor AS (
    email email_type,
    name_patrocinador VARCHAR(100),
    name_athlete VARCHAR(50),
    name_discipline VARCHAR(50),
    number_round INTEGER,
    mark_athlete CHAR(12),
    position_round INTEGER,
    fecha DATE
);

CREATE FUNCTION fn_get_info_by_sponsor(select_date DATE, sponsor VARCHAR(100))
RETURNS info_by_sponsor AS $$
DECLARE
    data_sponsor info_by_sponsor;
BEGIN 
    SELECT tbc.email, s.name, a.name, d.name, r.round_number, r.register_measure, r.register_position, r.register_ts
    INTO data_sponsor
    FROM tb_collaborator tbc, tb_sponsor s, tb_athlete a, tb_discipline d, tb_register r;
    RETURN data_sponsor;

END;
$$LANGUAGE plpgsql;

COMMIT WORK;
