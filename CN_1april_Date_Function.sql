employees
id	name	salary	department_id, avg salary
1	John	5000	1.             
2	Alice	7000	1. 
3	Bob	    6000	2
4	Sarah	5500	2
5	David	8000	3
6	Emma	7500	3


departments
id	department_name
1	Sales
2	Marketing
3	Engineering

 Find employees whose salary is greater than the average salary in their department
 
 select name ,salary, department_id
 from employees0\
-- ---------------------------------------------------------------------------------------
SELECT CURDATE();
select current_date();
select current_time();
select now();
select current_timestamp();
SELECT NOW(), CURRENT_TIMESTAMP();
select unix_timestamp(); # returns the current Unix timestamp, which is the number of seconds that have elapsed since January 1, 1970 (midnight UTC/GMT) 
						 # — also known as the Unix epoch
select unix_timestamp("2020-07-20");	# Unix epoch:  number of seconds that have elapsed since January 1, 1970 (midnight UTC/GMT) till 2024-07-20 midnight
select YEAR("2024-07-20"); #yyyy-mm-dd
select YEAR("07-20-2024");
select YEAR("07-2024-20");
select DAYOFWEEK(current_date); #prints day number with sundat as 1 till saturday as 7
select 
	CURRENT_DATE, 
    date_sub(current_date, interval 1 year) as Last_Year_Same_Date,
    CURRENT_DATE - INTERVAL 1 YEAR as Last_Year_Same_Date;

SELECT EXTRACT(YEAR_MONTH FROM '2009-07-02 01:02:03'); # extracts Year_Month from the date or timestamp

select MONTH("2024-07-20"); #yyyy-mm-dd
select MONTH("07-20-2024");
select MONTH("07-2024-20");

SELECT QUARTER("2024-07-20");
select extract(year from current_date);
select YEAR(current_date());

select DAY(current_date); -- extracts date

# SELECT THE FIRST DATE OF THE NEXT QUARTER
SELECT DATE_FORMAT(DATE_ADD(CURRENT_DATE(), INTERVAL 3 - ((MONTH(CURRENT_DATE()) - 1) % 3) MONTH), '%Y-%m-01');
SELECT DATE_FORMAT(DATE_ADD(current_date(), INTERVAL 1 QUARTER), '%Y-%m-01');
SELECT DATE_SUB(DATE_ADD(current_date(), INTERVAL 1 QUARTER), INTERVAL DAY(current_date()) - 1 DAY);


SELECT DATE_FORMAT(STR_TO_DATE(CURRENT_TIMESTAMP, '%Y-%m-%d %H:%i:%s'), '%d-%m-%y') AS formatted_date;
SELECT DATE_FORMAT(DATE_ADD('2025-02-25', INTERVAL 3 - ((MONTH('2025-02-25') - 1) % 3) MONTH), '%Y-%m-01') AS 1ST_NEXT_QRTR;
select DATE_FORMAT(current_date, '%W');  -- prints saturday
select DATE_FORMAT(current_date, '%w'); -- prints 6

SELECT 4%3 ; # REMAINDER 1
SELECT 2%3 ; # REMAINDER = 2

#not widely used and now deprecated from MySQL
SELECT DATE_TRUNC('year', CURRENT_DATE);

SELECT EXTRACT(YEAR FROM CURRENT_DATE) AS current_year;
SELECT EXTRACT(QUARTER FROM CURRENT_DATE) AS current_quarter;
SELECT EXTRACT(MONTH FROM CURRENT_DATE) AS current_month;
SELECT EXTRACT(DAY FROM CURRENT_DATE) AS current_day;
SELECT EXTRACT(WEEK FROM CURRENT_DATE) AS current_day;

SELECT timestamp(DATE) AS Date_Time FROM airpurifier.aqi;
SELECT 
	Date, dayname(date) as Day_Name, dayofweek(date) as Day_of_Week, weekday(date) as Week_Day
FROM airpurifier.aqi
WHERE dayname(date) = 'Monday';

CREATE TABLE events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(255),
    event_date DATE
);

INSERT INTO events (event_name, event_date) VALUES 
('Event A', '2024-01-15'),
('Event B', '2024-02-20'),
('Event C', '2024-05-26'),
('Event D', '2024-12-31');

