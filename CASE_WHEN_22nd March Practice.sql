#DROP TABLE customers;
select * from customers;
SELECT DISTINCT ANNUALINCOME, LENGTH(ANNUALINCOME) FROM CUSTOMERS;

Alter table customers
add Annual_Income INT after AnnualIncome;

SELECT DISTINCT ANNUALINCOME, LENGTH(ANNUALINCOME), ANNUAL_INCOME, LENGTH(ANNUAL_INCOME) FROM CUSTOMERS;

UPDATE customers 
SET Annual_Income =
	CASE 
		WHEN AnnualIncome REGEXP '^[0-9$, ]+$' 
		THEN CAST(REPLACE(REPLACE(TRIM(AnnualIncome), '$', ''), ',', '') AS UNSIGNED)
	ELSE NULL
    END
    
/* EXPLANATION
---------------
1. In MySQL, UNSIGNED is a data type modifier that prevents a numeric column or value from storing negative numbers. 
It’s commonly used with integer types (TINYINT, INT, BIGINT, etc.).

2. REGEXP — Short for "Regular Expression," this checks if AnnualIncome matches the pattern.
'^[0-9$, ]+$' — This is the regular expression pattern. Let’s dive into it:
where
🎯 Detailed breakdown:
^	Start of the string — Ensures the match begins from the first character.
[0-9$, ]	Character class — Allows digits (0-9), dollar signs ($), commas (,), and now spaces ( ).
+	One or more of the allowed characters (must have at least one valid character).
$	End of the string — Ensures the match ends exactly at the last character (no extra characters allowed).

✅ What this matches:
✔️ "$9,000" — Classic currency format
✔️ "1,234" — Number with commas
✔️ "$ 12,345" — Dollar sign with a space after it
✔️ " 123 " — Numbers padded with spaces
✔️ "$ 1, 234 " — Spaces scattered in between (though this may not be ideal!)

🚨 What this rejects:
❌ "abc123" — Contains letters
❌ "9.99" — Contains a period (not allowed)
❌ "1,23,456" — Comma placement still isn't validated
❌ "$9,000 USD" — Extra text after the numbers breaks the match
❌ "-$500" — Negative signs aren’t covered */

CASE WHEN
---------
1.PRINT THE OUTPUT AS
HIGH INCOME - SALARY > 70K
MIDDLE INCOME - SALARY 50 K - 70K
LOW INCOME - OTHERWISE
IF NULL - UNKNOWN

SELECT 
	ANNUAL_INCOME,
    CASE 
		WHEN ANNUAL_INCOME > 70000 THEN 'HIGH INCOME'
        WHEN ANNUAL_INCOME BETWEEN 50000 AND 70000 THEN 'MIDDLE INCOME'
        WHEN ANNUAL_INCOME < 50000 THEN 'LOW INCOME'
        ELSE 'UNKNOWN'
		END 
        AS Income_Status
FROM CUSTOMERS;

DESC CUSTOMERS;

2.UPDATE CUSTOMERS TABLE WITH A NEW COLUMN SHOWING Income_Status AFTER THE COLUMN AnnualIncome WITH THE FOLLOWING CONSTRAINTS 
	INCOME < 30K -50K ----> LOW
    30K - 50K - MID
    50K - 70K - HIGH
    > 70K - VERY HIGH
    NULL - UNKNOWN
THEN REMOVE THE NEW COLUMN TO ENSURE DATA INTEGRITY.

ALTER TABLE CUSTOMERS
ADD Income_Status VARCHAR(50) AFTER ANNUAL_INCOME;

UPDATE CUSTOMERS
SET Income_Status = 
	CASE 
		WHEN ANNUAL_INCOME > 70000 THEN 'VERY HIGH INCOME'
        WHEN ANNUAL_INCOME BETWEEN 50000.01 AND 70000 THEN 'HIGH INCOME'
        WHEN ANNUAL_INCOME BETWEEN 30000 AND 50000 THEN 'MID INCOME'
        WHEN ANNUAL_INCOME < 30000 THEN 'LOW INCOME'
        ELSE 'UNKNOWN'
END;
select * from customers;	
#REMEMBER THE INCOME SHOWS TO BE LOW INCOME FOR ALL NON NULL VALUES BECAUSE THE AnnualIncome IS STRING DATA TYPE 
#SO CONVERT IT INTO INTEGER DATATYPE .

