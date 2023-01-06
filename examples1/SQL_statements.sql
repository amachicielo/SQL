BEGIN WORK;
-- They tell us that it is necessary to insert 3 new athletes according to the given specification.
INSERT INTO olimpic.tb_athlete 
(
	athlete_id,name,country,substitute_id
)
	VALUES 
   ('0000001','REMBRAND Luc', 'FRA', NULL),
   ('0000002', 'SMITH Mik', 'ENG', NULL),
   ('0000003', 'LEWIS Carl', 'USA', NULL);

-- They ask us to add a new restriction to prevent the presence of Spanish athletes no substitute.
ALTER TABLE olimpic.tb_athlete 
ADD CONSTRAINT NN_tb_athlete_substitute_id
CHECK(substitute_id <> NULL)
-- or
CREATE ASSERTION substitutes_spn_NN 
CHECK (NOT EXISTS(SELECT * FROM olimpic.tb_athlete a
                WHERE a.country = 'ESP' and  a.substitute_id is null));

-- Implement a view olympic.exercise 33 on query a) from exercise 2. 
-- Make sure that users cannot insert values that initially should not be displayed to
-- through sight.
CREATE VIEW olimpic.exercise33 (athlete_id, name, country, substitute_id) AS
(SELECT a.athlete_id, a.name, a.country, a.substitute_id
FROM olimpic.tb_athlete a
WHERE a.country = 'ESP' AND a.name LIKE 'PE%');

-- We are asked to add a column in the tb_athlete table called date_add,
-- which represents the date of registration in the federation of your country. This field cannot have
null values and will default to the current date.
ALTER TABLE olimpic.tb_athlete
ADD COLUMN data_add DATE NOT NULL DEFAULT CURRENT_DATE;

-- You have to create a system user (careful! not to be confused with tb_user) registerer -- with access to the olimpic scheme and password 1234. This user can perform readings,
-- inserts, updates, deletes (never truncations) of the tb_register table, and
-- read permissions on the tb_athlete table. 
-- You will not be able to access the other tables in the olympic scheme Assign 
-- the necessary permissions to that user using SQL.
-- Also make sure that this user cannot assign permissions to other users on
-- said tables.
CREATE ROLE registerer WITH
LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOREPLICATION
PASSWORD '1234';
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE olimpic.tb_register TO registerer;
GRANT SELECT ON TABLE olimpic.tb_athlete TO registerer;


COMMIT WORK;
