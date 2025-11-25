1. FIND THE NUMBER OF PRODUCTS THAT HAVE BEEN RETURNED
2. FIND THE AVERAGE SELLING PRICE AND TOTAL COST FOR EACH PRODUCT SUBCATEGORIES
3. WHICH COUNTRY HAS THE HIGHEST RETURNS?
4. WHICH CATEGORY NAME HAS LESS THAN 50% RETURNS OF ORDERS MADE IN 2017?
5. FIND MODEL NAMES WHICH HAVE NOT EVEN A SINGLE RETURN



products 




categoryname, number of orders in 2017, total returns
sales2017



category ---> subcategor ---> products
Electronics ----> tv.    ----> sony tv
                  ac

category ---> categoryname, categorykey
products subcategory ---> categorykey, subcategorykey #INNER
products ---> subcategorykey, productkey  #INNER
sales2017 ---> productkey , ordernumber #LEFT
returns ---> productkey, returnquantity #LEFT



select pc.CategoryName,COUNT(distinct s.OrderNumber) as no_orders_2017, SUM(r.ReturnQuantity) as total_return_quantity,
SUM(r.ReturnQuantity)/COUNT(distinct s.OrderNumber) as ratio_returns
from product_categories pc
INNER JOIN
product_subcategories ps
on pc.productcategorykey = ps.productcategorykey
INNER JOIN
products p 
on p.productsubcategorykey = ps.productsubcategorykey
LEFT JOIN sales2017 s
on s.productkey = p.productkey
LEFT JOIN returns r
ON r.productkey = p.productkey
AND RIGHT(r.returndate,4)  = "2017"
GROUP BY 1
HAVING ratio_returns < 0.5
ORDER BY 1





p.pkeys, s.pkeys, returns
1.        1, O1          1
2.        1.O2         1
3.        1,O3     

1.       1 , O1        1
1       1 , O2         1
1        1, O3         1
1.       1, O1         1
1       1, O2          1
1        1, O3         1


select distinct returndate
from returns


     orders returns return quantity
c1,p1.  p1.    NULL
c1,p2.  NULL    p2.    5
c1,p2   NULL.   p2.    7
c2, p3   p3.     NULL. NULL

cn # of order/return quantity < 0.5
c1 1.     12
c2. 1.    0





categoryname,subcategorykey, productkey, ordernumber




tv ---> p1  ---> 5,  30 
tv ---> p2 ----> 7,   45

tv ---> 12, 75


75/12 < 0.5



category1, p1--  7
category1, p2 --- 5

category1, p1 ---> 20
category1, p2 ---> 7



sony tv qty 7
apple tv 5


products ---> pkey, skey
ps ----> skey, ckey
categories ---> ckey, cname
sales2017 ---> pkey, ordernumber, tkey
returns ---> tkey, pkey

select count(distinct productkey) from returns

select * from product_subcategories
products --> price, cost, subcategorykey
ps ---> subcategorykey, subcategoryname

categories ---> subccategories ---> products
electronics. ----> tv ---------> sony tv


sony tv---> tv.  --->10
apple tv ---> tv.  ---> 5

tv


p. ---> 5
ps ---> 7


select * from products

select ps.SubcategoryName,avg(p.productprice) as mean_sp, sum(p.productcost) as totalcost
from products p
INNER JOIN
product_subcategories ps
on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
group by 1
order by 1



territories ---> salestky, country
returns ---> tkey,return qty


select * from territories
t
t1

returns
p1. t1,   qty
p2.  t1,  qty


select count(distinct SalesTerritoryKey) from territories. #10
select count(distinct territorykey) from returns. #8


select count(*) from territories; #10
select count(*) from returns #1809



select t.country, sum(r.returnquantity) as totalreturn
from territories t
LEFT JOIN
returns r
on t.SalesTerritoryKey = r.territorykey
group by 1
order by 2 desc
limit 1

SELECT distinct t.country
from territories t
INNER JOIN
returns r
on t.SalesTerritoryKey = r.territorykey






USA. 5
USA. 4
AUS. NULL

