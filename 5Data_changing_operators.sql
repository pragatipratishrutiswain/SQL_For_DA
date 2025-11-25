#INSERT  --- commnad used to insert rows

select * from employees
insert into tablename
values (value1,valu2,value3,.......)

#12021 - max customerkey
insert into customers
values (13097, 'MR.', 'LEWIS', 'YOUNG', '17-07-1985','','M','M','lewis10@learnsector.com','$50,000',4,'Bachelors',
'Professional','N',2575393190)

select * from customers
where customerkey = 13097

#CUSTOM ADD VALUES TO SOME COLUMNS
insert INTO customers 
(customerkey, prefix, firstname, lastname, birthdate)
values(13100,'MRS.','MARRY','HUANG','15-10-1976')
select * from customers
where customerkey = 13100

insert INTO customers 
(customerkey, prefix, firstname, lastname, birthdate)
values(13101,'MRS.','HENRY','HUANG','15-01-1946'),
	  (13102,'MR.', 'SOPH','HUANG','02-02-1990')
select * from customers
where customerkey IN (13101,13102)

insert INTO customers 
(customerkey, prefix, firstname, lastname, birthdate)
values(13101,NULL,'MARRY','HUANG',NULL)
select * from customers
where customerkey = 13101

#INSERT 2 rows under customer table for customerkey - 13109, 13110, give firstname, lastname, gender, annulaincome, 
#phonenumber only

insert INTO customers 
(customerkey, firstname, lastname, gender, annualincome, phone_number)
values(13109,'MARIY','HUING','M','$60,105',89745656565), (13110,'ABBAS','ALI','M','81,542',8965324575)
select * from customers
where customerkey IN (13109,13110)

--------------------------------------------------------------

ALTER

#Add coulumn named Country
ALTER TABLE customers
ADD Country VARCHAR(50)
select * from customers

#ADD and DROP Multiple columns in a single ALTER query
ALTER TABLE customers
ADD Location VARCHAR(50),
ADD Pin INT,

ALTER TABLE customers
DROP Location,
DROP Pin

select * from customers



DESCRIBE   ---- DESC command describes the schema of the table
DESC customers

#for customerkey 13102, I wanna enter country as India in customers table
update customers
set country = 'India'
where customerkey = 13102
select * from customers
where customerkey = 13102

#add region col after emailaddress col
alter table customers
add Region varchar(50) after emailaddress
select * from customers

#change datatype of a column
alter table customers
MODIFY column maritalstatus char(1)

SELECT * FROM customers

#Shift column position, bring totalchildren coulmn after gender column
ALTER TABLE customers
MODIFY TotalChildren int after Gender


desc customers

ENUM datatype ---- also known as an enumerated type, is a data type that consists of a set of named values.

alter table customers
modify column Region ENUM ('NORTH', 'SOUTH', 'EAST', 'WEST') #You can't input any other value in Region column other than these defined ones
desc customers

alter table customers
rename column region to area
select * from customers

alter table customers
drop column area  # delete the area colm

alter table customers
drop column myunknowncolumn 
#delete or truncate are row wise operations won't work here

Lets say you are building your own startup AI-BASE.
You have to set up your own database.

Enter data for existing 1000 customers manually in an employee table
which maintains demographic details of only active employees.
2 persons left the company, handle their data.
3 new people have onboarded, handle their data.
Employee4 has migrated to a new city while he is still working with us - handle data.
Perform data analysis to check the unique employee ids
There was some issue with the employees table due to which data analysis was wrong.
We dont need this employees table until the backend operational fixes are made.. (independent of database)
Once fixes are done, we can utilize this data.. Fixing might take an year.. Better to save storage for an year... 
Think about how to save storage!!
Once these issues are fixed, we have started capturing details regarding their
marital status too which was not considered before, handle this in the customers table.
The CTO of your company wants to check sales made by employee5 in previous year..
In the city column, now onwards, BOMBAY has to be changed everywhere to Mumbai.
Also, create another table "employees_super" which contains information of employees-3,7,10,15,18 who are our super active employees.
Findout the various countries for these 5 employees.
Also, once done, we dont need data of the "employees_super" table anymore, but the structure of table
could be useful in adding information for other super active employees in the future. So handle accordingly!

create table employees3 (
empl_id INT, 
location varchar(50),
empl_name varchar(50),
email varchar(150),
gender CHAR(1),
activity_status enum('Y','N')
)
insert data of 1000 employees
delete data of 2 empl where empl_id in()
insert data of 3 empl
update employee4 city
select distinct empl_id
delete employee3 table
alter add maritalstatus column
insert values to maritalstaus
select sales where empl5 and year is previous
update set city = bombay to city= mumbai

create table empl_super as
select data from employee3 table 
where empl-id in (3,7,...18)
select distinct country from empl_super

delete table empl_super #not truncate because table has only 5 rows so both are equally faster and delete has an advantage of rollback
---------------------------------------

SHOW DATABASES #Shows all the databases
SHOW TABLES #Shows all the tables of the default database
SHOW COLUMNS from customers #same as DESCRIBE

SELECT * FROM customers #shows selected table of the default database
SELECT * FROM ppsdb.customers #shows selected table of the prefered database and not the default database
SELECT * FROM cn_3.customers

USE cn_3 #sets my default database 

HOW to RENAME TABLE
RENAME TABLE pharma TO pharmaa
or
ALTER TABLE pharmaa RENAME pharma

