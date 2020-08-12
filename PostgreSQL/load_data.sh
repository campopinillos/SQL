#To load data
psql -h localhost -p 5432 -U campopinillos -d test -f /Users/campopinillos/Documents/GitHub/SQL/Postgres/person.sql
psql -h localhost -p 5432 -U campopinillos -d test -c '\i /Users/campopinillos/Documents/GitHub/SQL/Postgres/car.sql'
