BEGIN WORK;
SET SEARCH_PATH TO olympic;

SELECT 
JSON_ARRAY(JSON_OBJECT('Correo electrónico patrocinador', tbc.email, 'Nombre patrocinador', s.name,
'Nombre atleta', a.name, 'Nombre disciplina', d.name, 'Número de tanda', r.round_number, 'Marca del atleta', r.register_measure,
'Posición en la tanda', r.register_position, 'Fecha de la información', r.register_ts))
FROM tb_collaborator tbc, tb_sponsor s, tb_athlete a, tb_discipline d, tb_register r;