USA 9
AUS NULL



products ---> model pkey

returns ---> pkey returned
returns

model 


select p.modelname
from products p 
LEFT JOIN 
returns r 
on p.productkey = r.productkey
AND p.pid = r.pid
group by 1
having count(r.productkey)  = 0

m1 p1.       
m1 p2.     p2
m1 p3.     p3
m2.p4      p2

m1. p1.   p1
m1. p2.   p2
m1  p3.   p3
m1  p2.   p2
m2  p4.   NULL
m2  p5.   NULL 
m2  p6.   NULL


count(productkey) 



m2





-- 1) Calculate the total return quantity for each product subcategory name
-- and retrieves the top 5 subcategories with the highest return quantities.

-- 2) Retrieve the ProductKey and ProductName of products that have not been returned

-- 3) Return the 3rd and 4th highest productname, categoryname, subcategoryname combination
-- based on average product cost and total price (tie - breaker) for only red colour products

-- 4) In year 2015, find out total order quantity, total return quantity for each product name

Select p.productname, SUM(s.OrderQuantity) as no_orders_2015, SUM(r.returnquantity) as Totalreturns
from products p
LEFT JOIN sales2015 s on s.productkey = p.productkey
LEFT JOIN returns r ON r.productkey = p.productkey
GROUP BY 1


p.         sales.              return 
1.           1, 5                 2, 5
2            1,  7
3


1           1.   5.        NULL
1           1.   7.        NULL
2.          NULL. NULL.     2, 5



total 124 rows, # of orders = sum of return qrty

-- 5) For each product name which had atleast 1 order sold in 2015 but no orders in 2016 and 2017,
-- find out the average order quantity

select * from product_categories 
CROSS JOIN products



4,   293


p., cost     c.  rank
1. 200       a.    70
2.  100      b.   40
3. 40        c    50
4 50
570


p.      c
1. 200  a.    70
1. 200  b.   40
1. 200  c    50
2.  100   a.    70


 
 #cross join , self join, union all , union distinct, if null, coalesce
 #case when



5 rows                   customers 7 rows
products               


5*7 = 35

------------------------------------------------------------------------------------------

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique employee ID
    employee_name VARCHAR(100) NOT NULL,          -- Employee's name
    department_id INT,                            -- Department ID for the employee
    manager_id INT                           -- Manager's employee ID (self-join reference
);

INSERT INTO employees (employee_name, department_id, manager_id) 
VALUES 
('Alice', 1, NULL),
('Bob', 2, 1),
('Charlie', 3, 1),
('David', 2, 2);

select m.*,e.* from employees m
LEFT JOIN employees e
on m.manager_id = e.employee_id


select e.*, m.* from employees e
LEFT JOIN employees m
on m.manager_id = e.employee_id



select * from sales2015


select p.productkey,r.returnquantity,
IFNULL(r.returnquantity,0) from products p
left join
returns r
on p.productkey = r.productkey
order by 3


select p.productkey,r.returnquantity,
IFNULL(r.returnquantity,orderquantity),
COALESCE(r.returnquantity, NULL, orderquntity, NULL, p.productkey)
from products p
left join
returns r
on p.productkey = r.productkey
order by 3


COALESCE(r.returnquantity, orderquantity, 100, "Unknown")

r    o
null. 7.        7
null NULL.      100
5.     Null.      5
8.     10        8

mysql
union 
union all

products
pkeys,  returnqtyt
1,        200
2
3
4

pkeys
1,      500
5
1,       200
7
1

1
2
3
4
1
5
1
7
1






1
2
3
4
5
7

select productcategorykey from product_categories
UNION
select productcategorykey from product_subcategories

select productcategorykey, categoryname as combined_name from product_categories
UNION 
select productcategorykey, subcategoryname  from product_subcategories

----------------------------------------------------------------------------------------
(SELECT c.customerkey,
CONCAT(c.firstname, ' ', c.lastname) AS customer_name,
SUM(s_2015.orderquantity) AS total_sales_quantity
FROM sales2015 s_2015
JOIN customers c ON s_2015.customerkey = c.customerkey
GROUP BY c.customerkey, customer_name)

