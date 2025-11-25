select * from customers;
select * from products;
select * from returns; 
select * from product_subcategories;
select * from product_categories;
select * from territories;
select * from calendar;
select * from sales_2015;
select * from sales_2016;
select * from sales_2017;

DESC customers;
select count(*) from customers		#2062
select count(distinct customerkey) from customers		#2062

DESC products
select count(*) from products			#293
select count(distinct productkey) from products		#293
select count(distinct ProductSubcategoryKey) from products		#37

DESC product_categories
select count(*) from product_categories				#4
select count(distinct productcategorykey) from product_categories	#4

DESC Product_Subcategories
select count(*) from product_subcategories			#37
select count(distinct productsubcategorykey) from product_subcategories	#37

DESC returns
select count(*) from returns

DESC territories
select count(*) from territories		#10
select count(distinct SalesTerritoryKey) from territories		#10

DESC sales_2015
select count(*) from sales_2015		#2630

DESC sales_2016
select count(*) from sales_2016		#23935

DESC sales_2017
select count(*) from sales_2017		#29481

DESC calendar
select count(*) from calendar		#912
select count(distinct date) from calendar		#912


1.FIND THE NUMBER OF PRODUCTS THAT HAVE BEEN RETURNED

select count(distinct productkey) from returns;

2. FIND THE AVERAGE SELLING PRICE AND TOTAL COST FOR EACH PRODUCT SUBCATEGORIES

select productSubcategorykey, round(avg(productprice)) as mean_sp, round(sum(productcost)) as total_cost
from Products
group by 1
order by 1

3.WHICH COUNTRY HAS THE HIGHEST RETURNS?

select count(salesterritorykey) from territories    # 10
select count(distinct TerritoryKey) from returns    # 8

select t.country, sum(r.ReturnQuantity) as ReturnQuantity from territories t
join returns r on t.SalesTerritoryKey = r.TerritoryKey
group by 1
order by ReturnQuantity desc
limit 1

4. WHICH CATEGORY NAME HAS LESS THAN 50% RETURNS OF ORDERS MADE IN 2017?

p.key ----> sub.key ----> cat.key 

sum ReturnQuantity < count ordernumber 2017 * 0.5

select pc.CategoryName, sum(r.ReturnQuantity) as total_qnt_returned, count(s.OrderNumber) as count_orders
from product_categories pc
join product_subcategories ps 
on pc.ProductCategoryKey = ps.ProductCategoryKey
join products p
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
left join sales_2017 s
on s.ProductKey = p.ProductKey
left join returns r
on r.ProductKey = p.ProductKey
and right(ReturnDate,4) = '2017'
group by 1
having total_qnt_returned < 0.5 * count_orders



-- SUM(r.ReturnQuantity)/COUNT(s.OrderNumber) as ratio_returns
-- from product_categories pc
-- INNER JOIN
-- product_subcategories ps
-- on pc.productcategorykey = ps.productcategorykey
-- INNER JOIN
-- products p 
-- on p.productsubcategorykey = ps.productsubcategorykey
-- LEFT JOIN sales2017 s
-- on s.productkey = p.productkey
-- LEFT JOIN returns r
-- ON r.productkey = p.productkey
-- AND RIGHT(r.returndate,4)  = "2017"
-- GROUP BY 1
-- HAVING ratio_returns < 0.5
-- ORDER BY 1

select pc.CategoryName,COUNT(s.OrderNumber) as no_orders_2017, SUM(r.ReturnQuantity) as total_return_quantity,
SUM(r.ReturnQuantity)/COUNT(s.OrderNumber) as ratio_returns
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

SELECT
	pc.CategoryName,
    SUM(r.ReturnQuantity)/SUM(s_17.OrderQuantity) AS return_ratio
FROM
	product_categories pc
INNER JOIN
	product_subcategories ps
ON 
	pc.ProductCategoryKey = ps.ProductCategoryKey
INNER JOIN 
	products p 
ON 	
	ps.ProductSubcategoryKey = p.ProductSubcategoryKey
LEFT JOIN
	sales_2017 s_17
