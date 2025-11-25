#How would you find unique countries from country column without using distinct?
#distinct vs your method - which is more efficient and why?

SELECT distinct
country
from customers
HASHING.
SORTING ,REMOVE DUPLICATES BY COMPARING WITH ABOVE ROWS



HASHING
SORTING



HASH TABLE --> \
INDIA:H1, 
AUS:H2, 
ENG:H3,
NZ:H4

INDIA
AUS
ENG
NZ
               
country
INDIA  
AUS
AUS 
ENG 
ENG 
NZ

GROUPING TIME > REMOVING TIME
AUS          AUS
             AUS
             AUS
            ENG
            
ENG          INDIA
ENG             NZ
INDIA
NZ

HASHING /SORTING
5 --- DISTINCT VS GROUP BY
7

DISTINCT 100 ROWS
SELECT *,"SERIES"
FROM CUSTOMERS

AUS   
ENG
INDIA
NZ


COUNT(DISTINCT *)
*

COL1,COL2,COL3

JOINS
-------------

select * from products;
select * from product_subcategories;
select * from product_categories;

#Find out the average selling price of each subcategory name
subcategoryname, avg price

products --> subcategorykey, price  ---> LEFT
product_sub ---> subcategorykey, subcategoryname ---> RIGHT




SELECT ps.subcategoryname,AVG(p.productprice) as mean_price
FROM products p
INNER JOIN
product_subcategories ps
ON p.productsubcategorykey = ps.productsubcategorykey
GROUP BY 1
ORDER BY 1



SELECT ps.subcategoryname,AVG(p.productprice) as mean_price
FROM products p
LEFT JOIN
product_subcategories ps
ON p.productsubcategorykey = ps.productsubcategorykey
GROUP BY 1
ORDER BY 1



SELECT ps.subcategoryname,AVG(p.productprice) as mean_price
FROM products p
RIGHT JOIN
product_subcategories ps
ON p.productsubcategorykey = ps.productsubcategorykey
GROUP BY 1
ORDER BY 1





SELECT ps.subcategoryname,AVG(p.productprice) as mean_price
FROM products p
FULL OUTER JOIN
product_subcategories ps
ON p.productsubcategorykey = ps.productsubcategorykey
GROUP BY 1
ORDER BY 1


inner ---> 37 values
left  ----> 37 values
right ---> 37 values
outer ----> 37 values

SELECT COUNT(DISTINCT productsubcategorykey)
from products; #37


SELECT COUNT(DISTINCT productsubcategorykey)
from product_subcategories; #37




CATEOGRY(bikes) ---> SUBCATEGORY (MOUNTAIN BIKES) ---> PRODUCTS (MOUNTAIN BIKES SOCKS)
ACCESS, ELEC, APPAREL
PDT       SUBCATEG
SOCKS     ACCESS
AC        ELEC
TV        ELEC
FRIDGE    ELEC

subcategoryname, price

subcategorykey, price, subcategorykey, subcategoryname


* ----> count all rows
column name --> counts only non null values

VARIANCE
STDDEV