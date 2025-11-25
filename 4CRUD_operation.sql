#CRUD operations - create, read, update, delete
SELECT * FROM customers
LIMIT 5;

#Create
CREATE TABLE employees (
empl_id INT, 
salary DECIMAL(10,2),
firstname varchar(50),
lastname varchar(50),
email varchar(150),
gender CHAR(1),
birthdate DATE
);
select * from employees;

#Top 5 customers - table that contains those 5 customers only who have the highest customerkey
#Show only customerkey, emailaddress
CREATE TABLE top_5_customers AS
select customerkey, emailaddress from customers
order by CustomerKey desc
limit 5;
select * from top_5_customers;

#CREATE another employee table which has some contrains to the first employee table
CREATE TABLE employees2 (
empl_id INT, 
salary DECIMAL(10,2),
firstname varchar(50) NOT NULL,
lastname varchar(50) NOT NULL,
email varchar(150) UNIQUE NOT NULL,
gender CHAR(1),
birthdate DATE
);

#Create a table called pharma and include 8 relevant columns 
#for storing data of a pharma retail store
create table pharma (
store_name varchar(20),
store_id varchar(6),
sellsman_id int,
customer_id varchar(15) unique not null,
drug_name varchar(50),
drug_id varchar(10),
price decimal(10,2),
purchasedate datetime
);
select * from pharma;

#Create a table called high_valued_products
#which stores productkey of those products which are having manufacturing
#cost greater than 1000
create table high_valued_products AS
select productkey from products
where productcost > 1000;
select * from high_valued_products;

#Read
select * from customers;

#Update
-- UPDATE table_name
-- SET column1 = value1, column2 = value2
-- where condition

#Update the customers table where replace value of customerkey 11001 from
#'eugene10@learnsector.com' to 'huang10@learnsector.com'

UPDATE customers
SET emailaddress = 'huang10@learnsector.com'
where customerkey = 11001;
select * from customers;

#For all lastname as HUANG,
#update their emailid to huang10@learnsector.com
#and change their homeowner status to "Y"

UPDATE customers
SET HomeOwner = 'Y', emailaddress = 'huang10@learnsector.com'
WHERE lastname ='HUANG';
SELECT * FROM customers
WHERE lastname ='HUANG';

#DELETE
select count(*) from customers;
-- delete from tablename
-- where condition

delete from customers
where customerkey = 12020;

select * from customers
where customerkey = 12020;

#delete from customers ---> deletes the rows of the entire table if where condition is not mentioned

select 2+3   ---> returns 5
select 3+9 as sum  ---> returns 12 with column name as sum
delete from customers
where 2>1 -------> returns TRUE always means it will delete the customers table

Empty values versus Null values

select distinct prefix from customers

select * from customers
where prefix is null  -----> no rows, means no missing values

select * from customers
where prefix =''  --------> returns output, means empty value or empty string

update customers
SET prefix = null  #------> here is null can not be written as we are not checking a null condition
where prefix = ''

select distinct prefix from customers

select * from customers 
where prefix is null   --------> is null because of a condition

#return emailaddress of those customers which have non null prefix
select emailaddress, prefix from customers 
where prefix is not null

Delete vs Drop vs Truncate

DELETE
select * from top_5_customers

delete from top_5_customers #deletes the rows but schema and table is present

delete can be rolledback or undone

TRUNCATE

truncate table top_5_customers #removes all rows but not the table and schema

truncate can not be rolledback or undone

DROP

drop table top_5_customers  #removes all rows anlong with table and schema

drop can not be rolledback

#qn which is most efficient (fast) between delete vs truncate vs drop?
EFFICIENCY
DROP> TRUNCATE > DELETE  (in cae of large tables only)
---> because drop deletes the entire table without roll back, truncate will keep the table and the schema without roll back
and delete will internally work with a hidden where conditions to do row wise operation with an option to roll back.
So for large tables the more no of rows the longer will it take to delete the table

DELETE --- slow process
logs or stores the deleted rows into memory to save it for rollback

TRUNCATE ---- faster than delete
due to deallocation of data pages (group of rows or cluster of rows)
remove memory occupied by cluster of rows without loging rows

DROP ---- fastest of all
deletes the entire table at one shot and releases a lot of memory
