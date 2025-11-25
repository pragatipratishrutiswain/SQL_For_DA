#1. find the next to next day sales for the company

1.
select companyname, sales,
lead(sales,2) over(partition by companyname order by date) as next_to_next_day_sales
from company;

#2.. find the difference between current day sales and previous day 

sales for each customers transactions. (no need to replace nulls)

select * from sales;

2. 
select *, round(sales_amount - s.prv_sales_amt) as diff from
(select *, lag(sales_amount) over(partition by customer_id order by sales_date) as prv_sales_amt
from sales) as s;
 

---------------------------

#3
#For 2016 sales, display the year- month combination under a single column (example: 2016-07). 
#for this combination, fetch next month's average sales amount
#where sales = quantity * price. 
#Display the year-month, current months' average sales and next month's average sales
#ordered by jan to dec month

select *, lead(s1.avgsales) over( order by s1.Month) as next_month_avgsales
from 
(select date_format(OrderDate,'%Y-%m') as Month,
round(avg(OrderQuantity * ProductPrice), 2) as avgsales
from sales_2016 s
join Products p on s.ProductKey = p.ProductKey
group by 1
order by 1) as s1;

#4 Analyse the monthly sales trend for 2016,2017 and 2018.
Check for changes in total sales for each month and compare it with the 
previous month total sales 
(use formula for understanding trend:
% change = (current_sales - prev_sales)*100/current_sales
). 
Categorise the % change into 3 categories: 
1) increased if % change is +ve
2) decreased if % change is -ve
3) no change if % change is 0
Return the year-month, current sales, previous month sales, % change, category_change
in order of Jan to Dec 2016 to 2018

with cte as (
select *, lag(s1.total_sales) over( order by s1.Month) as prv_month_total_sales
from 
(select date_format(OrderDate,'%Y-%m') as Month,
sum(round(OrderQuantity * ProductPrice, 2)) as total_sales
from sales_2015 s
join Products p on s.ProductKey = p.ProductKey
group by 1
order by 1) as s1),

percentage_change as (
select *, concat(round( ((100 * (total_sales - prv_month_total_sales) )/ total_sales) , 2), ' %') as per_chng
from cte)

select *,
case when per_chng > 0 then 'increased'
	when per_chng < 0 then 'decreased'
    else null
end as category
from percentage_change;

------------------------------------




select * from territories;

-- print the next region for every SalesTerritoryKey
SELECT t.SalesTerritoryKey, t.Region, t.Country, t.Continent,
LEAD(t.Region) OVER (ORDER BY t.SalesTerritoryKey) AS
NextRegion
FROM territories t;

-- extract the year-month from the orderdate of sales 2016 data, print the sales of each month and the next month sales amount.
-- round the sales up to 2 decimal points and order by year-month in ascending.

SELECT
DATE_FORMAT(s.orderdate, '%Y-%m') AS year_and_month,
Round(SUM(s.orderquantity * p.productprice), 2) AS
total_sales_amount,
LEAD(round(SUM(s.orderquantity * p.productprice), 2)) OVER (ORDER BY
DATE_FORMAT(s.orderdate, '%Y-%m')) AS next_month_total_sales_amount
FROM
sales_2016 s
JOIN products p ON s.productkey = p.productkey
GROUP BY
DATE_FORMAT(s.orderdate, '%Y-%m')
ORDER BY
year_and_month;

-- print the previous region for every SalesTerritoryKey
SELECT t.SalesTerritoryKey, t.Region, t.Country, t.Continent,
LAG(t.Region) OVER (ORDER BY t.SalesTerritoryKey) AS
LastRegion
FROM territories t;

-- extract the year-month from the orderdate of sales 2016 data, print the sales of each month and the previous month sales amount.
-- round the sales up to 2 decimal points and order by year-month in ascending.

SELECT
DATE_FORMAT(s.orderdate, '%Y-%m') AS month,
Round(SUM(s.orderquantity * p.productprice), 2) AS
total_sales_amount,
LAG(round(SUM(s.orderquantity * p.productprice),2)) OVER (ORDER BY
DATE_FORMAT(s.orderdate, '%Y-%m')) AS previous_month_total_sales_amount
FROM
sales_2016 s
JOIN products p ON s.productkey = p.productkey
GROUP BY
DATE_FORMAT(s.orderdate, '%Y-%m')
ORDER BY
month;

-- Calculating the Sales Amount Change from the Previous Month

WITH cte as (
select 
	date_format(s.orderdate, '%Y-%m') as month,
    round(sum(s.OrderQuantity * p.ProductPrice), 2) as total_sales_amount
from sales_2016 s 
join products p on s.ProductKey = p.ProductKey
group by month
order by month),

cte2 as (
select *, lag(total_sales_amount) over(order by month) as previous_month_total_sales_amount
from cte),

change1 as (
select *, round(total_sales_amount - previous_month_total_sales_amount, 2) as amt_change_from_prv_month
from cte2 )

select *,
case when amt_change_from_prv_month > 0 
	then concat('Profit by ', round(amt_change_from_prv_month * 100/previous_month_total_sales_amount, 2), '%')
when amt_change_from_prv_month < 0 
	then concat('Loss by ', round(amt_change_from_prv_month * 100/previous_month_total_sales_amount, 2), '%')
else 'Not Known'
end as percentage_growth_status 
from change1;












