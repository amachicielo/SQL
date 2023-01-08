------------------------------------------------------------------------------------------------
--
-- Create database
--
------------------------------------------------------------------------------------------------

-- CREATE DATABASE dbdw_pec3;


SET search_path TO dbdw_pec3;

------------------------------------------------------------------------------------------------
--
-- Drop tables
--
------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS olympic.tb_register;
DROP TABLE IF EXISTS olympic.tb_round;
DROP TABLE IF EXISTS olympic.tb_play;
DROP TABLE IF EXISTS olympic.tb_athlete;
DROP TABLE IF EXISTS olympic.tb_discipline;
DROP TABLE IF EXISTS olympic.tb_collaborator;
DROP TABLE IF EXISTS olympic.tb_collaborate;
DROP TABLE IF EXISTS olympic.tb_sponsor;
DROP TABLE IF EXISTS olympic.tb_finance;

------------------------------------------------------------------------------------------------
--
-- Drop schema
--
------------------------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS olympic;

------------------------------------------------------------------------------------------------
--
-- Create schema
--
------------------------------------------------------------------------------------------------

CREATE SCHEMA olympic;

------------------------------------------------------------------------------------------------
--
-- Create table tb_discipline
--
------------------------------------------------------------------------------------------------

CREATE TABLE olympic.tb_discipline  (
  discipline_id  INT NOT NULL,
  name           CHARACTER VARYING(50) NOT NULL,
  inventor       CHARACTER VARYING(50) NOT NULL,
  type           CHARACTER VARYING(10) NOT NULL,
  object_type    CHARACTER VARYING(20) DEFAULT NULL, 
  CONSTRAINT ck_discipline_type CHECK (type IN ('RUN', 'JUMP', 'THROW')),
  CONSTRAINT pk_discipline PRIMARY KEY (discipline_id)
);

------------------------------------------------------------------------------------------------
--
-- Create table tb_athlete  
--
------------------------------------------------------------------------------------------------

CREATE TABLE olympic.tb_athlete    (
  athlete_id    CHARACTER(7) NOT NULL,
  name          CHARACTER VARYING(50) NOT NULL,
  country       CHARACTER VARYING(3) NOT NULL,
  substitute_id  CHARACTER(7) DEFAULT NULL,
  CONSTRAINT pk_athlete PRIMARY KEY (athlete_id),
  CONSTRAINT fk_athlete_substitute FOREIGN KEY (substitute_id) REFERENCES olympic.tb_athlete (athlete_id)
);

------------------------------------------------------------------------------------------------
--
-- Create table tb_play
--
------------------------------------------------------------------------------------------------

CREATE TABLE olympic.tb_play    (
  athlete_id    CHARACTER(7) NOT NULL,
  discipline_id  INT NOT NULL,
  CONSTRAINT pk_play PRIMARY KEY (athlete_id, discipline_id),
  CONSTRAINT fk_play_athlete FOREIGN KEY (athlete_id) REFERENCES olympic.tb_athlete (athlete_id),
  CONSTRAINT fk_play_discipline FOREIGN KEY (discipline_id) REFERENCES olympic.tb_discipline (discipline_id)
);

------------------------------------------------------------------------------------------------
--
-- Create table tb_round  
--
------------------------------------------------------------------------------------------------

CREATE TABLE olympic.tb_round (
  round_number  INT NOT NULL,
  discipline_id INT NOT NULL,
  CONSTRAINT pk_round PRIMARY KEY (discipline_id, round_number),
  CONSTRAINT fk_round_discipline FOREIGN KEY (discipline_id) REFERENCES olympic.tb_discipline (discipline_id)
);

------------------------------------------------------------------------------------------------
--
-- Create table tb_register  
--
------------------------------------------------------------------------------------------------

CREATE TABLE olympic.tb_register (
  athlete_id    CHARACTER(7) NOT NULL,
  round_number  INT NOT NULL,
  discipline_id INT NOT NULL,
  register_date  DATE NOT NULL DEFAULT CURRENT_DATE,
  register_position INT DEFAULT NULL,
  register_time     TIME DEFAULT NULL,
  register_measure  REAL DEFAULT NULL,
  CONSTRAINT pk_register PRIMARY KEY (athlete_id, round_number, discipline_id),
  CONSTRAINT fk_register_athlete FOREIGN KEY (athlete_id) REFERENCES olympic.tb_athlete (athlete_id),
  CONSTRAINT fk_register_round FOREIGN KEY (discipline_id, round_number) REFERENCES olympic.tb_round (discipline_id, round_number)
);

------------------------------------------------------------------------------------------------
--
-- Create table tb_collaborator
--
------------------------------------------------------------------------------------------------

CREATE TABLE olympic.tb_collaborator (
  dni VARCHAR(20) NOT NULL,
  name    VARCHAR(100) NOT NULL,
  CONSTRAINT pk_collaborator PRIMARY KEY (dni)
);

------------------------------------------------------------------------------------------------
--
-- Create table tb_collaborate
--
------------------------------------------------------------------------------------------------

CREATE TABLE olympic.tb_collaborate (
  athlete_id    CHARACTER(7) NOT NULL,
  collaborator_dni  VARCHAR(20) NOT NULL,
  CONSTRAINT pk_collaborate  PRIMARY KEY (athlete_id, collaborator_dni),
  CONSTRAINT fk_collaborate_athlete FOREIGN KEY (athlete_id) REFERENCES olympic.tb_athlete (athlete_id),
  CONSTRAINT fk_collaborate_collaborator  FOREIGN KEY (collaborator_dni) REFERENCES olympic.tb_collaborator (dni)
);

------------------------------------------------------------------------------------------------
--
-- Create table tb_sponsor
--
------------------------------------------------------------------------------------------------

CREATE TABLE olympic.tb_sponsor (
	name    VARCHAR(100) NOT NULL,
  CONSTRAINT pk_sponsor PRIMARY KEY (name)
);

------------------------------------------------------------------------------------------------
--
-- Create table tb_finance
--
------------------------------------------------------------------------------------------------

CREATE TABLE olympic.tb_finance    (
  athlete_id    CHARACTER(7) NOT NULL,
  sponsor_name  VARCHAR(100) NOT NULL,
  CONSTRAINT pk_finance  PRIMARY KEY (athlete_id, sponsor_name),
  CONSTRAINT fk_finance_athlete FOREIGN KEY (athlete_id) REFERENCES olympic.tb_athlete (athlete_id),
  CONSTRAINT fk_finance_sponsor  FOREIGN KEY (sponsor_name) REFERENCES olympic.tb_sponsor (name)
);
