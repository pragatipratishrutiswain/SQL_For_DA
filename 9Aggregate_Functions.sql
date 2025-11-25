#AGGREAAGATE FUNCTIONS
SUM
COUNT
MIN
MAX
AVG

VARIANCE
STDDEV

SELECT COUNT(*), count(customerkey), count(phone_number), count(DISTINCT gender), count(country)
FROM CUSTOMERS

SELECT count(10) FROM CUSTOMERS  #----> ASSIGNS 10 TO EVERY ROW
R1 10
R2 10
.
.
.
R2069 10

* ------> all rows
column name ----> only non null values

select COUNTRY from customers
where country is NOT null

select * from products

1. FINDOUT THE TOTAL NO OF ROWS IN PRODUCTS TABLE ---293
select count(*) from products

2. HOWMANY NULL VALUES ARE THERE IN MODELNAME --- ZERO
select count(*) from products
where modelname is null
#EXPLANATION - count(modelname) where modelname is null will discard the rows which are null by default

3. THE HIGHEST COSTPRICE IN PRODUCTS TABLE ---2171.2942
select max(productcost) from products

4. THE LEAST RATIO OF PRICE/COST ---1.2987012987012987
select min(productprice/productcost) from products

5. HOW MANY DISTINCT PRODUCTKEYS HAVE COST < 1000 AND PRICE > 1000 --- 45
select count(distinct productkey) from products
where productcost < 1000 AND productprice > 1000

6. WHAT IS TOTAL MANUFACTURING COST? ----121202.67569999998
select sum(productcost) from products

7. RATIO OF OVERALL TOTAL PRICE BY OVERALL TOTAL COST ------1.7271082861085703
select sum(productprice)/sum(productcost) from products

8. GROSS PROFIT (PRICE-COST) FOR OVERALL DATA BY SUMMING UP EACH ROWS PROFIT -----88127.46980000006
select sum(productprice-productcost) from products
9. SHOW THE 5 SUMMARY STATISTICS (USE 5 AGGREGATE FUNCs) FOR THE PRICE COLUMN USING A SINGLE QUERY
select count(productprice),sum(productprice),avg(productprice),max(productprice),min(productprice) from products

10. RETURN VARIANCE AND STANDARD DEVIATION FOR INCOME COLUMN FROM CUSTOMERS TABLE
select * from customers
select variance(annualincome), stddev(annualincome) from customers
------------------------------------------------------------------------

GROUP BY

select * from customers

select distinct maritalstatus from customers

1. For each maritalstatus calculate average

select maritalstatus, avg(annualincome) from customers
group by maritalstatus 

2. For each combination of marital status and gender in customers table, find total income

select distinct maritalstatus, gender, sum(annualincome) from customers
group by maritalstatus, gender

#check for each occupation, howmany customers are present

select occupation, count(distinct customerkey), sum(annualincome) from customers
group by occupation

#HAVING  --- only used in aggregate function i.e. after group by

1.Figure out those occupations which have average income below 50,000

select occupation, sum(annualincome) 
from customers
WHERE avg(annualincome) < 50000 #---------> error, Where will run first compare to aggregation/grouping
group by occupation

WHERE + AGGREGATED FUNCTION CAN NEVER BE USED

select occupation, avg(annualincome) as mean_income, sum(annualincome) as tot_income
from customers
group by occupation
HAVING mean_income < 50000 and tot_income >4500000

2. Figure out those occupations for females only which have average income below 50,

select occupation, avg(annualincome) as mean_income
from customers
where gender = "F"
group by occupation
HAVING mean_income < 50000

ORDER OF COMPILER 
-------------
FROM >
WHERE >
GROUP BY >
HAVING >
SELECT simultaneously in MySQL

SELECT * FROM TABLE
WHERE CONDITION
GROUP BY COL1, COL2
HAVING COL1> CONDITION
ORDER BY COL1 DESC
LIMIT 3

select productcolor from products
group by 1
having sum(productprice) > 50000  ----> having is running earlier than select which is why the query is not showing error

Homework
------------
read about abs(), round(), group_concat() from the internet


1. 
#Findout the minimum and maximum product cost and price both for 
#product color, size and style combination. Don't consider silver color for this.
#exclude null values from your calculation in cost and price both
#return only the top 3 combinations in descending order of each combinations average cost/price ration

select* from products
select productcolor, productsize, productstyle, avg(productcost/productprice),
min(productcost), max(productcost), min(productprice), max(productprice)
from products
where productcolor != "Silver" and productcost is not null and productprice is not null
group by 1,2,3
order by 4 desc
limit 3

#2
-- Query to find the count of the total products, the total cost of the products, 
-- the total price of the products, and the reduced decimal-oriented total sum of the difference 
-- between product price and product cost which need to be categorized on product key and subcategory key. 
-- Also, sort the difference between product price and product cost in descending order. 
select * from products
select productkey, productSubcategoryKey, count(distinct productkey) as total_products, 
sum(productcost) as total_cost, sum(productprice) as total_price,
round(sum(productprice - productcost)) as difference
from products
group by productkey, productSubcategoryKey
order by difference desc

#3
--  Query to find the absolute sum of the difference between the product price and the product cost which 
--  is categorized on productsubcategorykey. Also, find the total on those whose difference between product price
--  and cost is more than 5000 in absolute terms and sort by descending order.
select productsubcategorykey, abs(sum(productprice-productcost)) as difference
from products 
group by productsubcategorykey
having difference > 5000

#4
# Query to find the reduced decimal oriented average of the product cost and price. 
# Also, find the average price difference which is more than 20 and sort by descending order.
select productsubcategorykey, round(avg(productcost)) as avg_cost, round(avg(productprice)) as avg_price,
round(avg(productprice-productcost)) as avg_diff
from products
group by productsubcategorykey
having avg_diff > 20
order by avg_diff desc

#5
# Query to find the minimum and maximum income of the customers where
# difference of the minimum and maximum income on the educational level categorization is > 50000.
select * from customers
select educationlevel, max(annualincome), min(annualincome), count(*),
(max(annualincome) - min(annualincome)) as difference
from customers
group by educationlevel
having difference > 50000

#6
# Query to find the total income of the customers on gender criteria whose income is more than 1000000.
select sum(annualincome) as totalincome, gender from customers
group by gender
having totalincome > 1000000

#7
# query to find the reduced decimal-oriented average of the product cost on categorization of the unique subcategories. 
select productsubcategorykey, round(avg(productcost),2) as avg_cost from products
group by productsubcategorykey

#8
# Query to find the count as well as the percentage of people and categorize with the help of gender criteria. 
select count(*) from customers

select gender, count(distinct customerkey) as countgender,
(count(distinct customerkey)/(select count(*) from customers) * 100) as percentage
from customers
group by gender

#9
# Query to find the total count of the customers in occupations and categorize using the occupation criteria. 
# Also, sort it in descending order.
select occupation, count(distinct customerkey) as count
from customers
group by occupation
order by count desc

#10
# Query to find the total count of customers in different educational levels and categorize using the education level criteria. 
select educationlevel, count(distinct customerkey) as count
from customers
group by educationlevel
order by count desc

#11. How would you find unique gender from country column without using distinct?
# Distinct vs your method which is more efficient and why?

select gender from customers
group by Gender