SELECT * FROM events;
SELECT 
    event_name,
    YEAR(event_date) AS year_part,
    MONTH(event_date) AS month_part,
    DAY(event_date) AS day_part
FROM 
    events;

select 
	YEAR(event_date),
	count(event_name)
from events 
group by YEAR(event_date);



#add / subtract dates
select date_add("2024-10-15", interval 5 year );
select date_add("2024-10-15", interval 1 QUARTER);
select date_add("2024-10-15", interval 5 MONTH );	#'2025-03-15'
select date_add("2024-10-15", interval -5 MONTH);	#'2024-05-15' -- acts as date_sub with interval 5
select date_sub("2024-10-15", interval 7 day);
select DATE_SUB("2024-10-15", INTERVAL DAY("2024-10-15") - 1 DAY) AS first_day_of_month;
select 
	DATE_FORMAT(DATE_ADD("2024-10-15", INTERVAL 1 QUARTER), '%Y-%m-01') 
	as first_day_in_next_quarter; -- adds 3 months and prints first date

qn: Write a SQL query that retrieves the orderID, orderdate, and a calculated column next_quarter_start that represents the start date of 
the next quarter based on the orderdate. The next_quarter_start should be in the format 'YYYY-MM-01'.

SELECT 
    OrderID,
    OrderDate,
    CASE 
        WHEN MONTH(OrderDate) IN (1, 2, 3) THEN 
            CONCAT(YEAR(OrderDate), '-04-01')
        WHEN MONTH(OrderDate) IN (4, 5, 6) THEN 
            CONCAT(YEAR(OrderDate), '-07-01')
        WHEN MONTH(OrderDate) IN (7, 8, 9) THEN 
            CONCAT(YEAR(OrderDate), '-10-01')
        WHEN MONTH(OrderDate) IN (10, 11, 12) THEN 
            CONCAT(YEAR(OrderDate) + 1, '-01-01')
    END AS next_quarter_start
FROM 
    Orders;
    
    
SELECT DATE_ADD(DATE_ADD('2024-05-26', INTERVAL 1 MONTH), INTERVAL 10 DAY) 

TIMESTAMPDIFF is a function in SQL (commonly used in MySQL) that calculates the difference between two date or datetime values, 
returning the result in the unit you specify (such as seconds, minutes, hours, days, etc.).

TIMESTAMPDIFF(unit, datetime_expr1, datetime_expr2)
unit: The unit for the result (like SECOND, MINUTE, HOUR, DAY, MONTH, YEAR, etc.).

SELECT TIMESTAMPDIFF(MONTH, '2021-06-26', '2027-07-12') -- 72 MONTHS GAP
SELECT TIMESTAMPDIFF(YEAR, '2021-06-26', '2027-07-12')		-- 6 YEARS

-- Different precessions of timestampdiff()
SELECT TIMESTAMPDIFF(MONTH, DATE('2023-01-15 10:00:00'), DATE('2023-03-14 18:58:00')) as diff; # 1
SELECT TIMESTAMPDIFF(MONTH, DATE('2023-01-15 10:00:00'), DATE('2023-03-17 20:00:00')) as diff; # 2
SELECT 
	TIMESTAMPDIFF(
		MONTH, DATE_FORMAT('2023-01-15 10:00:00', '%Y-%m-01'), DATE_FORMAT('2023-03-14 18:58:00', '%Y-%m-01')
    ) AS diff; # 2
    
-- Ends just before the boundary → 0
SELECT TIMESTAMPDIFF(MONTH, '2023-01-15 10:00:00', '2023-02-15 09:00:00'); # = 0

-- Exactly at the boundary → 1
SELECT TIMESTAMPDIFF(MONTH, '2023-01-15 10:00:00', '2023-02-15 10:00:00'); # = 1

-- After the boundary → 1
SELECT TIMESTAMPDIFF(MONTH, '2023-01-15 10:00:00', '2023-02-15 11:00:00'); # = 1

-- Solution for consistency
SELECT TIMESTAMPDIFF(MONTH, DATE_FORMAT('2023-01-15 10:00:00', '%Y-%m-01'), DATE_FORMAT('2023-02-15 09:00:00', '%Y-%m-01')); # = 1
-- OR
SELECT TIMESTAMPDIFF(MONTH, DATE('2023-01-15 10:00:00'), DATE('2023-02-15 09:00:00')); # = 1