ON
	p.ProductKey = s_17.ProductKey
LEFT JOIN
	returns r 
ON 
	p.ProductKey = r.ProductKey
WHERE 
	r.ReturnDate LIKE "%2017"
GROUP BY 
	1
 HAVING
	return_ratio < 0.5;

5. FIND MODEL NAMES WHICH HAVE NOT EVEN A SINGLE RETURN

model	p.pkey		r.pkey
m1		p1			p1
m1		p2			P2
M2 		p3			null
m2		p4			p4
m5		p5			null
m5		p6			null

output should be m5

select ModelName from products p
left join returns r on p.ProductKey = r.ProductKey
group by ModelName	
having count(r.ProductKey) = 0


-- 1) Calculate the total return quantity for each product subcategory 
-- and retrieves the top 5 subcategories with the highest return quantities.
returns - productkey, ReturnQuantity
products- productkey, ProductSubcategoryKey

ReturnQuantity ----> productkey ----> ProductSubcategoryKey
returns  products-subact
p1			s1
p1			s1
p2			s1
p3			s2
p4			s2

select ps.SubcategoryName, sum(r.ReturnQuantity) as Total_Quantity
from returns r
join products p on r.ProductKey = p.ProductKey
join product_subcategories ps on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
group by 1
order by 2 desc
limit 5
 

-- 2) Retrieve the ProductKey and ProductName of products that have not been returned

select count(distinct productkey) from products		#293
select count(distinct productkey) from returns		#124

ProductKey ---> ProductName

select ProductName, p.ProductKey, r.ProductKey
from products p
left join returns r on r.ProductKey = p.ProductKey
where r.ProductKey is null


-- 3) Return the 3rd and 4th highest productname, categoryname, subcategoryname combination
-- based on average product cost and total price for only red product colour

productname, productkey -----> ProductSubcategoryKey, subcategoryname -------> ProductCategoryKey, categoryname

select categoryname, subcategoryname, productname, avg(productprice), sum(productprice)
from products p
join product_subcategories ps
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join product_categories pc 
on pc.ProductCategoryKey = ps.ProductCategoryKey
where ProductColor = 'RED'
group by 1,2,3
order by avg(productprice) desc
limit 2
offset 2

select categoryname, subcategoryname, productname, avg(productprice), sum(productprice)
from products p
left join product_subcategories ps
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
left join product_categories pc 
on pc.ProductCategoryKey = ps.ProductCategoryKey
where ProductColor = 'RED'
group by 1,2,3
order by avg(productprice) and sum(productprice) desc
limit 2
offset 2

-- 4) In year 2015, find out total order quantity, total return quantity for each product name

Each p.key has a unique p.name------> refer products table

INPUT
sales					|	returns
-----					|	-------
o.num	p.key	quant	|	p.key	quant
o1		p1		20		|	p1		10
o2		p1		40		|	p1		20
o3		p2		15		|	p3		10
o4		p2		12		|	p3		40
o5		p3		31		|	
o6		p3		20		|	

OUTPUT_Left_Join sales on returns,	group by p.key
p.key	quantordered	p.key	quantreturned
p1		60				p1		30
p2		27				p2		null
p3		51				p3		50


select p.ProductName,sum(OrderQuantity) as total_qnt_ordered, sum(ReturnQuantity) as total_qnt_returned 
from sales_2015 s
left join returns r
on s.productkey = r.productkey and right(ReturnDate,4) = '2015'
join products p
on s.productkey = p.productkey
group by 1										#44 rows
-- union
-- select p.ProductName, sum(OrderQuantity) as total_qnt_ordered, sum(ReturnQuantity) as total_qnt_returned 
-- from returns r
-- left join sales_2015 s
-- on s.productkey = r.productkey and right(ReturnDate,4) = '2015'
-- join products p
-- on s.productkey = p.productkey
-- group by 1

select p.ProductName, sum(OrderQuantity) as total_qnt_ordered, sum(ReturnQuantity) as total_qnt_returned 
from products p
left join returns r
on p.productkey = r.productkey and right(ReturnDate,4) = '2015'
left join sales_2015 s
on s.productkey = p.productkey
group by 1 

