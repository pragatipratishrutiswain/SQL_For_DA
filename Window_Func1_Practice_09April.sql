select * from customers;
/*
SELECT
window_function() OVER(
PARTITION BY partition_expression
ORDER BY order_expression
window_frame_extent
) AS window_column_alias
FROM table_name

window_function() – This is a function like ROW_NUMBER(), RANK(), SUM(), AVG(), etc., that operates over a “window” of rows.
OVER(...) – Defines the window.
PARTITION BY – Splits the data into groups before applying the window function.
ORDER BY – Orders the rows within each partition.
window_frame_extent – (Optional) Defines the subset of the partition to consider, such as ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.
AS window_column_alias – Assigns an alias to the resulting column.
FROM table_name – Specifies the table. */


select Occupation, max(annual_income) as max_income
from customers
group by Occupation
order by 2;

select *, max(annual_income) over() as max_income # over() doesn't allow max() to act as an aggregate, 
from customers;									  # rather as a window() or non-aggregated column for the entire table

select *, max(annual_income) over(partition by occupation) as max_income # partition by creates a window for each distinct occupation
from customers;

							-- row_number, rank, dense_rank functions --

-- differentiate between row_number, rank, and dense_rank based on customer's occupation and their 3rd highest annual income

with cte as (
select CustomerKey, Annual_Income, Occupation,
	row_number() over(partition by Occupation order by Annual_Income desc) as rn,
    rank() over(partition by Occupation	order by Annual_Income desc) as rk,
    dense_rank() over(partition by Occupation order by Annual_Income desc) as dr
from customers)

select * from cte
where dr < 4;		# to fetch the 3rd highest annual income

-- rank all the customers of each occupation with unique values
select customerkey, occupation, row_number() over(partition by occupation) as rn
from customers;	# row number is assigned to each customer based on occupaton and order is by deafult asc given first to the upper row 

-- fetch the first 2 customers from each occupation to join the survey
with cte as
(select customerkey, occupation, row_number() over(partition by occupation order by CustomerKey) as rn
from customers	)	# order by indicated the minimum customerkey should get the least row number
select * from cte
where rn < 3;

-- fetch the top 3 customers in each occupation with max annual income, take customerkey in asc as a tie breaker.
select * from 
(select customerkey, occupation, Annual_Income, rank() over(partition by occupation order by annual_income desc, customerkey asc) as rk
from customers) as alias
where alias.rk <= 3;

-- fetch the top 3 Annual_Income in each occupation 
select * from
	(select distinct occupation, Annual_Income,
	 dense_rank() over(partition by occupation order by annual_income desc) as dnsrk from customers) as t
where t.dnsrk < 4;

								-- lead and lag functions --

-- fetch the query to dispaly if the annual income of a customer is higher, lower or equal to that of the previous customer.

select customerkey, occupation, annual_income,
	lag(annual_income) over(partition by occupation order by customerkey) as prev_customer_income,
    (case when Annual_Income > lag(annual_income) over(partition by occupation order by customerkey) then 'Higher than prev'
     when Annual_Income < lag(annual_income) over(partition by occupation order by customerkey) then 'Lower than prev'
     when Annual_Income = lag(annual_income) over(partition by occupation order by customerkey) then 'Equal to prev'
     else Null end) as compare
from customers;

-- fetch the query to dispaly if the annual income of a customer is higher, lower or equal to that of 2 records
-- previous to the current record.

select customerkey, occupation, annual_income,
	lag(annual_income, 2,'NA') over(partition by occupation order by customerkey) as prev_to_prev_customer_income
from customers;

-- fetch the query to dispaly if the annual income of a customer is higher, lower or equal to that of the next customer.

select customerkey, occupation, annual_income,
	lead(annual_income) over(partition by occupation order by customerkey) as next_customer_income
from customers;

-- fetch the query to dispaly if the annual income of a customer is higher, lower or equal to that of the next to next customer.

select customerkey, occupation, annual_income,
	lead(annual_income, 2,'NA') over(partition by occupation order by customerkey) as nxt_to_nxt_customer_income
from customers;
--------------------------------------------------------------------------------------

drop table if exists sales;

CREATE TABLE sales (
sales_id int primary key,
customer_id int,
sales_date date,
sales_amount decimal(16, 2)
);

INSERT INTO sales VALUES
(1, 1, '20200201', 500),
(2, 1, '20200301', 7200),
(3, 1, '20200401', 3440),
(4, 2, '20200315', 29990),
(5, 2, '20200921', 6700),
(6, 3, '20201026', 4500),
(7, 3, '20200611', 30000),
(8, 4, '20201229', 8560);

select * from sales;

-- Extract the details of the next sales of each customer
select *, lead(sales_amount) over (partition by customer_id order by sales_date) as next_sale from sales;

-- Extract the details of the next to next sales of each customer
SELECT customer_id, sales_date, sales_amount, LEAD (sales_amount,2) OVER
(
PARTITION BY customer_id
ORDER BY sales_date ) next_to_next_sale
FROM SALES;

-------------------------------------------------
Qn: Identify the customers who have ordered products from the same subcategory and
calculate the average number of days between orders from sales_2017.

WITH CTE AS (
	SELECT CustomerKey, ProductSubcategoryKey, OrderDate FROM sales_2017 S
    JOIN products P ON S.ProductKey = P.ProductKey ),
T2 AS(
SELECT 
	CustomerKey, ProductSubcategoryKey, OrderDate,
    LEAD(OrderDate) OVER( PARTITION BY CustomerKey, ProductSubcategoryKey ORDER BY OrderDate) AS Next_OrderDate
FROM CTE),
T3 AS (
SELECT *, DATEDIFF(Next_OrderDate, OrderDate) AS Date_Diff FROM T2 )

SELECT CustomerKey, ProductSubcategoryKey, ROUND(AVG(Date_Diff)) AS Avg_days_btw_orders 
FROM T3
GROUP BY 1,2
HAVING Avg_days_btw_orders IS NOT NULL
ORDER BY 2 DESC;


SELECT * FROM SALES_2017;

Qn: Find the product that has been out of stock for the longest from SALES_2017 and calculate the number of days it has been unavailable.

WITH CTE AS (
SELECT ProductKey, StockDate, LEAD(StockDate) OVER (PARTITION BY ProductKey ORDER BY StockDate) AS Next_StockDate
FROM sales_2017 )

SELECT ProductKey, MAX(DATEDIFF(Next_StockDate, StockDate)) AS Max_Days_Outof_Stock 
from CTE
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1				# ProductKey = 566

Qn: Write a query to calculate the yearly sales trend, showing the total sales amount and the
percentage change from the previous year from sales_2017.


