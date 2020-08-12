-- Practice Queries
\copy (SELECT * FROM person LEFT JOIN car on car.id = person.car_id) TO '/Users/campopinillos/Documents/GitHub/SQL/Postgres/export.csv' DELIMITER ',' CSV HEADER;
\d
\d person
\d car


-- To move sequence
SELECT * FROM nextval('person_id_seq'::regclass);
SELECT * FROM nextval('person_id_seq'::regclass);
SELECT * FROM nextval('person_id_seq'::regclass);
SELECT * FROM nextval('person_id_seq'::regclass);
SELECT * FROM nextval('person_id_seq'::regclass);
SELECT * FROM nextval('person_id_seq'::regclass);
SELECT * FROM nextval('person_id_seq'::regclass);
SELECT * FROM nextval('person_id_seq'::regclass);



insert into person (first_name, last_name, email, gender, date_of_birth, country_of_birth) 
values ('John', 'Cod', 'jod0@wikia.com', 'Male', '1980-02-17 22:53:55', 'USA');

SELECT * FROM person_id_seq;
SELECT * FROM person;

-- To restart sequence to last value
ALTER SEQUENCE person_id_seq RESTART WITH 1;

insert into person (first_name, last_name, email, gender, date_of_birth, country_of_birth) 
values ('John', 'Cod', 'jod@wikia.com', 'Male', '1980-02-17 22:53:55', 'USA')
ON CONFlICT (id) DO NOTHING;

-- To restart sequence to last value

ALTER SEQUENCE person_id_seq RESTART WITH 4;
SELECT * FROM person_id_seq;

insert into person (first_name, last_name, email, gender, date_of_birth, country_of_birth) 
values ('John', 'Cod', 'jod@wikia.com', 'Male', '1980-02-17 22:53:55', 'USA');

-- To see available extensions
SELECT * FROM pg_available_extensions;

-- Use UUID

-- Install extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- To Check already installed extensions
\dx

-- To Check functions
\df

SELECT uuid_generate_v4();

-- Using UUID as PRIMARY KEY

DROP TABLE IF EXISTS person;

DROP TABLE IF EXISTS car;


create table car (
	car_uid UUID PRIMARY KEY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price NUMERIC(19, 2) NOT NULL
);

create table person (
	person_uid UUID PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50)NOT NULL,
	email VARCHAR(150),
	gender VARCHAR(7) NOT NULL,
	date_of_birth DATE NOT NULL,
	country_of_birth VARCHAR(50),
	car_uid UUID REFERENCES car (car_uid),
	UNIQUE(car_uid),
	UNIQUE(email)
);

insert into car (car_uid, make, model, price) values (uuid_generate_v4(), 'GMC', 'Savana 1500', '11084.76');
insert into car (car_uid, make, model, price) values (uuid_generate_v4(), 'Toyota', 'Avalon', '56370.41');


insert into person (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Tammi', 'Codlin', 'tcodlin0@wikia.com', 'Female', '1980-02-17 22:53:55', 'Thailand');
insert into person (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'June', 'Jowitt', null, 'Female', '1998-07-09 14:57:02', 'United States');
insert into person (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Megan', 'Northcliffe', 'mnorthcliffe2@narod.ru', 'Female', '1991-08-05 16:23:18', 'Indonesia');
insert into person (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Jania', 'Barenskie', 'jbarenskie3@mozilla.org', 'Female', '1986-07-01 00:18:24', 'Ukraine');


UPDATE person SET car_uid = '8bd20f00-d525-4e4f-96c4-a0316af0f51c' WHERE person_uid = '16652b00-ec97-4009-8fc5-f720e5d341a9';
UPDATE person SET car_uid = '22c100a7-0d5e-4650-9b33-cabca60d98b5' WHERE person_uid = '1d3defa4-cfab-471c-ab42-5e827982030d';

SELECT * FROM person;
SELECT * FROM car;

SELECT * FROM person JOIN car ON person.car_uid = car.car_uid;
SELECT * FROM person JOIN car USING (car_uid);