select p.productname , sum(s_15.orderquantity), sum(r.returnquantity) from products p
left join returns r on r.productkey = p.productkey and right(r.returndate,4) = "2015"
left join sales_2015 s_15 on p.productkey = s_15.productkey 
group by p.productname;					#293 rows

select p.productname , sum(s_15.orderquantity) ,sum(r.returnquantity) from sales_2015 s_15
left join returns r on p.productkey = r.productkey  and right(r.returndate,4) = "2015"
left join products p  on p.productkey = s_15.productkey
group by p.productname;

select p.productname , sum(s_15.orderquantity) ,sum(r.returnquantity) from sales_2015 s_15
left join returns r on s_15.productkey = r.productkey  and right(r.returndate,4) = "2015"
left join products p  on p.productkey = s_15.productkey
group by p.productname

-- 5) For each product name which had atleast 1 order sold in 2015 but no orders in 2016 and 2017,
-- find out the average order quantity

products				2015		2016		2017		|OUTPUT
--------				----		----		----		|------
p1						p1			p1			p1			|	p6
p2						p2			null		p2			|
p3						p3			p3			null		|
p4						null		p4			p4			|
p5						null		null		null		|
p6						p6			null		null
p7						null		p6			null
p7						null		null		p7

select p.ProductName, 
avg(s15.OrderQuantity) as avg_2015_qnt,
sum(s15.OrderQuantity) as tot_2015_qnt ,
sum(s16.OrderQuantity) as tot_2016_qnt, 
sum(s17.OrderQuantity) as tot_2017_qnt
from sales_2015 s15
join products p on s15.ProductKey = p.ProductKey
left join sales_2016 s16 on s15.ProductKey = s16.ProductKey
left join sales_2017 s17 on s15.ProductKey = s17.ProductKey
where s16.ProductKey is null and s17.ProductKey is null
group by 1

SELECT 
    p.ProductName,
    COALESCE(s15.avg_qty, 0) AS avg_2015_qnt,
    COALESCE(s15.total_qty, 0) AS tot_2015_qnt,
    COALESCE(s16.total_qty, 0) AS tot_2016_qnt,
    COALESCE(s17.total_qty, 0) AS tot_2017_qnt
FROM products p
LEFT JOIN (
    SELECT ProductKey, AVG(OrderQuantity) AS avg_qty, SUM(OrderQuantity) AS total_qty
    FROM sales_2015 
    GROUP BY ProductKey
) s15 ON s15.ProductKey = p.ProductKey
LEFT JOIN (
    SELECT ProductKey, SUM(OrderQuantity) AS total_qty
    FROM sales_2016 
    GROUP BY ProductKey
) s16 ON s16.ProductKey = p.ProductKey
LEFT JOIN (
    SELECT ProductKey, SUM(OrderQuantity) AS total_qty
    FROM sales_2017 
    GROUP BY ProductKey
) s17 ON s17.ProductKey = p.ProductKey
WHERE s15.total_qty >= 1 AND s16.total_qty IS NULL AND s17.total_qty IS NULL;


SELECT p.ProductName, AVG(s15.OrderQuantity) AS avg_2015_qnt,  SUM(s15.OrderQuantity) AS tot_2015_qnt
FROM products p
LEFT JOIN sales_2015 s15 ON s15.ProductKey = p.ProductKey
WHERE p.ProductKey NOT IN (SELECT ProductKey FROM sales_2016)
AND p.ProductKey NOT IN (SELECT ProductKey FROM sales_2017)
GROUP BY p.ProductName
HAVING tot_2015_qnt >= 1;

select p.productname , avg(s_15.orderquantity) from products p
inner join sales_2015 s_15 on p.ProductKey = s_15.ProductKey
where not exists ( select * from sales_2016 s_16 where p.ProductKey = s_16.ProductKey)
and not exists (select * from sales_2017 s_17 where p.ProductKey = s_17.ProductKey)
group by 1
having avg(s_15.orderquantity) >=1;