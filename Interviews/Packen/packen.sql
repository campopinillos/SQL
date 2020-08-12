-- Prueba Packen
-- Base de datos PostgreSQL

CREATE DATABASE packen;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Load data

CREATE TABLE shipments (
  id uuid DEFAULT uuid_generate_v4 (),
  driver_id INT,
  city_id INT,
  timestamp TIMESTAMP,
  status VARCHAR(20),
  PRIMARY KEY (id)
);

COPY shipments(id, driver_id, city_id, timestamp, status)
FROM '/Users/campopinillos/Downloads/shipments.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE drivers (
  id INT,
  driver VARCHAR(50));

COPY drivers(id, driver)
FROM '/Users/campopinillos/Downloads/drivers.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE cities (
  id INT,
  city VARCHAR(50));

COPY cities(id, city)
FROM '/Users/campopinillos/Downloads/cities.csv'
DELIMITER ','
CSV HEADER;


-- 1) How many deliveries occurred in each city?
SELECT city_id, cities.city, status, COUNT(*) AS Deliveries 
FROM shipments
JOIN cities ON city_id = cities.id
GROUP BY city_id, cities.city, status 
HAVING status='delivered' 
ORDER BY city_id;

--  1) When did the first delivery occur in each city? 
SELECT DISTINCT ON (city_id) cities.city, status, timestamp 
FROM shipments
JOIN cities ON city_id = cities.id
WHERE status='delivered' 
ORDER BY city_id, timestamp ASC;

-- 1) Single Query for question 1

SELECT q1.city_id, city, Deliveries, First_ship FROM (
SELECT city_id, cities.city, status, COUNT(*) AS Deliveries 
FROM shipments
JOIN cities ON city_id = cities.id
GROUP BY city_id, cities.city, status 
HAVING status='delivered' 
ORDER BY city_id) AS q1
JOIN (
SELECT DISTINCT ON (city_id) city_id, timestamp AS First_ship
FROM shipments
WHERE status='delivered' 
ORDER BY city_id, timestamp ASC) AS q2
ON q1.city_id=q2.city_id;

-- Exportando csv
COPY (
  SELECT q1.city_id, city, Deliveries, First_ship FROM (
    SELECT city_id, cities.city, status, COUNT(*) AS Deliveries 
    FROM shipments
    JOIN cities ON city_id = cities.id
    GROUP BY city_id, cities.city, status 
    HAVING status='delivered' 
    ORDER BY city_id) AS q1
    JOIN (
    SELECT DISTINCT ON (city_id) city_id, timestamp AS First_ship
    FROM shipments
    WHERE status='delivered' 
    ORDER BY city_id, timestamp ASC) AS q2
  ON q1.city_id=q2.city_id
) TO '/Users/campopinillos/Downloads/pregunta1.csv' DELIMITER ',' CSV HEADER;

-- 2) Which drivers delivered their first shipment in Cali?

SELECT * FROM
(SELECT DISTINCT ON (driver_id) drivers.driver, cities.city, status, timestamp 
FROM shipments
JOIN cities ON city_id = cities.id
JOIN drivers ON driver_id = drivers.id
WHERE status='delivered'
ORDER BY driver_id, timestamp ASC) AS firstship
WHERE firstship.city='Cali';

-- Exportando csv
COPY (
SELECT *
FROM
(SELECT DISTINCT ON (driver_id) drivers.driver, cities.city, status, timestamp 
FROM shipments
JOIN cities ON city_id = cities.id
JOIN drivers ON driver_id = drivers.id
WHERE status='delivered'
ORDER BY driver_id, timestamp ASC) AS firstship
WHERE firstship.city='Cali'
) TO '/Users/campopinillos/Downloads/pregunta2.csv' DELIMITER ',' CSV HEADER;

-- 3) Which drivers delivered their most recent shipment in Bucaramanga?

SELECT * FROM
(SELECT DISTINCT ON (driver_id) drivers.driver, cities.city, status, timestamp 
FROM shipments
JOIN cities ON city_id = cities.id
JOIN drivers ON driver_id = drivers.id
WHERE status='delivered'
ORDER BY driver_id, timestamp DESC) AS lastship
WHERE lastship.city='Bucaramanga';