ALTER TABLE CUSTOMERS
DROP COLUMN Income_Status;

3.Categorise the annual income into known and unknown buckets
#All the values except null are known

select ANNUAL_INCOME,
	case when ANNUAL_INCOME is not null then 'known'
    else 'unknown'
    end as income_status
from customers
    
4. #Categorize the occupation into high or low based on average income
if average income > 50K --> high
if average income  <=50K --> low

select 
	Occupation, 
    avg(ANNUAL_INCOME) as MeanIncome,
    case when avg(ANNUAL_INCOME) > 50000 then 'High'
    else 'Low'
    end as IncomeLevel
from customers
group by Occupation;

5./*
Categorize the region based on average product cost; if > 200 then high else low
display region, average product cost, category ordered by avg product cost in descending order */

# HINT FOR JOIN-
   territories(region, SalesTerritoryKey)
-> returns(TerritoryKey, ProductKey) or sales(TerritoryKey, ProductKey)  
-> products(ProductKey, productprice, ProductSubcategoryKey) 
-> product_subcategories(ProductSubcategoryKey) 
-> product_categories(ProductCategoryKey)

#NOTE - since the qn has not explicitly mentioned which table to take for the common TerritoryKey so for our convenience we 
# are taking returns table to join with Territories table instead of sales table

select 
	t.Region, 
    t.SalesTerritoryKey,
	pc.CategoryName,
	avg(p.ProductPrice) as Avg_Cost,
    case 
		when avg(p.ProductPrice) > 200 then 'High'
    else 'Low'
    End as Income_Status
from territories t
left join returns r
	on t.SalesTerritoryKey = r.TerritoryKey
join products p
	on r.ProductKey = p.ProductKey
join product_subcategories ps
	on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
join product_categories pc
	on ps.ProductCategoryKey = pc.ProductCategoryKey
group by 1,2,3
order by Avg_Cost desc

6. 
#Categorize the region, territorykey based on 2017's total order quantity... 
Display 3 columns to check the number of 
-high performance sales( total order quantity>2)
-medium performance sales( total order quantity between 1 and 2)
-low performance sales( total order quantity < 1)

select distinct OrderQuantity from sales_2017;
select 
	Region, 
	TerritoryKey,
    sum(OrderQuantity) as total_Qnt_ordered,
    sum(case 
		 when OrderQuantity > 2 then OrderQuantity
         else 0 end)
	 as high_performance_sales,
    sum(case
		 when OrderQuantity between 1 and 2 then OrderQuantity
         else 0 end)
	as medium_performance_sales,
	sum(case
		 when OrderQuantity < 1 then OrderQuantity
         else 0 end)
	as low_performance_sales
from sales_2017
join territories
	on TerritoryKey = SalesTerritoryKey
group by 1,2

7.
/* Which products have the highest return quantities across different categories and subcategories,
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
descending order." */
ReturnQuantity - ProductKey - ProductSubcategoryKey - ProductCategoryKey

select ProductName, CategoryName, SubcategoryName, sum(ReturnQuantity) as Total_Returns,
	case when sum(ReturnQuantity) > 50 then 'HIGH RETURNS'
		 when sum(ReturnQuantity) between 26 and 50 then 'MODERATE RETURNS'
         when sum(ReturnQuantity) <= 25 then 'LOW RETURNS'
         else 'NULL'
	end 
    as Return_Performance
from returns r
join products p
	on r.ProductKey = p.ProductKey
join product_subcategories ps
	on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
join product_categories pc
	on ps.ProductCategoryKey = pc.ProductCategoryKey
group by 1,2,3
having total_returns > 10
order by 3 desc

    
    
