-- DATA SIMULATED FROM www.mockaroo.com
DROP TABLE IF EXISTS person;

DROP TABLE IF EXISTS car;


create table car (
	id BIGSERIAL PRIMARY KEY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price NUMERIC(19, 2) NOT NULL
);

create table person (
	id BIGSERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50)NOT NULL,
	email VARCHAR(150),
	gender VARCHAR(7) NOT NULL,
	date_of_birth DATE NOT NULL,
	country_of_birth VARCHAR(50),
	car_id BIGINT REFERENCES car (id),
	UNIQUE(car_id),
	UNIQUE(email)
);

insert into car (id, make, model, price) values (1, 'GMC', 'Savana 1500', '11084.76');
insert into car (id, make, model, price) values (2, 'Toyota', 'Avalon', '56370.41');


insert into person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (1, 'Tammi', 'Codlin', 'tcodlin0@wikia.com', 'Female', '1980-02-17 22:53:55', 'Thailand');
insert into person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (2, 'June', 'Jowitt', null, 'Female', '1998-07-09 14:57:02', 'United States');
insert into person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (3, 'Megan', 'Northcliffe', 'mnorthcliffe2@narod.ru', 'Female', '1991-08-05 16:23:18', 'Indonesia');
insert into person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (4, 'Jania', 'Barenskie', 'jbarenskie3@mozilla.org', 'Female', '1986-07-01 00:18:24', 'Ukraine');