Qn: You have a table named "customers" with a column "last_purchase_date" (DATE data type). You want to retrieve all customers -
who have not made a purchase in the last 90 days. Which of the following queries would you use?
SOLN:
SELECT * FROM customers WHERE DATEDIFF(CURRENT_DATE, last_purchase_date) > 90;
OR
SELECT * FROM customers WHERE last_purchase_date < DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY);

CREATE TABLE orders2 (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    delivery_date DATE
);
INSERT INTO orders2 (order_date, delivery_date) VALUES 
('2024-05-01', '2024-05-05'),
('2024-05-10', '2024-05-15'),
('2024-05-20', '2024-05-25'),
('2024-06-01', '2024-06-03');

SELECT * FROM ORDERS2

-- MySQL only supports differences in days

select *,datediff(delivery_date, order_date) as delivery_days from orders2
select *, (year(delivery_date) - year(order_date)) as delivery_years from orders2
select *,ABS(datediff(order_date, delivery_date)) as delivery_days from orders2

SELECT order_id, order_date, delivery_date,
    CASE 
        WHEN DATEDIFF(delivery_date, order_date) < 0 THEN "invalid"
        ELSE DATEDIFF(delivery_date, order_date)
    END as adjusted_delivery_days
from orders2

Qn: Write an SQL query to select the order_year from the orderDate of the orders table, where the order_year is a leap year.
Use the following criteria to determine if a year is a leap year:
The year must be divisible by 4.
The year must not be divisible by 100 unless it is also divisible by 400.

select year(orderdate) AS order_year
from Orders
where 
    case
        when year(orderdate) % 4 = 0 AND (year(orderdate) % 100 != 0 or 
        year(orderdate) % 400 = 0) 
        then 1 
        else 0 
    end

---------------------------------
%Y: Year, numeric, four digits
%y: Year, numeric, two digits
%m: Month, numeric (00-12)
%M: Month name (January-December)
%d: Day of the month, numeric (00-31)
%H: Hour (00-23)
%i: Minutes, numeric (00-59)
%s: Seconds, numeric (00-59)
%b: Abbreviated month name (Jan-Dec)
%W: Weekday name (Sunday-Saturday)
%w: Day of the week (0=Sunday, 6=Saturday)
%a: Abbreviated weekday name (Sun-Sat)
-------------------------------------------
SELECT DATE_FORMAT('2024-05-26 14:30:00', '%W, %M %d, %Y %H:%i:%s') AS formatted_datetime;
Sunday, May 26, 2024 14:30:00


SELECT DATE_FORMAT('2024-05-26', '%M, %d, %Y') AS formatted_date;
May, 26, 2024

SELECT DATE_FORMAT('2024-05-26', '%M') AS month_name;


SELECT order_id, order_date, delivery_date,
    DATE_FORMAT(order_date, '%b %d, %Y') AS formatted_order_date,
    DATE_FORMAT(delivery_date, '%b %d, %Y') AS formatted_delivery_date
FROM orders2;

select STR_TO_DATE("May, 26, 2024","%M, %d, %Y")


CREATE TABLE events_string (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_date_string VARCHAR(50)
);
INSERT INTO events_string (event_date_string) VALUES 
('26 May 2024 14:30:00'),
('15 June 2024 10:00:00'),
('04 July 2024 18:45:00');


select * from events_string


SELECT event_id, event_date_string,
    STR_TO_DATE(event_date_string, '%d %M %Y %H:%i:%s') AS converted_date,
    DATE_FORMAT(STR_TO_DATE(event_date_string, '%d %M %Y %H:%i:%s'), '%W, %M %d, %Y %H:%i:%s') AS formatted_date
FROM events_string;

select *
from calendar

Alter table calendar
rename column date to calendar_date;


UPDATE calendar
SET calendar_date = STR_TO_DATE(calendar_date,"%d-%m-%Y")

SET sql_safe_updates = 0;


Alter table calendar
modify calendar_date date

select *
from calendar


select * from sales_2015
where orderdate like "__-__-____"
#yyyy-mm-dd

