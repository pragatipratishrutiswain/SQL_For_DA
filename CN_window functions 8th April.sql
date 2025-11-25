#1
-- for each product color return the maximum product cost using window functions
select distinct productcolor, MAX(productcost) over(partition by productcolor) as max_pc
from products;


#2 
-- for each productkey, calcuate the product cost ratio which 
-- is its product cost divided by the average product cost of its subcategory

with base_metrics as 
(select productkey, productcost,AVG(productcost) over(partition by ProductSubcategoryKey) as mean_pc_sub
from products)

select productkey, productcost/mean_pc_sub as pc_ratio
from base_metrics


#3 display a column called category which categorizes the product cost into 3 buckets (do this for every row):
-- if product cost is the maximum product cost of that subcategory then "highest within subcategory"
-- if product cost is the minimum product cost of that subcategory then "least within subcategory"
-- otherwise  "middle within subcategory"

select productkey,productcost,
case when productcost = MAX(productcost) over(partition by ProductSubcategoryKey)
then "highest within subcategory"
when  productcost = MIN(productcost) over(partition by ProductSubcategoryKey)
then "least within subcategory"
else "middle within subcategory" end as category
from products

#4
-- display a category column based on product cost within its subcategory, 
-- if there are multiple products with highest product cost, then display all of them as "top"
-- display all products falling in 2nd or 3rd position based on product cost values, as "middle"
-- otherwise "bottom"

with dense_ranked_data as
(select productkey, productcost, 
dense_rank() over(partition by ProductSubcategoryKey order by productcost desc) as drnk
from products)

select  productkey, productcost, case when drnk = 1 then "top" 
when drnk <=3 then "middle"
else "bottom" end as category
from dense_ranked_data





100. - 5
75. - 7
20 - 8
10 - 10



#5
-- display the cummulative sum of product cost within each model name for every row in products table.
-- The cummulative sum of product cost should be computed in order of least to highest product price within 
-- the model name

select * from products



pc.  cummulative_sum.  pp
5.      17     m1.     100
3.       20      m1.    150
2.      2    m1.     20
10.     12   m1.      30
 7     17     m2.   40
10.    10       m2.    20

select productkey, productcost,productprice,productcolor,
sum(productcost) over(partition by productcolor order by productprice) as cummulative_sum
from products







select * from products



-- agg window functions, ranking window functions -- done
-- lead/lag, ntile, first_value, last_value, nth_value