UNION ALL

(SELECT c.customerkey,
CONCAT(c.firstname, ' ', c.lastname) AS customer_name,
SUM(s_2016.orderquantity) AS total_sales_quantity
FROM sales2016 s_2016
JOIN customers c ON s_2016.customerkey = c.customerkey
GROUP BY c.customerkey, customer_name)

UNION ALL

(SELECT c.customerkey,
CONCAT(c.firstname, ' ', c.lastname) AS customer_name,
SUM(s_2017.orderquantity) AS total_sales_quantity
FROM sales2017 s_2017
JOIN customers c ON s_2017.customerkey = c.customerkey
GROUP BY c.customerkey, customer_name)
ORDER BY total_sales_quantity DESC
LIMIT 5


sales
returns
pkey



sales. returns
200.   NULL
500.   500

UNION  

sales.  returns 
NULL.    7
500.   500


200.   NULL
500.   500
NULL.    7


#which is more efficient to figure out unique customer ids and why?
- union vs union all
if both the columns of customer ids themselves are unique and non overlapping

cid
1
2
3

customerid
4
5
6





--------------------------------

SELECT pc.categoryName, ps.subcategoryName, 
       ROUND(SUM(COALESCE(p.productCost, 0)), 2) AS TotalProductCost,
       ROUND(SUM(COALESCE(p.productPrice, 0)), 2) AS TotalProductPrice
FROM Products p
JOIN Product_Subcategories ps ON p.productSubcategoryKey = ps.productSubcategoryKey
JOIN Product_Categories pc ON ps.productCategoryKey = pc.productCategoryKey
GROUP BY pc.categoryName, ps.subcategoryName

UNION

SELECT pc.categoryName, 100 as subcategoryname,
       ROUND(SUM(COALESCE(p.productCost, 0)), 2) AS TotalProductCost,
       ROUND(SUM(COALESCE(p.productPrice, 0)), 2) AS TotalProductPrice
FROM Products p
JOIN Product_Subcategories ps ON p.productSubcategoryKey = ps.productSubcategoryKey
JOIN Product_Categories pc ON ps.productCategoryKey = pc.productCategoryKey
GROUP BY pc.categoryName
ORDER BY TotalProductCost DESC;


SELECT p.ProductKey, p.ProductName, r.returnQuantity
FROM products p
LEFT JOIN returns r ON p.ProductKey = r.productkey
WHERE r.returnQuantity IS NULL;



SELECT ps.subcategoryname, SUM(r.returnQuantity) AS total_return_quantity
FROM returns r
JOIN products p ON r.productkey = p.ProductKey
JOIN product_subcategories ps ON p.productsubcategorykey = ps.productsubcategorykey
JOIN product_categories pc ON ps.productcategorykey = pc.productcategorykey
GROUP BY ps.subcategoryname
ORDER BY total_return_quantity DESC
LIMIT 5;



SELECT t.region, t.country, SUM(r.returnQuantity) AS total_return_quantity,
AVG(r.returnQuantity) AS mean_quantity
FROM returns r
JOIN territories t ON r.territorykey = t.salesterritorykey
GROUP BY t.region, t.country
HAVING total_return_quantity > 200
ORDER BY 3, 4 desc


SELECT pc. categoryname, ps.subcategoryName, SUM(r.returnQuantity) AS total_return_quantity
FROM returns r
JOIN products p ON r.productkey = p.ProductKey
JOIN product_subcategories ps ON p.productsubcategorykey = ps.productsubcategorykey
JOIN product_categories pc ON ps.productcategorykey = pc.productcategorykey
GROUP BY pc. categoryname, ps.subcategoryName
ORDER BY pc. categoryname, ps.subcategoryName;


#cn assesment, sqlzoo, hackerank 




city, country,   population 
Hyd,   IND.      10
Hyd,   IND.       7
DEL,   IND.      20
BLR,   IND.      30
CHN,   IND.      15


Hyd
DEL
BLR
CHN



select city, country, avg (population)
group by city,country,  avg(population)