UPDATE sales2015
SET orderdate = str_to_date(orderdate,"%d-%m-%Y") 
where orderdate like "__-__-____"

dd--mm-yyyy
yyyy-mm-dd

select SUBSTRING_INDEX(orderdate,"/",1)
concat(right(orderdate,4),"-",

 from sales2015
where orderdate like "_/__/____"

#also handle returndate of returns table

UPDATE RETURNS
SET RETURNDATE = STR_TO_DATE(REPLACE(TRIM(RETURNDATE), '/', '-'), '%m-%d-%Y')
select * from returns
order by 1

select * from sales_2015;
update sales_2015
set 
  orderdate = STR_TO_DATE(REPLACE(orderdate, '/', '-'), '%m-%d-%Y'),
  StockDate = STR_TO_DATE(REPLACE(StockDate, '/', '-'), '%m-%d-%Y');

select * from sales_2016;
update sales_2016
set 
  orderdate = STR_TO_DATE(REPLACE(orderdate, '/', '-'), '%m-%d-%Y'),
  StockDate = STR_TO_DATE(REPLACE(StockDate, '/', '-'), '%m-%d-%Y');

select * from sales_2017;
update sales_2017
set 
  orderdate = STR_TO_DATE(REPLACE(orderdate, '/', '-'), '%m-%d-%Y'),
  StockDate = STR_TO_DATE(REPLACE(StockDate, '/', '-'), '%m-%d-%Y');

SELECT *, DATEDIFF(orderdate, stockdate) AS DATE_DIFF FROM sales_2017

select last_day("2025-04-01")
SELECT FIRST_DAY("2025-04-04") #error --> FIRST_DAY FUNCTION DOES NOT EXIST
SELECT DATE_SUB("2024-10-15", INTERVAL DAY("2024-10-15") - 1 DAY) AS first_day_of_month


SELECT * FROM RETURNS

SELECT pc.categoryname, SUM(r.returnquantity) AS total_return_quantity
FROM returns r
JOIN products p ON r.productkey = p.productkey
JOIN product_subcategories ps ON p.productsubcategorykey = ps.productsubcategorykey
JOIN product_categories pc ON ps.productcategorykey = pc.productcategorykey
WHERE YEAR(r.returndate) = 2017
GROUP BY pc.categoryname;


SELECT YEAR(r.returndate) AS year, AVG(r.returnquantity) AS avg_return_quantity_per_customer
FROM returns r
GROUP BY YEAR(r.returndate);



SELECT YEAR(s.orderdate) AS year, t.region, 
ROUND(SUM(s.orderquantity * p.productprice), 2) AS total_sales_revenue
FROM (
    SELECT * FROM sales_2015
    UNION ALL
    SELECT * FROM sales_2016
    UNION ALL
    SELECT * FROM sales_2017
) AS s
JOIN products p ON s.productkey = p.ProductKey
JOIN territories t ON s.territorykey = t.salesterritorykey
GROUP BY YEAR(s.orderdate), t.region
order by total_sales_revenue desc;


SELECT p.productname, 
    AVG(DATEDIFF(s.orderdate, s.stockdate)) AS average_days_to_sell
FROM sales_2017 s
JOIN products p ON s.productkey = p.ProductKey
GROUP BY p.productname
ORDER BY average_days_to_sell DESC;


SELECT 
	YEAR(s.orderdate) AS year,
    MONTH(s.orderdate) AS month,
    pc.categoryname,
    SUM(s.orderquantity) AS total_sales_quantity
FROM sales_2015 s
    JOIN products p ON s.productkey = p.ProductKey
    JOIN product_subcategories ps ON p.productsubcategorykey = ps.productsubcategorykey
    JOIN product_categories pc ON ps.productcategorykey = pc.productcategorykey
GROUP BY YEAR(s.orderdate), MONTH(s.orderdate), pc.categoryname
ORDER BY YEAR(s.orderdate), MONTH(s.orderdate);


SELECT '2024-02-15' AS input_date, LAST_DAY('2024-02-15') AS last_day_of_month
UNION ALL
SELECT '2024-06-10', LAST_DAY('2024-06-10')
UNION ALL
SELECT '2024-11-01', LAST_DAY('2024-11-01');