-- Exportando csv
COPY (
SELECT *
FROM
(SELECT DISTINCT ON (driver_id) drivers.driver, cities.city, status, timestamp 
FROM shipments
JOIN cities ON city_id = cities.id
JOIN drivers ON driver_id = drivers.id
WHERE status='delivered'
ORDER BY driver_id, timestamp DESC) AS lastship
WHERE lastship.city='Bucaramanga'
) TO '/Users/campopinillos/Downloads/pregunta3.csv' DELIMITER ',' CSV HEADER;


-- 4) How many drivers delivered at least 100 shipments in Medellin?

SELECT drivers.driver, cities.city, status, COUNT(*) AS Deliveries 
FROM shipments
JOIN cities ON city_id = cities.id
JOIN drivers ON driver_id = drivers.id
GROUP BY drivers.driver, city_id, cities.city, status 
HAVING status='delivered' AND cities.city='Medellin' AND COUNT(*) >= 100
ORDER BY city_id;

-- Exportando csv
COPY (
SELECT drivers.driver, cities.city, status, COUNT(*) AS Deliveries 
FROM shipments
JOIN cities ON city_id = cities.id
JOIN drivers ON driver_id = drivers.id
GROUP BY drivers.driver, city_id, cities.city, status 
HAVING status='delivered' AND cities.city='Medellin' AND COUNT(*) >= 100
ORDER BY city_id
) TO '/Users/campopinillos/Downloads/pregunta4.csv' DELIMITER ',' CSV HEADER;


-- Nota: Ningun conductor entrego más de 100 envios a ninguna parte del país entre este rango de fechas


-- 5) Which drivers did not deliver any shipments on or after July 20, 2020?

SELECT *
FROM
(SELECT DISTINCT ON (driver_id) drivers.driver, status, timestamp
FROM shipments
JOIN drivers ON driver_id = drivers.id
GROUP BY driver_id, drivers.driver,  status, timestamp
HAVING status='delivered'
ORDER BY driver_id, timestamp DESC) AS lastship
WHERE lastship.timestamp <= timestamp '2020-07-20 00:00:00';

-- Exportando csv
COPY (
SELECT *
FROM
(SELECT DISTINCT ON (driver_id) drivers.driver, status, timestamp
FROM shipments
JOIN drivers ON driver_id = drivers.id
GROUP BY driver_id, drivers.driver,  status, timestamp
HAVING status='delivered'
ORDER BY driver_id, timestamp DESC) AS lastship
WHERE lastship.timestamp <= timestamp '2020-07-20 00:00:00'
) TO '/Users/campopinillos/Downloads/pregunta5.csv' DELIMITER ',' CSV HEADER;

-- 6) Please create a graph showing total shipments completed by day and by city.  Use any tool you like.

-- Generando datos para los graficos:

-- Exportando csv
COPY (SELECT cities.city, status, DATE(timestamp) AS DAY, COUNT(*) AS Deliveries 
FROM shipments
JOIN cities ON city_id = cities.id
GROUP BY cities.city, DAY, status
HAVING status='delivered'
ORDER BY DAY ASC) TO '/Users/campopinillos/Downloads/query_deliveries.csv' DELIMITER ',' CSV HEADER;

-- Exportando csv
COPY (SELECT cities.city, status, DATE(timestamp) AS DAY, COUNT(*) AS Deliveries 
FROM shipments
JOIN cities ON city_id = cities.id
GROUP BY cities.city, DAY, status
ORDER BY DAY ASC) TO '/Users/campopinillos/Downloads/query.csv' DELIMITER ',' CSV HEADER;

-- Se exportaron las bases de datos a para hacer gráficos en python

-- 7) Explain the difference between an inner join, a left join, and a right join.
-- Provide a hypothetical query and example.

-- Las Uniones sirven para combinar columnas de una o mas tablas 
-- basado en los valores comunes que estas tengan entre ellas.

