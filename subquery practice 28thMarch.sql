1. FIND OUT ALL THE DATA FOR THE EMPLOYEES WITH SALARY GREATER THAN THE AVERAGE SALARY.
SELECT * FROM PRODUCTS              #MAIN QUERY
WHERE PRODUCTPRICE > (SELECT AVG(ProductPrice) #-----SUBQUERY
FROM products)							^
										|
-----  1. SCALAR SUBQUERY ------		|
										|
ALWAYS RETURNS 1 ROW AND 1 COLUMN -------
SELECT * FROM PRODUCTS EJOIN (SELECT AVG(PRODUCTPRICE) AS AVG_COST FROM PRODUCTS) P
ON E.PRODUCTPRICE > P.AVG_COST 

-----  2. MULTIPLE ROW SUBQUERY ------

-- A. SUBQUERY WHICH RETURNS ONLY 1 COLUMN AND MULTIPLE ROWS

#QN- WHICH ARE THE PRODUCTS THAT HAVE NOT BEEN RETURNED
SELECT DISTINCT ProductName FROM PRODUCTS
WHERE ProductKey NOT IN (SELECT PRODUCTKEY FROM RETURNS)

	#USING LEFT JOIN
SELECT P.ProductName FROM PRODUCTS P
LEFT JOIN RETURNS R ON R.ProductKey = P.ProductKey
WHERE R.ProductKey IS NULL

-- B. SUBQUERY WHICH RETURNS MULITPLE COLUMNS AND MULTIPLE ROWS

#QN - FIND THE CUSTOMERS WHO EARN THE HIGHEST ANNUALINCOME IN EACH OCCUPATION
SELECT OCCUPATION, ANNUALINCOME FROM CUSTOMERS
WHERE (OCCUPATION, ANNUALINCOME) 
		IN (SELECT OCCUPATION, MAX(ANNUALINCOME) FROM CUSTOMERS
			GROUP BY 1)

-- ------ 3.  CORRELATED SUBQUERY  ------------
-- A subquery which is related to the outer query. The subquery can not be independently run without the outer query.

/* Qn: Find the customers in each occupation who earn more than the average salary in that occupation. */
select avg(annual_income) , occupation from customers group by 2;

select customerkey, occupation, annual_income from customers c1
where annual_income > (select avg(annual_income) from customers c2
					   where c2.occupation = c1.occupation) 		-- very time consuming due to processing the subquery for multiple no fo times

/*Qn- findout the productkeys not in returns table */
select productkey, productname 
from products p
where not exists (select 1 from returns r where r.productkey = p.productkey)

NOT EXISTS vs NOT IN in SQL
Both NOT EXISTS and NOT IN are used to filter out records based on a subquery, but they behave differently in terms of performance and NULL handling.

1️⃣ NOT EXISTS
Used with a correlated subquery.

Returns TRUE if the subquery does not return any matching rows.

Works efficiently with indexed subqueries.

Ignores NULL values safely.

Example Using NOT EXISTS
Find all products that have NOT been returned:

SELECT P.*
FROM PRODUCTS P
WHERE NOT EXISTS (
    SELECT 1 FROM RETURNS R WHERE R.ProductKey = P.ProductKey
);
✅ Advantages of NOT EXISTS
Efficient for large datasets (especially if the subquery has an index).

Handles NULLs correctly (unlike NOT IN).

2️⃣ NOT IN
Checks whether a value is not present in a list returned by a subquery.

If the subquery contains NULL values, the entire query may return no results.

Performs a full scan of the subquery results (less efficient in large tables).

Example Using NOT IN
Find all products that have NOT been returned:

SELECT P.*
FROM PRODUCTS P
WHERE P.ProductKey NOT IN (SELECT ProductKey FROM RETURNS);

⚠ Potential Problem with NULLs
If the RETURNS table contains NULL values for ProductKey, the query may return no results at all due to NULL handling in SQL.

🔍 Key Differences:
Feature	NOT EXISTS	NOT IN
Execution	Row-by-row check	Full scan of subquery results
NULL Handling	✅ Works correctly (ignores NULLs)	❌ Can cause unexpected results if NULLs exist
Performance on Large Data	✅ More efficient with indexing	❌ Can be slower (full scan)
Best Use Case	When checking for non-existence efficiently	When dealing with small datasets without NULLs
🚀 Which One Should You Use?
If there’s a chance of NULL values in the subquery, use NOT EXISTS to avoid incorrect results.

If both tables are small, NOT IN can work fine.

If dealing with large datasets, NOT EXISTS is generally faster, especially with indexes.

/*----------------Nested Subquery--------
Qn: Find the products whose orders were better than the average orders across of all the products from Sales_2015 */
1. find the total orders for each productkey
2. find the avg orders for all the productkey
3. compare 1 and 2


-- Joining two subqueries USING NESTED SUBQUERY (not an efficient way)
select * 
from (	select productkey, sum(orderquantity) as totalorders			-- ------ subquery 1
			from sales_2015
			group by 1
            order by 2 desc
	) as t1
join
	(	select avg(totalorders) as avg_order									-- ----- subquery 2
		from
			(select productkey, sum(orderquantity) as totalorders from sales_2015 -- ---- subquery 3 under subquery 2
			group by 1
            order by 2 desc) as newtable
	) as t2
on t1.totalorders > t2.avg_order

-- WITH Clause (Efficient way)
WITH t1 as ( select productkey, sum(orderquantity) as totalorders			-- ------ subquery 1 (CREATES PSEUDO TABLE 1)
			from sales_2015
			group by 1 
            order by 2 desc )
SELECT * FROM t1
join
	(	select avg(totalorders) as avg_order									-- ----- subquery 2 (CREATES PSEUDO TABLE 2)
		from
			t1 as newtable
	) as t2
on t1.totalorders > t2.avg_order


WE CAN USE SUBQUERIES IN THE FOLLOWING CLAUSES
1. SELECT (NOT RECOMMENDED)
2. FROM
3. WHERE
4. HAVING

/* USING SELECT CLAUSE (not a recommended method because the subquery runs for every single record the select statement processes, 
so not a good choise for large dataset. 
QN: Fetch all the customer's details and add remarks to ONLY those who earn more than the average pay. */

SELECT ANNUAL_INCOME , 
(	 CASE 
		WHEN ANNUAL_INCOME > (SELECT AVG(ANNUAL_INCOME) FROM CUSTOMERS)  --  avg = 57256.3353
		THEN 'HIGHER THAN AVG'
		ELSE NULL
	 END
) AS Remarks
FROM CUSTOMERS

-- Slight Modification

SELECT ANNUAL_INCOME , 
	 CASE 
		WHEN ANNUAL_INCOME > AVG.Avg_Income THEN 'HIGHER THAN AVG'
		ELSE NULL
	 END AS Remarks
FROM CUSTOMERS
CROSS JOIN (SELECT AVG(ANNUAL_INCOME) AS Avg_Income FROM CUSTOMERS) AS AVG;   -- SUBQUERY OUTSIDE SELECT STATEMENT  avg = 57256.3353

-- --- Having clause -----
/* Qn: Find the products which have been returned less than the avg quantities sold by all the products */
select productkey, sum(returnquantity) totalreturns
from returns
group by productkey
having totalreturns < (select avg(returnquantity) from returns)

-- Subqueries in
-- Insert 
-- Update
-- Delete
/* Insert date to employee history table. Make sure not insert duplicate records. */

