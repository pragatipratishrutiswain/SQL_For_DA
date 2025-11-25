SHOW DATABASES #Shows all the databases
SHOW TABLES #Shows all the tables
SHOW COLUMNS from customers #same as DESCRIBE

SELECT * FROM customers #shows selected table of the default database
SELECT * FROM ppsdb.customers #shows selected table of the prefered database and not the default database
SELECT * FROM cn_3.customers

USE cn_3 #sets my default database 

select @@sql_mode;
SET sql_mode = '';