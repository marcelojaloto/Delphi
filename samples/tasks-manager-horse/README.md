## Tasks Manager

The task manager aims to create a REST server using the Horse framework to provide an HTTP server and in the client part to consume the server's API, the RESTRequest4D framework was used.


[![PayPal donate button](https://user-images.githubusercontent.com/26885358/62580349-60bd8780-b87c-11e9-901e-425cf2a83671.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=AW8TZ2QTDA7K8)

## Business rules

* REST API Server: Development of a service to manage information about tasks. The service must offer the following functionalities:

a) Consult and return the list of all tasks.
b) Add a new task.
c) Update the status of a task.
d) Remove a task.
e) PostgreSQL Database for storing task data and for SQL queries in the service to calculate and return:
- The total number of tasks.
- The average priority of pending tasks.
- The number of tasks completed in the last 7 days.

f) Details:
- Use of the Horse framework;
- Swagger documentation;
- Use of Factory Methos or Abtract Factory Design Patterns;
- Security in communication between the service and the application was used JWT.

* Client: Development of VCL Client application in Delphi to consume services created in REST API Server.

The application performs the following operations:
a) Display the list of all tasks obtained from the service.
b) Add a new task through the graphical interface.
c) Update the status of a task.
d) Remove a task.
e) Implement visualization of statistics of SQL queries performed on the server.
f) Details:
- The client application interacts exclusively with the service to perform the mentioned operations, without local data persistence.
- Used the RESTRequest4Deplhi library to make calls to the service.
- Friendly and intuitive graphical interface.

## Install

a) Creation of the PostgreSQL database:

- Download PostgreSQL from the address below for version 16.2 Windows 64 bits:
https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

Or directly at the address below:
https://sbp.enterprisedb.com/getfile.jsp?fileid=1258893

- Configure PostgreSQL:
- Port = 5432
- Username = postgres
- Password = postgres

- Create a database with the name "tasks"

- Then run the script below in the "tasks" database:

CREATE TABLE public.tasks
(
id uuid NOT NULL,
title character varying(100) NOT NULL,
notes character varying(1000),
created_date timestamp without time zone NOT NULL,
status integer NOT NULL,
priority integer NOT NULL,
end_date timestamp without time zone,
CONSTRAINT tasks_pkey PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.tasks
OWNER to postgres;
	
	
b) Server REST API

- Compile the sources in Delphi (suggested 10.3) from the project "tasks_server.dpr"
- In the "deploy\Win64" folder the executable "tasks_server.exe" will be generated
- Make sure you have the "lib" folder with several DLLs for connecting to the PostgresSQL database;

![image](https://github.com/marcelojaloto/Delphi/assets/20048296/adb03111-3f22-467f-b45d-e62998a1612b)


- Run the server and allow access to the Windows firewall;
- If the database was configured correctly as instructed above, the server will be running locally at the address below:
http://127.0.0.1:9000

![image](https://github.com/marcelojaloto/Delphi/assets/20048296/d517a642-5862-403f-a743-c5e380d34384)


c) API documentation in Swagger

![image](https://github.com/marcelojaloto/Delphi/assets/20048296/1ff526b8-5900-448e-b217-baf04b90aae4)


- With an operational server, access the address below:
http://127.0.0.1:9000/api/help
- Authenticate using the admin username and admin password;
- Copy the token code;
- Click on the Authorize button and in the value field write bearer and paste the token as in the example below:
bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJUYXNrcyBBUEkiLCJzdWIiOiJhZG1pbiIsImV4cCI6MTcxNjkyMzMyNn0.8Cr5XjBkrIy1bbfKy0d7zZDciw9fiLQjy Fd-g5nPIH4
- Once authenticated, you can use the API services directly through the interactive documentation.

d) Client Tasks Manager:

- Compile the sources in Delphi (suggested 10.3) from the project "tasks_client.dpr";
- With the server operational, run the "tasks_client.exe" application.

![image](https://github.com/marcelojaloto/Delphi/assets/20048296/b9c803a7-b61a-4c45-9344-541284a5a83a)



