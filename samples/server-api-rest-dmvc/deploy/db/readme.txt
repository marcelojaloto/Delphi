- installs postgres 12;
- configure the user = postgres, passowrd = postgres, and database port = 5432;
- initializes pgAdmin;
- informs the "postgres" password;
- creates a new database called db_sample;
- in the Tools > Query Tools menu, execute sql to create the table:

create table customers(
	id serial primary key,
	name varchar(100) not null,
	email varchar(100)	
);

insert into customers (name, email) values ('Marcelo Jaloto', 'marcelojaloto@gmail.com');
insert into customers (name, email) values ('Uriel Castro', 'urielcastro@gmail.com');
insert into customers (name, email) values ('Joice da Silva', 'joicesilva@gmail.com');
insert into customers (name, email) values ('Nathan Machado', 'nathanmachado@gmail.com');
insert into customers (name, email) values ('Cristina Santos', 'cristinasantos@gmail.com');