CHAT_GPT_ANSWER---CHEATING 😊
-------------------------------
WITH FilteredReturns AS (
    SELECT 
        r.ProductKey,
        r.TerritoryKey,
        ps.ProductSubcategoryKey,
        pc.CategoryName,
        SUM(r.ReturnQuantity) AS TotalReturns
    FROM returns r
    JOIN products p ON r.ProductKey = p.ProductKey
    JOIN product_subcategories ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
    JOIN product_categories pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
    WHERE 
        (
            (pc.CategoryName = 'Bikes' AND r.ReturnQuantity > 20) OR
            (pc.CategoryName = 'Components' AND r.ReturnQuantity > 5) OR
            (pc.CategoryName NOT IN ('Bikes', 'Components'))
        )
        AND (
            (r.TerritoryKey IN (SELECT TerritoryKey FROM territories WHERE Region = 'North America') AND r.ReturnQuantity > 20) OR
            (r.TerritoryKey IN (SELECT TerritoryKey FROM territories WHERE Region = 'Europe') AND r.ReturnQuantity > 15) OR
            (r.TerritoryKey NOT IN (SELECT TerritoryKey FROM territories WHERE Region IN ('North America', 'Europe')))
        )
    GROUP BY r.ProductKey, r.TerritoryKey, ps.ProductSubcategoryKey, pc.CategoryName
)

SELECT 
    p.ProductName,
    ps.SubcategoryName,
    fr.CategoryName,
    fr.TotalReturns,
    CASE 
        WHEN fr.TotalReturns > 50 THEN 'High Returns'
        WHEN fr.TotalReturns > 25 THEN 'Moderate Returns'
        ELSE 'Low Returns'
    END AS ReturnLevel
FROM FilteredReturns fr
JOIN products p ON fr.ProductKey = p.ProductKey
JOIN product_subcategories ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE fr.TotalReturns > 10
ORDER BY fr.TotalReturns DESC;

select distinct OrderQuantity from sales_2017
select distinct ReturnQuantity from returns

SELECT p.ProductName, pc.CategoryName, psc.SubcategoryName,
SUM(r.ReturnQuantity) AS TotalReturns,
CASE
WHEN SUM(r.ReturnQuantity) > 50 THEN 'High Returns'
WHEN SUM(r.ReturnQuantity) > 25 THEN 'Moderate
Returns'
ELSE 'Low Returns'
END AS ReturnLevel
FROM Products p
JOIN Product_Subcategories psc ON p.ProductSubcategoryKey =
psc.ProductSubcategoryKey
JOIN Product_Categories pc ON psc.ProductCategoryKey =
pc.ProductCategoryKey
LEFT JOIN Returns r ON p.ProductKey = r.ProductKey
AND (CASE
WHEN pc.CategoryName = 'Bikes' THEN r.ReturnQuantity >
20
WHEN pc.CategoryName = 'Components' THEN
r.ReturnQuantity > 5
ELSE TRUE
END)
JOIN Territories t ON r.TerritoryKey = t.SalesTerritoryKey
AND (CASE
WHEN t.Region = 'North America' THEN r.ReturnQuantity >
20
WHEN t.Region = 'Europe' THEN r.ReturnQuantity > 15
ELSE TRUE
END)
GROUP BY p.ProductName, pc.CategoryName, psc.SubcategoryName
HAVING SUM(r.ReturnQuantity) > 10
ORDER BY TotalReturns DESC;

Coding Ninjas Answer:
----------------------

select p.productname , pc.categoryname, ps.subcategoryname,
SUM(IFNULL(r.returnquantity,0)) as total_return_quantity,
CASE WHEN SUM(IFNULL(r.returnquantity,0)) > 50 THEN "High Returns"
WHEN SUM(IFNULL(r.returnquantity,0)) between 26 and 50 THEN "Moderate Returns"
WHEN SUM(IFNULL(r.returnquantity,0)) <= 25 THEN "Low Returns"
END as returnlevel
from products p 
JOIN product_subcategories ps
on p.ProductSubcategoryKey =  ps.ProductSubcategoryKey
JOIN product_categories pc 
on ps.ProductCategoryKey = pc.ProductCategoryKey
LEFT JOIN
returns r 
on r.productkey = p.productkey
AND (CASE WHEN pc.categoryname = "bikes" then r.returnquantity > 20
when pc.categoryname = "Components" then r.returnquantity > 5
ELSE TRUE
END)
INNER JOIN territories t 
on t.SalesTerritoryKey = r.TerritoryKey
AND (CASE WHEN t.continent = 'North America' then r.returnquantity > 20
          WHEN t.continent = 'Europe' then r.returnquantity > 15
          ELSE TRUE
          END)
GROUP BY 1,2,3
HAVING SUM(IFNULL(r.returnquantity,0)) > 10
ORDER BY 4 desc









