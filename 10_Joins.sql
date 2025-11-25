select * from products;
select * from product_subcategories;
select * from product_categories;  

#Find out the average selling price of each subcategory name in descending order of avg selling price

products --> subcategorykey, productprice  ---> LEFT
product_sub ---> subcategorykey, subcategoryname ---> RIGHT

select count(distinct productsubcategorykey)
from products; #37

select count(distinct ProductSubcategoryKey)
from product_subcategories; #37

INNER JOIN
select ps.subcategoryname, avg(p.productprice) as mean_price
from products p
inner join
product_subcategories ps
ON p.productsubcategorykey = ps.productsubcategorykey
group by 1 
order by 2 desc

LEFT JOIN
select ps.subcategoryname, avg(p.productprice) as mean_price
from products p
left join
product_subcategories ps
ON p.productsubcategorykey = ps.productsubcategorykey
group by 1 
order by 2 desc

RIGHT JOIN
select ps.subcategoryname, avg(p.productprice) as mean_price
from products p
right join
product_subcategories ps
ON p.productsubcategorykey = ps.productsubcategorykey
group by 1 
order by 2 desc

FULL OUTER ----> ERROR ----> NOT operated in MySQL

select ps.subcategoryname, avg(p.productprice) as mean_price
from products p
full outer join
product_subcategories ps
ON p.productsubcategorykey = ps.productsubcategorykey
group by 1 
order by 2 desc

inner ---> 37 values
left  ----> 37 values
right ---> 37 values
outer ----> 37 values

SELECT COUNT(DISTINCT productsubcategorykey)
from products; #37

SELECT COUNT(DISTINCT productsubcategorykey)
from product_subcategories; #37