-- INNER JOIN une las tablas de acuerdo al matching de los valores de estas
-- revisa fila por fila la tabla uno y la tabla dos y si sus valores son iguales crea
-- una fila por cada match con los valores de estas dos tablas, con nuestras 3 tablas
-- vamos a unir los valores comunes que tengan entre ellas.

SELECT DISTINCT cities.city, drivers.driver, COUNT(*) FROM shipments
INNER JOIN cities ON city_id = cities.id
INNER JOIN drivers ON driver_id = drivers.id
WHERE status='delivered'
GROUP BY city_id, driver_id, cities.city, drivers.driver;

-- LEFT JOIN Va unir las tablas de acuerdo al match que tengan,
-- Sin embargo, en este caso la primera tabla de la cual se realiza
-- el query va ser la tabla izquierda y si la segunda tabla no tiene valores
-- que hagan match con la primera va colocar los datos de esta y va poner null 
-- en los valores de la izquierda. Supongamos que en la tabla de shipments hay
-- nuevos valores para ciudades y conductores pero que no se han actualizado
-- en este caso para las cities nuevas y los drivers nuevos quedarian valores NULL


SELECT DISTINCT cities.city, drivers.driver, COUNT(*) FROM shipments
LEFT JOIN cities ON city_id = cities.id
LEFT JOIN drivers ON driver_id = drivers.id
WHERE status='delivered'
GROUP BY city_id, driver_id, cities.city, drivers.driver;

-- RIGHT JOIN En este caso va realizar el mismo procedimiento del LETF JOIN pero
-- esta vez prima la tabla DERECHA o segunda tabla, para los casos que no exista
-- un match con la primera se generan valores NULL en los campos de la izquierda.

SELECT DISTINCT cities.city, drivers.driver, COUNT(*) FROM shipments
RIGHT JOIN cities ON city_id = cities.id
RIGHT JOIN drivers ON driver_id = drivers.id
WHERE status='delivered'
GROUP BY city_id, driver_id, cities.city, drivers.driver;

-- 8) Explain the difference between a primary key and an index.  Provide a hypothetical query and example.

-- Una primary key puede ser vista como una constraint la cual basicamente garantiza
-- dos restrictciones sobre los valores que no sean NULL y que sean UNICOS, y solamente 
-- puede existir una primary key en cada tabla. Por otra parte, un index no necesariamente
-- cumple con ambos constrains de la primary key y sirve para ayudar a mejorar la busqueda
-- de información en las tablas a traves de un metodo de indexación.
-- En este caso fijamos PRIMARY KEYS para las tablas de drivers y cities.PRIMARY
-- Por otro lado, realizamos un index con el nombre del driver y comparamos los resultados
-- de busqueda

ALTER TABLE drivers 
ADD PRIMARY KEY (id);

-- Para veririficar primary key
-- \d drivers

ALTER TABLE cities 
ADD PRIMARY KEY (id);

-- Para veririficar primary key
-- \d cities
EXPLAIN SELECT * FROM shipments
WHERE driver_id = 19;

-- Ahora se crea el index
CREATE INDEX driver_id_index
ON shipments(driver_id);

-- La busqueda de datos cambia
EXPLAIN SELECT * FROM shipments
WHERE driver_id = 19;

-- 9) What is a foreign key?  
-- Una foreign key es una columna o grupo de columnas que hacen referencia
-- a las primary keys de otras tablas en este caso para shipments las columnas
-- driver_id y city_id podrían ser foreign keys de las tablas de drivers y cities,
-- la tabla con las foreign keys sería una child table o tabla de referencia y las 
-- otras tablas son las parent table o tablas referenciadas.

-- What are the advantages or disadvantages of using one?


ALTER TABLE shipments
ADD CONSTRAINT driver_id_key 
FOREIGN KEY (driver_id)
REFERENCES drivers (id);

ALTER TABLE shipments
ADD CONSTRAINT city_id_key 
FOREIGN KEY (city_id)
REFERENCES cities (id);

-- para confirmar foreing keys
-- \d shipments