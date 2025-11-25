												
                                                -- First_Value -- -- Last_Value --
                                                
-- write a query to display the most expensive product under each subcategory corresponding to each record.
-- extract only the first productkey in case of tie
-- extract only the last productkey in case of tie

select * from products;

select ProductKey, ProductSubcategoryKey, ProductPrice,
first_value(ProductKey) over (partition by ProductSubcategoryKey) as top_priced_first_productkey,
Last_value(ProductKey) over (partition by ProductSubcategoryKey) as top_priced_last_productkey
from products;			# by default (order by ProductKey desc rows between unbounded preceding and unbounded following


select ProductKey, ProductSubcategoryKey, ProductPrice,
first_value(ProductKey) over (partition by ProductSubcategoryKey order by ProductPrice desc) as top_priced_first_productkey,
Last_value(ProductKey) over (partition by ProductSubcategoryKey order by ProductPrice desc) as top_priced_last_productkey
from products;

-- write a query to display the least expensive product under each subcategory corresponding to each record.
-- extract only the first productkey in case of tie
-- extract only the last productkey in case of tie

select ProductKey, ProductSubcategoryKey, ProductPrice,
first_value(ProductKey) over (partition by ProductSubcategoryKey order by ProductPrice asc) as least_priced_first_productkey,
Last_value(ProductKey) over (partition by ProductSubcategoryKey ) as least_priced_last_productkey
from products;

select ProductKey, ProductSubcategoryKey, ProductPrice,
first_value(ProductKey) over (partition by ProductSubcategoryKey order by ProductPrice asc) as least_priced_first_productkey,
Last_value(ProductKey) over (partition by ProductSubcategoryKey order by ProductPrice asc) as least_priced_last_productkey
from products;

-- write a query to display the most and the least expensive product under each subcategory corresponding to each record.
-- extract only the first productkey in case of tie
-- extract only the last productkey in case of tie

select *,
first_value(ProductKey) over (partition by ProductSubcategoryKey order by ProductPrice desc) as top_priced_first_productkey,
Last_value(ProductKey) over (partition by ProductSubcategoryKey order by ProductPrice desc) as top_priced_last_productkey,
first_value(ProductKey) over (partition by ProductSubcategoryKey order by ProductPrice asc) as least_priced_first_productkey,
Last_value(ProductKey) over (partition by ProductSubcategoryKey order by ProductPrice asc) as least_priced_last_productkey
from products;
# the above query not showing correct values for top_priced_last_productkey


										-- ------------------- Nth_value --------------------
                                        
NTH_VALUE(expression, N) OVER 
(
PARTITION BY column1, column2, ...
ORDER BY column1 [ASC|DESC], column2 [ASC|DESC], ...
[ROWS|RANGE BETWEEN ...]
)
The NTH_VALUE() function in MySQL is a window function that returns the value of an expression
from the N-th row of the window frame. This function is useful when you want to retrieve the N-th
value from a set of ordered rows.

#Extract the first, 3rd and the last productkey of the sales_2017 table for each subcategorykey ordered by ProductPrice in ascending order.

