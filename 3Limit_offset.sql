USE cn_3;

#LIMIT
SELECT * FROM customers
LIMIT 3;	#Displays the top 3 rows only

#Findout those 2 customers having the highest customerkey
SELECT * FROM customers
ORDER BY CustomerKey DESC
LIMIT 2; #Limit is alz written at the end

#Findout the top 3 costiest products  --- means highest selling price and not cost price
SELECT * FROM products;
SELECT ProductName FROM products
ORDER BY ProductPrice DESC
LIMIT 3;

#Findout the top 4 costiest model names along with their product price
SELECT DISTINCT ModelName, ProductPrice FROM products
ORDER BY productprice DESC
LIMIT 4;

SELECT DISTINCT ModelName FROM products
ORDER BY productprice DESC
LIMIT 4;  #Throwing error  --> ORDER BY clause is not in SELECT list, this is incompatible with DISTINCT

/* OFFSET - skipping the rows
Findout the 2nd, 3rd, 4th highest priced products */
SELECT * FROM products
order by ProductPrice desc 
limit 3 
offset 1; #skip 1st row

# OR Shortcut - in-line operation for limit & offset
SELECT * FROM products
order by ProductPrice desc 
limit 1, 3; 
# For in-line operation order of parameters beween offset & limit is swapped
# Offset parameter is passed first then followed by limit parameter
# (limit 3, 1) will result in limit 1, offset 3

-- How to show all the rows after the first 20 rows in MySQL?
SELECT ProductKey, ProductName 
FROM products
LIMIT 18446744073709551615 OFFSET 20; # 18446744073709551615 = maximum BIGINT value (MySQL’s trick to mean "no real limit").

#ALIAS or rename column name
select distinct modelname AS model, ProductPrice as pp from products;

/* Findout the 4th and 5th highest email_id (rename col in the output) based on highest 
value of maritalstatus, tie breaker - use lower total children and then if needed use higher customerkey 
who have letter "e" in their email id and are either having bachelors education or are not home owners
return only email id, total children, maritalstatus,customerkey, educationalevel, homeowner columns */
SELECT EmailAddress as email_id, totalchildren, customerkey, maritalstatus, educationlevel, homeowner 
FROM customers
where EmailAddress like '%e%' AND (educationlevel = 'Bachelors' OR NOT HomeOwner = 'Y')
order by  maritalstatus desc, totalchildren, customerkey desc 
limit 2 
offset 3;

#Findout those email ids which don't have domain "@learnsector.com"
SELECT EmailAddress FROM customers
where emailaddress not like '%@learnsector.com';

#Count no of rows fro the products table
select count(*) from products