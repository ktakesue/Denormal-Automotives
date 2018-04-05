--Create a new postgres user named normal_user
-- CREATE USER normal_user;
--Create a new database named normal_cars owned by normal_user
-- CREATE DATABASE normal_cars OWNER normal_user;

--Run the provided `scripts/denormal_data.sql` script on the `normal_cars` database.

--In `normal_cars.sql` Create a query to generate the tables needed 
--to accomplish your normalized schema, including any primary and foreign key constraints
-- Logical renaming of columns is allowed.

DROP TABLE IF EXISTS makes CASCADE;
CREATE TABLE makes (
    make_id     serial       NOT NULL PRIMARY KEY,
    make_code   varchar(125) NOT NULL,
    make_title  varchar(125) NOT NULL
);

DROP TABLE IF EXISTS models CASCADE;
CREATE TABLE models (
    model_id    serial       NOT NULL PRIMARY KEY,
    model_code  varchar(125) NOT NULL,
    model_title varchar(125) NOT NULL,
    make_id     integer     REFERENCES makes(make_id)
);

DROP TABLE IF EXISTS years CASCADE;
CREATE TABLE years (
    year       integer      NOT NULL,
    model_id   integer      REFERENCES models(model_id)
);

--Create queries to insert **all** of the data that was in the `car_models` table, 
--into the new normalized tables of the `normal_cars` database

INSERT INTO makes (make_code, make_title) SELECT DISTINCT make_code, make_title 
FROM car_models;

INSERT INTO models (model_code, model_title, make_id) SELECT DISTINCT car_models.model_code, car_models.model_title, makes.make_id
FROM makes INNER JOIN car_models ON car_models.make_code = makes.make_code AND car_models.make_title = makes.make_title;

INSERT INTO years (year, model_id) SELECT DISTINCT car_models.year, models.model_id FROM car_models 
INNER JOIN makes ON car_models.make_code = makes.make_code AND car_models.make_title = makes.make_title 
INNER JOIN models ON car_models.model_code = models.model_code AND car_models.model_title = models.model_title;
--SELECT DISTINCT models.model_id, car_models.year FROM models INNER JOIN car_models ON models.model_code = car_models.model_code AND models.model_title = car_models.model_title;

--In `normal_cars.sql`, create a query to get a list of all `make_title` values in the `car_models` table. 
--Without any duplicate rows, this should have 71 results.

    --example of subquery 
    --SELECT COUNT(*) FROM (SELECT DISTINCT make_code, make_title FROM car_models) x;
    --SELECT COUNT(*) FROM (SELECT DISTINCT car_models.model_code, car_models.model_title, makes.make_id FROM makes INNER JOIN car_models USING (make_code))x;

SELECT DISTINCT car_models.make_title FROM makes INNER JOIN car_models ON car_models.make_title = makes.make_title;

--In `normal_cars.sql`, create a query to list all `model_title` values 
--where the `make_code` is `'VOLKS'` Without any duplicate rows, this should have 27 results.

SELECT DISTINCT models.model_title FROM models INNER JOIN makes ON models.make_id = makes.make_id 
WHERE makes.make_code LIKE '%VOLKS%';

--In `normal_cars.sql`, create a query to list all `make_code`, `model_code`, `model_title`, 
--and year from `car_models` where the `make_code` is `'LAM'`. 
--Without any duplicate rows, this should have 136 rows.

SELECT DISTINCT car_models.make_code, car_models.model_code, car_models.model_title, car_models.year
FROM car_models INNER JOIN makes ON car_models.make_code = makes.make_code
WHERE makes.make_code LIKE '%LAM%';

--In `normal_cars.sql`, create a query to list all fields from all `car_models` in years between `2010` and `2015`.
--Without any duplicate rows, this should have 7884 rows.

SELECT DISTINCT * FROM car_models WHERE year BETWEEN 2010 AND 2015;