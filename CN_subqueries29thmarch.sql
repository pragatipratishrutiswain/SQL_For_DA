CTEs
Common table expressions

WITH cte_name AS (
query

)

select * from cte


select * from products
#find the products that were returned in 2015 and were red colour
#also find the order quantity of these products in 2015.
#return only those combinations which have total return quantity > 700
products --> pkey, pname , pcolour
sales2015 - pkey, orderquantity
returns -  pkey, returnquantity





select p.productkey, p.productname, p.productcolor,
SUM(s.orderquantity), SUM(r.returnquantity)
from products p
JOIN 
returns r 
on p.productkey = r.productkey
AND p.productcolor = "Red"
AND RIGHT(r.returndate,4) = "2015"
lEFT JOIN sales2015 s
on p.productkey = s.productkey
GROUP BY 1,2,3
HAVING SUM(r.returnquantity) > 700






WITH rtrnd_red_pdts_15 AS (
select p.productkey, p.productname, p.productcolor,
r.returnquantity
from products p
JOIN 
returns r 
on p.productkey = r.productkey
AND p.productcolor = "Red"
AND RIGHT(r.returndate,4) = "2015"),

order_2015_rtrnd as (
select rrp.*, s.orderquantity
from rtrnd_red_pdts_15 rrp
LEFT JOIN
sales_2015 s
on rrp.productkey = s.productkey
),

agg_results_filtered AS(
select productkey, productname, productcolor,
SUM(orderquantity), SUM(returnquantity)
 from order_2015_rtrnd 
group by  1,2,3
HAVING SUM(returnquantity) > 700
)

select * from agg_results_filtered





update
set newcol = cte.col1




select * from agg_results_filtered




#readability


#is subquery better or CTE ? Why?
cte > subquery  for readability
cte > subquery runs faster

cte > subquery


select *  from order_2015_rtrnd




 
 
Return pkey, pname, orderquanity,_2015, returnquantity, colour












WITH RETURN_RED_PRODUCTS_2015 AS (
SELECT P.PRODUCTKEY, P.PRODUCTNAME, P.PRODUCTCOLOR, R.RETURNQUANTITY
FROM PRODUCTS P
JOIN RETURNS R
	ON P.PRODUCTKEY = R.PRODUCTKEY 
    AND P.PRODUCTCOLOR = 'RED'
    AND R.RETURNDATE LIKE '%2015'
    ),
    
ORDER_ON_2015_RETURNED AS (
SELECT RRP.* , S.ORDERQUANTITY
FROM RETURN_RED_PRODUCTS_2015 
LEFT JOIN
SALES_2015 S
	ON RRP.PRODUCTKEY = S.PRODUCTKEY
	),
AGG_REULTS_FILTERED AS (
SELECT ProductKey, ProductName, ProductColor, SUM(S.ORDERQUANTITY), SUM(R.RETURNQUANTITY)
FROM ORDER_ON_2015_RETURNED
GROUP BY 1,2,3
HAVING SUM(RETURNQUANTITY) > 700
)

no storage

select salary from employee where salary < (select avg(salary) from employee)

select productkey, 100
from products


correlated subqueries

#find those productkeys, productnames, productprice, thier subcategory's average price
#which have price > average price of their subcategory's average price


WITH avg_price_subcatgeory AS
(select ProductSubcategoryKey, AVG(productprice) as mean_price
from products 
group by 1)

select p.productkey, p.productname,p.productprice, aps.mean_price
from products p 
JOIN avg_price_subcatgeory aps
on p.ProductSubcategoryKey = aps.ProductSubcategoryKey
where p.productprice > aps.mean_price




s1. 200


s2. 150


p1, s1, 250, 200

#find the (overall returns) and (the total sales  only in 2015) for each category name 
where sales = quantity * product price


catgeory --> ckey, cname
subcategory --> skey, ckey
products -- > pkey, skey, productprice
returns --> pkey
sales_2015 --> pkey, quantity


WITH return_per_category AS (
select pc.categoryname, sum(IFNULL(r.returnquantity,0)) as total_return
from product_categories pc
LEFT JOIN
product_subcategories ps 
on pc.ProductcategoryKey = ps.ProductcategoryKey
JOIN products p 
ON p.ProductsubcategoryKey = ps.ProductsubcategoryKey
LEFT JOIN returns r
on r.productkey =  p.productkey
group by 1
),
sales_2015_per_category AS (
select pc.categoryname, SUM(IFNULL(s.OrderQuantity,0)*p.productprice) as total_sales_2015
from product_categories pc
LEFT JOIN
product_subcategories ps 
on pc.ProductcategoryKey = ps.ProductcategoryKey
JOIN products p 
ON p.ProductsubcategoryKey = ps.ProductsubcategoryKey
LEFT JOIN sales_2015 s
on s.ProductKey = p.ProductKey
group by 1
)

select rc.categoryname,rc.total_return,s2.total_sales_2015
from return_per_category rc
INNER JOIN sales_2015_per_category s2
on rc.categoryname = s2.categoryname

HOMEWORK
------------------
cname, pkey, price, quantity

OPTIMIZE THE BELOW QUERY FOR BETTER TIME COMPLEXICITY
------------------------------------------------------

SELECT c.customerkey,
CONCAT(c.firstname, ' ', c.lastname) AS customer_name,
SUM(s_2015.orderquantity) AS total_sales_quantity
FROM sales_2015 s_2015
JOIN customers c ON s_2015.customerkey = c.customerkey
GROUP BY c.customerkey, customer_name

UNION ALL

SELECT c.customerkey,
CONCAT(c.firstname, ' ', c.lastname) AS customer_name,
SUM(s_2016.orderquantity) AS total_sales_quantity
FROM sales_2016 s_2016
JOIN customers c ON s_2016.customerkey = c.customerkey
GROUP BY c.customerkey, customer_name

UNION ALL

SELECT c.customerkey,
CONCAT(c.firstname, ' ', c.lastname) AS customer_name,
SUM(s_2017.orderquantity) AS total_sales_quantity
FROM sales_2017 s_2017
JOIN customers c ON s_2017.customerkey = c.customerkey
GROUP BY c.customerkey, customer_name
ORDER BY total_sales_quantity DESC
LIMIT 5;







