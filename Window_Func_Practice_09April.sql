select * from customers;

select Occupation, max(annual_income) as max_income
from customers
group by Occupation
order by 2;

select *, max(annual_income) over() as max_income # over() doesn't allow max() to act as an aggregate, 
from customers;									  # rather as a window() or non-aggregated column for the entire table

select *, max(annual_income) over(partition by occupation) as max_income # partition by creates a window for each distinct occupation
from customers;

							-- row_number, rank, dense_rank functions --

-- differentiate between row_number, rank, and dense_rank based on customer's occupation and their 3rd highest annual income

with cte as (
select CustomerKey, Annual_Income, Occupation,
	row_number() over(partition by Occupation order by Annual_Income desc) as rn,
    rank() over(partition by Occupation	order by Annual_Income desc) as rk,
    dense_rank() over(partition by Occupation order by Annual_Income desc) as dr
from customers)

select * from cte
where dr < 4;		# to fetch the 3rd highest annual income

-- rank all the customers of each occupation with unique values
select customerkey, occupation, row_number() over(partition by occupation) as rn
from customers;	# row number is assigned to each customer based on occupaton and order is by deafult asc given first to the upper row 

-- fetch the first 2 customers from each occupation to join the survey
with cte as
(select customerkey, occupation, row_number() over(partition by occupation order by CustomerKey) as rn
from customers	)	# order by indicated the minimum customerkey should get the least row number
select * from cte
where rn < 3;

-- fetch the top 3 customers in each occupation with max annual income, take customerkey in asc as a tie breaker.
select * from 
(select customerkey, occupation, Annual_Income, rank() over(partition by occupation order by annual_income desc, customerkey asc) as rk
from customers) as alias
where alias.rk <= 3;

-- fetch the top 3 Annual_Income in each occupation 
select * from
	(select distinct occupation, Annual_Income,
	 dense_rank() over(partition by occupation order by annual_income desc) as dnsrk from customers) as t
where t.dnsrk < 4;

								-- lead and lag functions --

-- fetch the query to dispaly if the annual income of a customer is higher, lower or equal to that of the previous customer.

select customerkey, occupation, annual_income,
	lag(annual_income) over(partition by occupation order by customerkey) as prev_customer_income,
    (case when Annual_Income > lag(annual_income) over(partition by occupation order by customerkey) then 'Higher than prev'
     when Annual_Income < lag(annual_income) over(partition by occupation order by customerkey) then 'Lower than prev'
     when Annual_Income = lag(annual_income) over(partition by occupation order by customerkey) then 'Equal to prev'
     else Null end) as compare
from customers;

-- fetch the query to dispaly if the annual income of a customer is higher, lower or equal to that of 2 records
-- previous to the current record.

select customerkey, occupation, annual_income,
	lag(annual_income, 2,'NA') over(partition by occupation order by customerkey) as prev_to_prev_customer_income
from customers;

-- fetch the query to dispaly if the annual income of a customer is higher, lower or equal to that of the next customer.

select customerkey, occupation, annual_income,
	lead(annual_income) over(partition by occupation order by customerkey) as next_customer_income
from customers;

-- fetch the query to dispaly if the annual income of a customer is higher, lower or equal to that of the next to next customer.

select customerkey, occupation, annual_income,
	lead(annual_income, 2,'NA') over(partition by occupation order by customerkey) as nxt_to_nxt_customer_income
from customers;
