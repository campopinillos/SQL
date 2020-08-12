-- Practice Queries
-- First Queries from person table

SELECT * FROM person LIMIT 10;

SELECT * FROM person ORDER BY email NULLS LAST LIMIT 5;

SELECT * FROM person WHERE gender='Male' LIMIT 5;

SELECT * FROM person WHERE date_of_birth BETWEEN '2000-01-01' AND '2000-01-30' LIMIT 5;

SELECT * FROM person OFFSET 5 LIMIT 5;

SELECT * FROM person OFFSET 10 FETCH FIRST 5 ROW ONLY;

SELECT * FROM person WHERE country_of_birth IN ('Colombia','Brazil') LIMIT 15;

-- Wildcars
SELECT * FROM person WHERE email LIKE '%bloomberg.com' LIMIT 10;
SELECT * FROM person WHERE email LIKE '%.com' LIMIT 10;
SELECT * FROM person WHERE email LIKE '%@google.%' LIMIT 10;
SELECT * FROM person WHERE email LIKE '_______8@%' LIMIT 10;
SELECT * FROM person WHERE country_of_birth LIKE 'P%' LIMIT 10;
SELECT * FROM person WHERE country_of_birth ILIKE 'p%' LIMIT 10;

-- Group by
SELECT DISTINCT country_of_birth, COUNT(*) AS People 
FROM person 
GROUP BY country_of_birth 
ORDER by country_of_birth LIMIT 15;

-- Filtering
SELECT DISTINCT country_of_birth, COUNT(*) AS People 
FROM person 
GROUP BY country_of_birth
HAVING COUNT(*) >= 41
ORDER by country_of_birth LIMIT 15;

-- Arithmetic operators Factorial and Modulus

SELECT 5!;

SELECT 10 % 3;

SELECT 13 % 5;


-- Queries from car table
SELECT DISTINCT make, model, MAX(price) AS Most_expensive 
FROM car 
GROUP BY make, model
ORDER by Most_expensive DESC LIMIT 15;

SELECT DISTINCT make, model, MIN(price) AS Cheapest
FROM car 
GROUP BY make, model
ORDER by Cheapest LIMIT 15;

SELECT DISTINCT make, model, ROUND(AVG(price), 4) AS Average 
FROM car 
GROUP BY make, model
ORDER by Average DESC LIMIT 15;

SELECT DISTINCT make, SUM(price) AS Summary 
FROM car 
GROUP BY make
ORDER by Summary DESC LIMIT 15;

-- Round and alias
SELECT id, make, price AS original_price,
ROUND(price * 0.10, 2) AS ten_percent,
price - ROUND(price * 0.10, 2) AS discount_after_ten_percent 
FROM car 
ORDER by price DESC LIMIT 15;

--Coalesce - function that returns the first non-null argument
SELECT COALESCE(email, 'Email not provided') FROM person;

--Same than WHEN CASE
SELECT CASE WHEN email IS NULL THEN 'Email not provided' ELSE email END
FROM person;


--NULLIF
SELECT NULLIF(1, 1);

SELECT NULLIF(2, 1);

-- Division by Zero
SELECT 10 / NULLIF(0, 0);

SELECT COALESCE(10 / NULLIF(0, 0), 0);

-- Dates
SELECT NOW();

SELECT NOW()::DATE;

SELECT NOW()::TIME;

SELECT NOW() + INTERVAL '10 DAYS';
SELECT NOW() + INTERVAL '10 YEARS';
SELECT NOW() + INTERVAL '10 MONTHS';
SELECT NOW() + INTERVAL '10 HOURS';
SELECT NOW() + INTERVAL '40 MINUTES';

SELECT (NOW() + INTERVAL '10 YEARS')::DATE;
SELECT (NOW() + INTERVAL '40 MINUTES')::TIME;

SELECT EXTRACT(YEAR FROM NOW());
SELECT EXTRACT(MONTH FROM NOW());
SELECT EXTRACT(DAY FROM NOW());
SELECT EXTRACT(DOW FROM NOW());
SELECT EXTRACT(CENTURY FROM NOW());
SELECT EXTRACT(DECADE FROM NOW());
SELECT EXTRACT(MILLENNIUM FROM NOW());

-- Calculating Age
SELECT *, AGE(NOW(), date_of_birth) AS age FROM person;
SELECT *, EXTRACT(YEARS FROM AGE(NOW(), date_of_birth)) AS year_old, AGE(NOW(), date_of_birth) AS age FROM person;

--To get rid of primary key constrain
ALTER TABLE person DROP CONSTRAINT person_pkey;

--To add primary key againg
ALTER TABLE person ADD PRIMARY KEY (id);

-- ADD UNIQUE CONSTRAINT
ALTER TABLE person ADD CONSTRAINT unique_email_address UNIQUE(email);

-- ADD CHECK CONSTRAINT
ALTER TABLE person ADD CONSTRAINT gender_constrain CHECK (gender='Male' OR gender='Female');


-- Updating Records
UPDATE person SET email='june@gamil.com' WHERE id=2;
UPDATE person SET first_name='Juan', last_name='Rodirguez', email='juan@gamil.com' WHERE id=2;

-- Creating a new record
INSERT INTO person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) 
VALUES (1001, 'Tammilyn', 'Codlinz', 'tcodlinz0@wikia.com', 'Female', '1980-02-17 22:53:55', 'Thailand');

-- Avoiding error messages from insert when key already exists
INSERT INTO person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) 
VALUES (1, 'Tammilyn', 'Codlinz', 'tcodlinz0@wikia.com', 'Female', '1980-02-17 22:53:55', 'Thailand')
ON CONFLICT (id) DO NOTHING;
-- Same
INSERT INTO person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) 
VALUES (1, 'Tammilyn', 'Codlinz', 'tcodlinz0@wikia.com', 'Female', '1980-02-17 22:53:55', 'Thailand')
ON CONFLICT ON CONSTRAINT person_pkey DO NOTHING;


INSERT INTO person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) 
VALUES (1002, 'Tammilyn', 'Codlinz', 'tcodlinz0@wikia.com', 'Female', '1980-02-17 22:53:55', 'Thailand')
ON CONFLICT (email) DO NOTHING;
-- Same
INSERT INTO person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) 
VALUES (1, 'Tammilyn', 'Codlinz', 'tcodlinz0@wikia.com', 'Female', '1980-02-17 22:53:55', 'Thailand')
ON CONFLICT ON CONSTRAINT unique_email_address DO NOTHING;


-- Updating a register
INSERT INTO person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) 
VALUES (1, 'Tammilyn', 'Codlinz', 'tcodlin01@wikia.com', 'Female', '1980-02-17 22:53:55', 'Thailand')
ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email, first_name = EXCLUDED.first_name;

-- Concat
INSERT INTO person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) 
VALUES (1, 'Tammilyn', 'Codlinz', 'tcodlin@wikia.co', 'Female', '1980-02-17 22:53:55', 'Thailand')
ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email || ';' || person.email;




-- RUN person-car.sql to get new data

UPDATE person SET car_id = 2 WHERE id = 1;

UPDATE person SET car_id = 1 WHERE id = 2;

UPDATE person SET car_id = 3 WHERE id = 3;


-- JOINS

SELECT * FROM person JOIN car ON person.car_id = car.id;

SELECT * FROM person LEFT JOIN car ON person.car_id = car.id;

SELECT * FROM person LEFT JOIN car ON person.car_id = car.id
WHERE car.* IS NULL;