-- Create the DATABASE

-- Create the SCHEMA to work on

CREATE SCHEMA olimpic;

SET search_path TO olimpic, "$user", public;

-- Create tables
BEGIN WORK;

-- tipo disciplina (type) solamente puede tener los valores RUN, JUMP o THROW
CREATE TABLE tb_discipline
(
    discipline_id INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    inventor VARCHAR(50) NOT NULL,
    type VARCHAR(10) NOT NULL,
    object_type CHAR(20) DEFAULT NULL,
    CONSTRAINT pk_tb_discipline PRIMARY KEY(discipline_id)
);

CREATE TABLE tb_athlete
(
    athlete_id CHAR(7) NOT NULL,
    name VARCHAR(50) NOT NULL,
    country CHAR(3) NOT NULL,
    substitute_id CHAR(7), 
    CONSTRAINT pk_tb_athlete PRIMARY KEY(athlete_id),
    CONSTRAINT fk_tb_athlete FOREIGN KEY(substitute_id) REFERENCES tb_athlete(athlete_id)
);

CREATE TABLE tb_play
(
    athlete_id CHAR(7) NOT NULL,
    discipline_id INTEGER NOT NULL,
    CONSTRAINT pk_tb_play PRIMARY KEY(athlete_id, discipline_id),
    CONSTRAINT fk_tb_athlete FOREIGN KEY(athlete_id) REFERENCES tb_athlete(athlete_id),
    CONSTRAINT fk_tb_discipline FOREIGN KEY(discipline_id) REFERENCES tb_discipline(discipline_id) 
);

CREATE TABLE tb_round
(
    round_number INTEGER NOT NULL,
    discipline_id INTEGER NOT NULL,
    CONSTRAINT pk_tb_round PRIMARY KEY(round_number, discipline_id),
    CONSTRAINT fk_tb_discipline FOREIGN KEY(discipline_id) REFERENCES tb_discipline(discipline_id)
);

CREATE TABLE tb_register
(
    athlete_id CHAR(7) NOT NULL,
    round_number INTEGER NOT NULL,
    discipline_id INTEGER NOT NULL,
    register_date DATE DEFAULT CURRENT_DATE,
    register_position INTEGER,
    register_time TIME,
    register_measure REAL,
    CONSTRAINT pk_tb_register PRIMARY KEY(athlete_id, round_number, discipline_id),
    CONSTRAINT fk_tb_athlete FOREIGN KEY(athlete_id) REFERENCES tb_athlete(athlete_id),
    CONSTRAINT fk_tb_round FOREIGN KEY(round_number, discipline_id) 
        REFERENCES tb_round(round_number, discipline_id)
);

COMMIT WORK;
