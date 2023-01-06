-- Provide the Spanish athletes whose name begins with PE, ordered
-- descending by its identifier. We want to get the identifier, name, country and
-- substitute identifier.
SELECT a.*
FROM olimpic.tb_athlete a
WHERE a.country = 'ESP' and 
        a.name LIKE 'PE%'
ORDER BY a.athlete_id DESC;

-- Provide the list of French athletes who practice some discipline of jumping, ordered
-- ascending by the name of the discipline and descending by its name.
-- We want to get the discipline name, athlete name, and athlete identifier.
SELECT a.name, d.name, a.athlete_id
FROM olimpic.tb_athlete a, olimpic.tb_discipline d
WHERE a.country LIKE 'FRA' and
        d.type LIKE 'JUMP'
ORDER BY d.name ASC, a.name DESC; 

-- Provide discipline with more participating athletes. We want to get the identifier of
-- discipline, name and total number of athletes.
SELECT p.discipline_id, d.name, COUNT(p.discipline_id) AS total_participants
FROM olimpic.tb_play p, olimpic.tb_discipline d
WHERE p.discipline_id = d.discipline_id
GROUP BY p.discipline_id, d.name
ORDER BY total_participants DESC LIMIT 1;

-- Provide the list of athletes who participate in more than one discipline. 
-- We want to see the id of the athletes, the name, the country and 
-- the total number of disciplines they practice.
SELECT a.athlete_id, a.name, a.country, COUNT(p.athlete_id) AS different_sports
FROM olimpic.tb_athlete a, olimpic.tb_play p
WHERE a.athlete_id = p.athlete_id
GROUP BY a.athlete_id, a.name, a.country
HAVING COUNT(*) > 1;

-- Provide the list of athletes who have participated in the most heats. 
-- We want to see the - id of the athletes, the name, the discipline and 
-- the total number of batches in which they have participated.
SELECT re.athlete_id, a.name, d.name, COUNT(re.athlete_id) AS tandas_participadas
FROM olimpic.tb_register re, olimpic.tb_discipline d, olimpic.tb_athlete a
WHERE a.athlete_id = re.athlete_id AND re.discipline_id = d.discipline_id
GROUP BY re.athlete_id, a.name, d.name
HAVING COUNT(re.athlete_id) > 3
ORDER BY tandas_participadas DESC;
