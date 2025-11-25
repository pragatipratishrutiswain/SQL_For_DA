SCORE
-----
45
50
64
70
75
80
92
100

LAG(SCORE,2) OVER( ORDER BY SCORE ROWS BETWEEN 2 PRECEDING AND 1 FOLLOWING)

select 5tile_range, count(*) from
	(select ProductKey, ProductSubcategoryKey, ProductPrice,
	ntile(5) over(order by ProductPrice) as 5tile_range
	from products) s
group by 5tile_range

1. Divide the products based on product prices into 5 almost equal groups. 
Find the product name at top in each group based on ascending order of productname

select distinct p.tile_range, 
	case when p.tile_range = 1 
		then first_value(p.ProductName) over(partition by p.tile_range order by p.ProductPrice)
    when p.tile_range = 2 
		then first_value(p.ProductName) over(partition by p.tile_range order by p.ProductPrice)
    when p.tile_range = 3 
		then first_value(p.ProductName) over(partition by p.tile_range order by p.ProductPrice)
    when p.tile_range = 4 
		then first_value(p.ProductName) over(partition by p.tile_range order by p.ProductPrice)
    else 
		first_value(p.ProductName) over(partition by p.tile_range order by p.ProductPrice)
    end as firstname
from
	(select 
		ProductKey, ProductName, ProductPrice,
		ntile(5) over(order by ProductPrice) as tile_range
	 from products) p

2. return product prices without outlier prices

WITH tiles AS 
(
	select 
		ProductKey, ProductName, ProductPrice,
		ntile(4) over(order by ProductPrice) as tile_range
	from products
),
quartiles as
(
	select *,
		max(case when tile_range = 1 then ProductPrice end) over() as Q1,
        max(case when tile_range = 3 then ProductPrice end) over() as Q3
	from tiles 
)
select * from quartiles
where ProductPrice between Q1 and Q3;

3. mention the first name and last name of each person who was the first to purchase each model from the Sales_2015 table.

select * from products;

