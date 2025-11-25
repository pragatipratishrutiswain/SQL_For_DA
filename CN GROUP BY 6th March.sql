#Aggregrate Functions
SUM
COUNT
MIN
MAX
AVG

VARIANCE
STDDEV




SELECT COUNT(*), COUNT(CUSTOMERKEY), COUNT(Gender), 
COUNT(COUNTRY), COUNT(1), COUNT(0), COUNT(DISTINCT Gender),
COUNT(DISTINCT COUNTRY)
FROM CUSTOMERS


COUNT COL ---> COUNTS ONLY NON NULL VALUES
COUNT DISTINCT COL ---> COUNTS ONLY UNIQUE NON NULL VALUES

100 NULL 80002 442
NULL NULL NULL 442

SELECT  * from products

#1. find out the total number of rows in products table
SELECT COUNT(*) FROM products

#2. find out how many null values are there in modelname
SELECT COUNT(*) from products 
where modelname is NULL

modelname
NULL
NULL
ABC
XYZ

select ProductCost
from products
order by ProductCost desc
limit 1;

select (ProductPrice/ProductCost) as least_ratio
from products
order by (ProductPrice/ProductCost)
limit 1;

--------------------------------------------------------------------------------

select distinct maritalstatus from customers


select * from customers

#for each marital status, calculate average income

SELECT maritalstatus, avg(annualincome)
from customers
GROUP BY maritalstatus

#for each combination of marital status and gender in customers table, find total income
select maritalstatus, gender, sum(annualincome)
from customers
GROUP BY maritalstatus, gender

#check for each occupation, how many customers are present?
select occupation,count(distinct customerkey), sum(annualincome)
from customers
group by occupation

#figure out those occupation which have average income below 50000
select occupation, avg(annualincome) as mean_income, sum(annualincome) as total_income
from customers
GROUP BY occupation
HAVING mean_income < 50000 and total_income > 4500000

#where condition will run furst comapred to grouping/aggregration


#figure out those occupation for females only which have average income below 50000
select occupation, avg(annualincome) as mean_income
from customers
WHERE gender = "F"
GROUP BY occupation
HAVING mean_income < 50000

SELECT annualincome
from customers
having annualincome >700000


SELECT * FROM TABLE
WHERE CONDITION
GROUP BY COLUMN1, COLUMN2
HAVING COLUMN 3> CONDITION
ORDER BY COLUMN1  DESC
LIMIT 5


select productcolor
from products
group by 1
having sum(productprice) > 50000



-- find out the minimum and maximum product cost and price both
-- for product color, size an style combination. Dont consider silver colour for this.
-- exclude null values from your calculation in cost and price both
-- return only the top 3 combinations in descendng order of each combinations` average cost/price ratio


select productcolor, productsize, productstyle, AVG(productcost/productprice), 
min(productcost), max(productcost),min(productprice), max(productprice)
from products
WHERE productcolor != "Silver" and productcost is not null and productprice is not null
GROUP BY 1,2,3
HAVING AVG(productcost/productprice)
ORDER BY 4 DESC
LIMIT 3




select  ProductColor, ProductSize, ProductStyle, avg(ProductCost/ProductPrice),
min(productcost), max(productcost), min(productprice), max(productprice) 
From products
where ProductColor != 'Silver'
group by 1,2,3
order by avg(ProductCost/ProductPrice) desc
limit 3;

select *
from products
WHERE  productcolor = "Yellow" and productsize = "S"  and productstyle = "U"




select *
from products
WHERE  productcolor = "Yellow" and productsize = "M"  and productstyle = "U"




#1 read about abs(), round(), group_concat()

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
# Query to find the minimum and maximum income of the customers whose income is more than the 
# difference of the minimum and maximum income on the educational level categorization.
select * from customers
-- select customerkey, educationlevel, annualincome
-- from customers
-- group by customerkey, educationlevel
-- having annualincome > (max(annualincome) - min(annualincome))

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
select * from customers
select gender, count(distinct customerkey) as countgender, count(*) from customers
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





WHERE VS HAVING








FROM
WHERE 
GROUP BY
HAVING
SELECT




WHERE + AGGREGATED FUNCTION CAN NEVER BE USED

select * from customers

#HAVING











marks
7
5
8
NULL

NULL

AVG














M  --- 2000
S   -  3000




#3. find out the highest cost in products table
SELECT MAX(productcost) as highest_cost
from products

#4. find the least ratio of price/cost
SELECT   MIN(productprice/productcost) as min_ratio
from products
 
#5. how many distinct productkeys have cost < 1000 and price >1000
SELECT COUNT(DISTINCT productkey)
from products
WHERE productcost< 1000 and productprice>1000


#6. what is total manufacturing cost?
select sum(productcost) 
from products


#7. find the ratio of overall total price by overall total cost
SELECT sum(productprice)/sum(productcost) 
from products


#8. Find total gross profit (price - cost) for overall data by summing up each rows profit
SELECT SUM(productprice - productcost) as total_gross_profit
from products
(a1-b1) + (a2-b2)
(a1+a2) - (b1+b2)  = a1-b1 + a2-b2



#9. Show the 5 summary statistics (use 5 aggregrate functions) for the price column using a single query
select SUM(productprice), AVG(productprice), MIN(productprice), MAX(productprice), COUNT(productprice)
from products

#10. Return variance and standard deviation for income column from customers table
SELECT VARIANCE(annualincome), STDDEV(annualincome)
from customers



MODELNAME
NULL
NULL
X
Y

COUNT(*)










* ----> count all rows
column name --> counts only non null values

VARIANCE
STDDEV