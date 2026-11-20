DROP DATABASE IF EXISTS worldcup;
CREATE DATABASE worldcup;
\connect worldcup

CREATE TABLE teams (team_id SERIAL PRIMARY KEY, name VARCHAR(50) UNIQUE NOT NULL);
CREATE TABLE games (game_id SERIAL PRIMARY KEY, year INT NOT NULL, round VARCHAR(30) NOT NULL, winner_id INT NOT NULL REFERENCES teams(team_id), opponent_id INT NOT NULL REFERENCES teams(team_id), winner_goals INT NOT NULL, opponent_goals INT NOT NULL);

WITH g(y, r, w, o, wg, og) AS (VALUES
  (2018,'Final','France','Croatia',4,2),
  (2018,'Third Place','Belgium','England',2,0),
  (2018,'Semi-Final','Croatia','England',2,1),
  (2018,'Semi-Final','France','Belgium',1,0),
  (2018,'Quarter-Final','Croatia','Russia',3,2),
  (2018,'Quarter-Final','England','Sweden',2,0),
  (2018,'Quarter-Final','Belgium','Brazil',2,1),
  (2018,'Quarter-Final','France','Uruguay',2,0),
  (2018,'Eighth-Final','England','Colombia',2,1),
  (2018,'Eighth-Final','Sweden','Switzerland',1,0),
  (2018,'Eighth-Final','Belgium','Japan',3,2),
  (2018,'Eighth-Final','Brazil','Mexico',2,0),
  (2018,'Eighth-Final','Croatia','Denmark',2,1),
  (2018,'Eighth-Final','Russia','Spain',2,1),
  (2018,'Eighth-Final','Uruguay','Portugal',2,1),
  (2018,'Eighth-Final','France','Argentina',4,3),
  (2014,'Final','Germany','Argentina',1,0),
  (2014,'Third Place','Netherlands','Brazil',3,0),
  (2014,'Semi-Final','Argentina','Netherlands',1,0),
  (2014,'Semi-Final','Germany','Brazil',7,1),
  (2014,'Quarter-Final','Netherlands','Costa Rica',1,0),
  (2014,'Quarter-Final','Argentina','Belgium',1,0),
  (2014,'Quarter-Final','Brazil','Colombia',2,1),
  (2014,'Quarter-Final','Germany','France',1,0),
  (2014,'Eighth-Final','Brazil','Chile',2,1),
  (2014,'Eighth-Final','Colombia','Uruguay',2,0),
  (2014,'Eighth-Final','France','Nigeria',2,0),
  (2014,'Eighth-Final','Germany','Algeria',2,1),
  (2014,'Eighth-Final','Netherlands','Mexico',2,1),
  (2014,'Eighth-Final','Costa Rica','Greece',2,1),
  (2014,'Eighth-Final','Argentina','Switzerland',1,0),
  (2014,'Eighth-Final','Belgium','United States',2,1)
  ), t AS (
    INSERT INTO teams(name) SELECT w FROM g UNION SELECT o FROM g ORDER BY 1 RETURNING team_id, name
  )
INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
SELECT g.y, g.r, tw.team_id, tl.team_id, g.wg, g.og FROM g JOIN t tw ON tw.name = g.w JOIN t tl ON tl.name = g.o;
