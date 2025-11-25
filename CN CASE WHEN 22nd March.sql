#CASE WHEN ----> IF 
#> 70K ---> HIGH INCOME,
50K - 70K --> MID INCOME
<50K--> LOW INCOME

SELECT annualincome,
CASE 
WHEN annualincome > 70000 THEN "HIGH INCOME"
WHEN annualincome >= 50000 AND annualincome<=70000 THEN "MIDDLE INCOME"
ELSE "LOW INCOME" 
END AS income_group
from customers




SELECT annualincome,
CASE 
WHEN annualincome > 70000 THEN "HIGH INCOME"
WHEN annualincome >= 50000 AND annualincome<=70000 THEN "MIDDLE INCOME"
WHEN annualincome < 50000 THEN "LOW INCOME" 
ELSE "Unknown"
END AS income_group
from customers


#Categorize the annual income into known and unknown buckets
#All values except null are known

select annualincome, 
CASE WHEN annualincome is null then "unknown" 
ELSE "known" END as income_group
from customers


Add a new column called incomegroup into customers table
based upon the below conditions
income<30K --> low
30K -50K - MID
50K- 70K - HIGH
>70K - VERY HIGH
NULL - UNKNOWN

ALTER TABLE customers
ADD COLUMN incomegroup varchar(10)

UPDATE customers
SET incomegroup = CASE WHEN annualincome < 30000 then "low"
when annualincome between 30000 and 50000 then "mid"
when annualincome between 50001 and 70000 then "high"
when annualincome > 70000 then "very high"
when annualincome is null then "unknown"
END

select * from customers



#Categorize the occupation into high or low based on average income
if average income > 50K --> high
if average income  <=50K --> low


select occupation, avg(annualincome) as mean_income,
CASE WHEN avg(annualincome) > 50000 then "high"
ELSE "low"
END as bucket
from customers
GROUP BY 1


#Categorize the region based on average product cost; if > 200 then high else low
#display region, average product cost, category ordered by avg product cost in descending order
territories - tkey, region
returns -- tkey, pkey
product - productcost, pkey, subkey
productsubcategories - subkey, categorykey
productcategories --> categorykey, categoryname

returns                        products
tkey pkey                       cost, pkey
a,  1                            10, 1
b,  2                            25,  2
								30,   3
							
select t.region, avg(p.productcost) as mean_cost, pc.categoryname,
CASE WHEN avg(p.productcost) > 200 then "high"
else "low"
END as bucketed_region
from territories t
left join returns r 
on t.salesterritorykey = r.territorykey
inner join
products p 
on p.productkey = r.productkey
inner join product_subcategories ps
on p.productSubcategoryKey = ps.ProductSubcategoryKey
inner join product_categories pc
on ps.ProductCategoryKey = pc.ProductCategoryKey
GROUP BY 1,3
ORDER  BY 2 DESC

#Categorize the territorykey based on 2017's total order quantity... 
Display 3 columns to check for 
-high performance sales( total order quantity>2)
-medium performance sales( total order quantity between 1 and 2)
-low performance sales( total order quantity < 1)



SELECT territorykey, sum(orderquantity) as total_qty,
CASE WHEN  sum(orderquantity) > 2 THEN "YES"
ELSE "NO"
END AS high_performance_sales,
CASE WHEN  sum(orderquantity) BETWEEN 1 AND 2 THEN "YES"
ELSE "NO"
END AS medium_performance_sales,
CASE WHEN  sum(orderquantity) < 1 THEN "YES"
ELSE "NO"
END AS low_performance_sales
from sales_2017
GROUP BY 1

5     5    a          0       0
3     3     a        0        0
0     0      a       0       0     
1     0     b        1       0
3     3      b        0     0
     high  med  low
a     8    0     0
b     3    1     0




---

SELECT territorykey, sum(orderquantity) as total_qty,
SUM(CASE WHEN orderquantity > 2 THEN orderquantity
ELSE 0 
END) AS high_performance_sales,
SUM(CASE WHEN orderquantity BETWEEN 1 AND 2 THEN orderquantity
ELSE 0
END) AS medium_performance_sales,
SUM(CASE WHEN  orderquantity < 1 THEN orderquantity 
ELSE 0
END) AS low_performance_sales
from sales_2017
GROUP BY 1






select * from sales_2017


high_performace_sales ---> sum of those orderquanity value which are > 2











"Which products have the highest return quantities across different categories and subcategories,
 and how are these products classified into return levels based on their total returns? The return levels are defined as follows:
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

Additionally, only products with total returns exceeding 10 are displayed, and the results are ordered by total returns in descending 
order."


