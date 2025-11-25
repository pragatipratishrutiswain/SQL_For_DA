NTILE():
The NTILE() window function in SQL is used to divide the result set into a specified number
of groups, or "tiles," and assigns a bucket number to each row based on the specified number
of tiles. This function is commonly used to create equal-sized buckets or percentile groups
from a dataset.

Uses of NTILE functions:
● Data Distribution: NTILE can help analyze how data is distributed across different
segments.
● Percentiles and Quartiles: By specifying 100 groups for percentiles or 4 groups for
quartiles, you can determine which percentile or quartile each row falls into.

Syntax:
NTILE(number_of_buckets) OVER (ORDER BY column_name)

NOTE:
● number_of_buckets: The number of groups or "tiles" into which to divide the result set.
● ORDER BY: Specifies the column or expression by which to order the rows before dividing
them into buckets.

# Distribute the product price from the products table into 4 even tiles. 
# Print ProductKey, ProductName, ProductPrice, Quartile range, Q0, Q1, Q2, Q3, Q4, IQR, Upper bound and the Lower bounds as well,
# where Q1 - 1.5*IQR = Lower Bound & Q3 + 1.5*IQR = Upper Bound.
# Print all the information for the products whose product price falls only between the upper and the lower bounds 
# in order to avoid outliers.
 
With Quartile as
	(SELECT 
		ProductKey, ProductName, ProductPrice,
		NTILE(4) OVER (ORDER BY ProductPrice) AS price_quartile_range
	FROM Products),
Q1Q3 AS
	(SELECT *,
		Min(CASE WHEN price_quartile_range = 1 THEN ProductPrice END) OVER() AS Q0_Min_Price,
		MAX(CASE WHEN price_quartile_range = 1 THEN ProductPrice END) OVER() AS Q1,
        MAX(CASE WHEN price_quartile_range = 2 THEN ProductPrice END) OVER() AS Q2_Or_Median,
		MAX(CASE WHEN price_quartile_range = 3 THEN ProductPrice END) OVER() AS Q3,
        MAX(CASE WHEN price_quartile_range = 4 THEN ProductPrice END) OVER() AS Q4_Max_Price
	FROM Quartile),
FIND_IQR AS
	(SELECT *, Q3 - Q1 AS IQR FROM Q1Q3),
BOUNDS AS
	(SELECT *, 
		Q3 + 1.5 * IQR AS Upper_Bound,
        Q1 - 1.5 * IQR AS Lower_Bound
    FROM FIND_IQR)
    
SELECT * FROM BOUNDS
WHERE ProductPrice BETWEEN Lower_Bound AND Upper_Bound;
    