select 
	p.productkey, ProductSubcategoryKey, ProductPrice,
    first_value(p.productkey) over
    (PARTITION BY p.ProductSubcategoryKey ORDER BY p.ProductPrice) AS first_sale_key,
	NTH_VALUE(p.productkey, 3) OVER 
    (PARTITION BY p.ProductSubcategoryKey ORDER BY p.ProductPrice) AS third_sale_key, # default -ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	last_value(p.productkey) over
    (PARTITION BY p.ProductSubcategoryKey ORDER BY p.ProductPrice ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
    AS last_sale_key  
FROM products p
JOIN sales_2017 s7 ON p.ProductKey = s7.productkey
ORDER BY 2;

# Qn:
# PERFORM A CROSS JOIN BETWEEN sales and sales_data tables.
# PRINT sales_id, SaleID AS ID, SaleAmount, and the 5th SaleAmount UNSORTED AND SORTED IN ASCENDING ORDER 
# FROM THE JOINED TABLE WHERE sales_id = 1.
# DIFFERENTIATE BETWEEEN WINDOW_FRAME_EXTENT.

SELECT * FROM sales;					#	8 rows
SELECT * FROM sales_data;				#	15 rows
SELECT * FROM sales, sales_data;		#	15*8 = 120 rows (CROSS JOIN condition)

SELECT
	S.sales_id, S.ID, S.SaleAmount, 
    NTH_VALUE(S.SaleAmount, 5) OVER() AS 5th_SaleAmount_Unsorted ,		# returns 5th row from unsorted sales amount
																		# must be written before any order by SaleAmount happened
	NTH_VALUE(S.SaleAmount, 5) OVER( ORDER BY S.SaleAmount ) AS 5th_SaleAmount_Sorted,	# returns 5th row from sorted sales amount
																			# by deafult UNBOUNDED PRECEDING AND CURRENT ROW condition
    NTH_VALUE(S.SaleAmount, 5) OVER( ORDER BY S.SaleAmount 								 
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 5th_RW_UPUF_SaleAmount,
    
    NTH_VALUE(S.SaleAmount, 5) OVER( ORDER BY S.SaleAmount 
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 5th_RW_UPCR_SaleAmount,
    
    NTH_VALUE(S.SaleAmount, 5) OVER( ORDER BY S.SaleAmount
    RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 5th_RNG_UPUF_SaleAmount,
    
    NTH_VALUE(S.SaleAmount, 5) OVER( ORDER BY S.SaleAmount 								# same result as ROWS BETWEEN UNBOUNDED 
    RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 5th_RNG_UPCR_SaleAmount		# PRECEDING AND CURRENT ROW
FROM	
	(SELECT sales_id, SaleID AS ID, SaleAmount 
     FROM sales, sales_data
	 WHERE sales_id = 1) AS S;



												-- ----- 		FRAME 		------
SELECT
window_function() OVER(
PARTITION BY partition_expression
ORDER BY order_expression
window_frame_extent
) AS window_column_alias
FROM table_name

window_frame_extent – (Optional) Defines the subset of the partition to consider, such as ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.

🧱 What is window_frame_extent?
It is the clause that specifies how much of the partition to include when the window function runs for each row. 
It’s used only with aggregate window functions like SUM(), AVG(), COUNT(), etc. You’ll usually see it as:

ROWS BETWEEN ... AND ...
or
RANGE BETWEEN ... AND ...

🆚 ROWS vs. RANGE
Keyword	Works On...	Behavior
ROWS	Row positions	Based on physical row order
RANGE	Values in ORDER BY	Based on value ranges, not row positions
📌 Common window_frame_extent Options
Here are common ways to define it:

Clause	Meaning
---------------
UNBOUNDED PRECEDING:	Start of the partition
CURRENT ROW:	The row being evaluated

1 PRECEDING:	One row before the current row
1 FOLLOWING:	One row after the current row

🔍 Examples
🔹 Running Total with ROWS:
SELECT
  department,
  employee,
  sales,
  SUM(sales) OVER (
    PARTITION BY department
    ORDER BY employee
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total
FROM sales_table;
Explanation: For each row, the SUM includes all previous rows in the same partition up to the current row.

🔹 Moving Average (3-row window):
SELECT
  date,
  sales,
  AVG(sales) OVER (
    ORDER BY date
    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
  ) AS moving_avg
FROM sales_data;
Explanation: For each row, average the sales of the previous day, current day, and next day.

🧠 Quick Recap: RANGE vs ROWS
Clause	Based on
ROWS	Row position (physical row)
RANGE	Values in the ORDER BY column
With RANGE, you’re telling SQL:

									Cumulative_SUM - (ORDER BY 					Cumulative_SUM - (ORDER BY 
SUBCAT	ORDERDATE	PRODUCTPRICE	PRODUCTPRICE ROWS ...... CURRENT ROW)		PRODUCTPRICE RANGE .......CURRENT ROW)
1		1-1-2020	10						10														30  [10+10+10]
1		2			10						20														30  [10+10+10]
1		3			10						30														30  [10+10+10]
1		4			40						70														70  [10+10+10+40]
2		1-1-2020	20						20														40  [20+20]
2		2			10						30														50  [20+20+10]
2		3			50						80														100 [20+20+10+50]
2		4			20						100														40  [20+20]

select * from products;

select s.ProductKey, ProductSubcategoryKey, OrderDate, ProductPrice,
sum(ProductPrice) over( partition by ProductSubcategoryKey order by OrderDate
rows between unbounded preceding and current row) as rw_cumulative_sum,
sum(ProductPrice) over( partition by ProductSubcategoryKey order by OrderDate
range between unbounded preceding and current row) as rng_cumulative_sum
from products p
inner join sales_2016 s on s.productkey = p.productkey
where ProductPrice = 2071.4196
order by 2;

select s.ProductKey, ProductSubcategoryKey, OrderDate, ProductPrice,
sum(ProductPrice) over( partition by ProductSubcategoryKey order by ProductPrice desc
rows between unbounded preceding and current row) as rw_cumulative_sum,
sum(ProductPrice) over( partition by ProductSubcategoryKey order by ProductPrice desc
range between unbounded preceding and current row) as rng_cumulative_sum
from products p
inner join sales_2016 s on s.productkey = p.productkey
#where ProductPrice = 2071.4196
order by 2,3;		#Doubt -- why result not proper for rw_cumulative_sum

“Include all rows with values in a certain range (not just those near this row in the list).”

🔍 Example with RANGE

id	value
1	10
2	10
3	20
4	30

SELECT
  id,
  value,
  SUM(value) OVER (
    ORDER BY value
    RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total
FROM numbers;

Row	value	What it includes with RANGE ... AND CURRENT ROW	SUM(value)
1	10		Rows with value ≤ 10 → [10, 10]	20
2	10		Same as above	20
3	20		Rows with value ≤ 20 → [10, 10, 20]	40
4	30		Rows with value ≤ 30 → [10, 10, 20, 30]	70
💡 Even though rows 1 and 2 are “before” row 3, it’s not their position that matters—it’s the value.

🎯 Visual Summary
pgsql

RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW (on value column):

        | Value | Included in running total |
Row 1   |  10   | 10, 10                    |
Row 2   |  10   | 10, 10                    |
Row 3   |  20   | 10, 10, 20                |
Row 4   |  30   | 10, 10, 20, 30            |
Now compare this to ROWS:


ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
That would calculate the sum strictly based on how far up the table the current row is—not value.

✅ When to Use RANGE
Use RANGE when you want to include all rows with values in a certain range.
Use ROWS when you want to include a fixed number of rows around the current one.


Let us do a side-by-side comparison of ROWS vs RANGE with a simple dataset to highlight how they behave differently. 👇

🎯 Sample Table: sales_data
row_num	value
1	10
2	10
3	20
4	30

🆚 Query 1: SUM(value) with ROWS
SELECT
  row_num,
  value,
  SUM(value) OVER (
    ORDER BY value
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS sum_with_rows
FROM sales_data;
➡️ ROWS uses the physical position of rows based on ordering.

🆚 Query 2: SUM(value) with RANGE
SELECT
  row_num,
  value,
  SUM(value) OVER (
    ORDER BY value
    RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS sum_with_range
FROM sales_data;
➡️ RANGE includes all rows with values ≤ current value.

🧮 Output Comparison Table
row_num		value	sum_with_rows	sum_with_range
1			10			10				20
2			10			20				20
3			20			40				40
4			30			70				70

select ProductKey, ProductSubcategoryKey, ProductCost,
round(sum(ProductCost) over(partition by ProductSubcategoryKey order by ProductCost desc 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2)
as Rowlevel_Rolling_Sum,
round(sum(ProductCost) over(partition by ProductSubcategoryKey order by ProductCost desc 
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2)
as Rangelevel_Rolling_sum
from products;




