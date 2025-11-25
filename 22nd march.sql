Categorize the occupation into high or low based on average income
if average income > 50K --> high
if average income  <=50K --> low
*/
SELECT occupation, 
       AVG(annualincome) AS avg_income,
       CASE 
           WHEN 2 > 50000 THEN 'HIGH'
           ELSE 'LOW'
       END AS income_group
FROM customers
GROUP BY occupation;
 /*
Categorize the region based on average product cost; if > 200 then high else low
display region, average product cost, category ordered by avg product cost in descending order */
select * from territories
select 
	region, 
    avg(ProductPrice) as Avg_Cost,
    case when  avg(ProductPrice) > 200 then "High"
    else "Low"
    end as Category
from Products
join territories
on 

    
    
#Categorize the territorykey based on 2017's total order quantity... 
Display 3 columns to check for 
-high performance sales( total order quantity>2)
-medium performance sales( total order quantity between 1 and 2)
-low performance sales( total order quantity < 1)

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    age INT,
    salary DECIMAL(10, 2),
    -- Ensures age is between 18 and 65
    CONSTRAINT chk_age CHECK (age BETWEEN 18 AND 65),
    -- Ensures salary is positive
    CONSTRAINT chk_salary CHECK (salary > 0)
);

CREATE TABLE PerformanceCategory(
	(select 
		TerritoryKey, 
        SUM(ORDERQUANTITY) as Total_Orders
	from sales_2017
    group by TerritoryKey)-- ,
-- 	CONSTRAINT HIGH_PERFORMANCE_SALE CHECK  (Total_Orders > 2),
--     CONSTRAINT MEDIUM_PERFORMANCE_SALE CHECK (Total_Orders IN (1, 2)),
--     CONSTRAINT LOW_PERFORMANCE_SALE CHECK (Total_Orders < 1)
    )
select * from PerformanceCategory

drop table PerformanceCategory

Which products have the highest return quantities across different categories and subcategories,
and how are these products classified into return levels based on their total returns? 
The return levels are defined as follows:
-'High Returns' for products with more than 50 total returns,
-'Moderate Returns' for products with more than 25 but up to 50 total returns,
-'Low Returns' for products with 25 or fewer total returns.

The following conditions are applied to filter the returns:
-For the 'Bikes' category, only returns greater than 20 are considered.
-For the 'Components' category, only returns greater than 5 are considered.
-For all other categories, all return quantities are included.
-For returns in 'North America,' only returns greater than 20 are considered.
-For returns in 'Europe,' only returns greater than 15 are considered.
-Returns in other regions are included without additional conditions.

Additionally, only products with total returns exceeding 10 are displayed, and the results are ordered by total returns in 
descending order."
