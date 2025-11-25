CTEs
COMMON TABE EXPRESSIONS

WITH CTE_NAME AS (
QUERY
)

SELECT * FROM THE CTE_NAME

SELECT * FROM PRODUCTS

# FIND THE PRODUCTS THAT WERE RETURNED IN 2015 AND WERE RED COLOR. 
# ALSO FIND THE ORDER QUANTITY OF THESE PRODUCTS IN 2015.
# RETURN PKEY, PNAME, ORDERQUANTTIY, _2015, RETURNQUANTITY, COLOR
# RETURN PRODUCTS WHICH HAVE TOTALRETURNQUANTITIES > 700
PRODUCTS ---> PRODUCTKEY , PRODUCTNAME, PRODUCTCOLOR
SALES_2015 ---> PRODUCTKEY, ORDERQUANTITY
RETURNS ---> PKEY, RETURQUANTITY

METHOD-1
--------
SELECT P.PRODUCTKEY, P.PRODUCTNAME, P.PRODUCTCOLOR,
SUM(S.ORDERQUANTITY), SUM(R.RETURNQUANTITY)
FROM PRODUCTS P
JOIN RETURNS R
	ON P.PRODUCTKEY = R.PRODUCTKEY 
    AND P.PRODUCTCOLOR = 'RED'
    AND R.RETURNDATE LIKE '%2015'
LEFT JOIN SALES_2015 S
	ON P.PRODUCTKEY = S.PRODUCTKEY
GROUP BY 1,2,3
HAVING SUM(R.RETURNQUANTITY) > 700

-- WITH CTE --
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
FROM RETURN_RED_PRODUCTS_2015 RRP
LEFT JOIN
SALES_2015 S
	ON RRP.PRODUCTKEY = S.PRODUCTKEY
	),

AGG_REULTS_FILTERED AS (
SELECT ProductKey, ProductName, ProductColor, SUM(ORDERQUANTITY), SUM(RETURNQUANTITY)
FROM ORDER_ON_2015_RETURNED
GROUP BY 1,2,3
HAVING SUM(RETURNQUANTITY) > 700
)
SELECT * FROM AGG_REULTS_FILTERED

-- SELECT * FROM RETURN_RED_PRODUCTS_2015
-- SELECT * FROM ORDER_ON_2015_RETURNED


-- QN - Is there a performance difference between CTE , Sub-Query, Temporary Table or Table Variable?
CTE > SUBQUERY FOR READABILITY
CTE > SUBQURY RUNS FASTER 

ALWAYS USE A CTE OVER A SUBQUERY

#fIND THOSE PKEYS, PNAMES, Productprice, their subcategory's avg price which have price > avg price of their subcat's avg price?

/* 1. ----- WITHOUT CTE-------- */
STEPS - find productkey, productname, ProductSubcategoryKey, productprice in table 1
		find subcategory and avg pprice in table 2
        JOIN BOTH THE TABLES
        
select 
	T1.productname, T1.productkey, T1.ProductSubcategoryKey, 
    T1.productprice, T2.MeanPrice 
from 
( select productkey, productname, ProductSubcategoryKey, productprice
  from products ) AS T1
Join 
( select ProductSubcategoryKey, avg(ProductPrice) AS MeanPrice 
  from products
  group by ProductSubcategoryKey ) AS T2
	
ON T1.ProductSubcategoryKey = T2.ProductSubcategoryKey
HAVING T1.productprice > T2.MeanPrice
ORDER BY T1.productprice DESC

/* 2. ----- WITH CTE-------- */

WITH T AS (
SELECT ProductSubcategoryKey, AVG(ProductPrice) AS MeanPrice
FROM products
GROUP BY ProductSubcategoryKey )

SELECT P.ProductName, P.ProductKey, P.ProductSubcategoryKey, P.ProductPrice, T.MeanPrice
FROM products P

INNER JOIN T
ON P.ProductSubcategoryKey = T.ProductSubcategoryKey
WHERE P.ProductPrice > T.MeanPrice
ORDER BY P.ProductPrice DESC

/* Using Subquery instead of Group By */

SELECT P.ProductName, P.ProductKey, P.ProductSubcategoryKey, P.ProductPrice, 
( SELECT AVG(ProductPrice) AS MeanPrice											-- Redundancy in compiling the query
  FROM products P2
  WHERE P2.ProductSubcategoryKey = P.ProductSubcategoryKey ) AS MeanPrice
FROM products P
    
WHERE P.ProductPrice > ( SELECT AVG(ProductPrice) AS MeanPrice					-- Redundancy in compiling the query
						 FROM products P2
                         WHERE P2.ProductSubcategoryKey = P.ProductSubcategoryKey )
ORDER BY P.ProductPrice DESC

------------------------------------------------------------------------------------------------------
#Find the (overall returns) and (the total sales only in 2015) for each category name where sales = qnt * prdct price
/* INFORMATION */
PRODUCTS- ProductKey, ProductSubcategoryKey, ProductPrice
product_subcategories- ProductSubcategoryKey, ProductCategoryKey
product_categories- ProductCategoryKey, CategoryName
RETURNS- ProductKey, ReturnQuantity
SALES_2015- ProductKey, OrderQuantity

WITH 
OVERALL_RETURNS AS (
SELECT CategoryName, COALESCE(SUM(ReturnQuantity), 0) AS RETURNS_OVERALL
FROM PRODUCTS P
LEFT JOIN RETURNS R
	ON R.PRODUCTKEY = P.PRODUCTKEY
INNER JOIN product_subcategories PS
	ON PS.ProductSubcategoryKey = P.ProductSubcategoryKey
INNER JOIN product_categories PC
	ON PC.ProductCategoryKey = PS.ProductCategoryKey
GROUP BY 1 ),

SALES_IN_2015 AS (
SELECT CategoryName, COALESCE(SUM(OrderQuantity * ProductPrice), 0) AS TOTAL_SALES_2015
FROM PRODUCTS P
LEFT JOIN SALES_2015 S
	ON P.PRODUCTKEY = S.PRODUCTKEY
INNER JOIN product_subcategories PS
	ON PS.ProductSubcategoryKey = P.ProductSubcategoryKey
INNER JOIN product_categories PC
	ON PC.ProductCategoryKey = PS.ProductCategoryKey
GROUP BY 1 )

SELECT S.*, R.RETURNS_OVERALL
FROM SALES_IN_2015 AS S
JOIN OVERALL_RETURNS AS R
	ON S.CategoryName = R.CategoryName
-----------------------------------------------
CODING NINJA ANSWER

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
-------------------------------------------------------------------

/* HOMEWORK - WRITE IN CTE FORMAT TO OPTIMIZE THE BELOW SQL QUERY */

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
-------------------------------------------

/* MY APPROACH */

WITH Combined_Sales AS (
	SELECT CustomerKey, OrderQuantity FROM sales_2015
UNION ALL
	SELECT CustomerKey, OrderQuantity FROM sales_2016
UNION ALL
	SELECT CustomerKey, OrderQuantity FROM sales_2017 )
    
SELECT 
	C.customerkey,
	CONCAT(firstname, ' ', lastname) AS customer_name, 
	SUM(COALESCE(CS.OrderQuantity, 0)) AS total_sales_quantity
FROM customers C

INNER JOIN Combined_Sales CS
	ON C.customerkey = CS.customerkey

GROUP BY 1,2
ORDER BY total_sales_quantity DESC
LIMIT 5;