select * from customers;
select count(*) from customers;		#100

select * from energy_production;
select count(*) from energy_production;		#10000

select * from energy_consumption;
select count(*) from energy_consumption;	#10000

select * from production_plants;
select count(*) from production_plants; #10

select * from sustainability_initiatives;
select count(*) from sustainability_initiatives; #20

1. Write a query to list the top 5 production plants with the highest average carbon emissions per unit of energy produced (in kg/kWh). 
Include the plant name, location, and average carbon emissions per kWh.
Hints:
Use the production_plants and energy_production tables.
Calculate the carbon emissions per unit of energy by dividing produced total carbon emissions by the total total energy for each plant.

select
	plant_name, location, sum(carbon_emission_kg)/sum(amount_kwh) avg_carbon_emission_per_kwh
from production_plants pp
inner join energy_production ep
	on ep.production_plant_id = pp.plant_id
group by 1,2
order by 3 desc
limit 5;

2.Write a query to list the top 3 sustainability initiatives based on the total energy savings achieved. 
Include the initiative name, start date, end date, and total energy savings. The resulting table should be in 
descending order for the total energy savings column.
Hint:
Use the sustainability_initiatives table.
Sum up the energy savings for each initiative and order the results to get the top 3.

select
	initiative_name,
	start_date,
	end_date,
	energy_savings_kwh
from sustainability_initiatives
order by 4 desc
limit 3;

3.Write a query to list all energy production records along with a new column that shows the total energy production amount 
for each energy_type. The resulting table should contain production ID, production plant ID, the date of production, energy type, 
amount of production and the total amount according to the energy type.
Hint:
Use the OVER() clause.
Use the energy_production table for this question.

select
	production_id,
	production_plant_id,
	date,
	energy_type,
	amount_kwh,
	sum(amount_kwh) over(partition by energy_type) total_energy_by_type
from energy_production

6. Write a query to rank the sustainability initiatives based on their total energy savings. The query should include columns 
for the initiative name, start date, end date, total energy savings, and their rank based on these savings.
Hint:
Use the sustainability_initiatives table.
Use a ranking function that assigns the same rank to initiatives with the same energy savings. 
Ensure the results are ordered by initiative rank.

select 
    initiative_name, 
    start_date, 
    end_date, 
    energy_savings_kwh, 
    rank() over(order by energy_savings_kwh desc) initiative_rank
from sustainability_initiatives;

/*
7. Write a query to list the monthly energy production amounts for each plant along with the previous month's 
production amount and the next month's production amount. Include columns for the plant ID, month, current month's 
production amount, previous month's production amount, and next month's production amount. The resulting table 
should be order in ascending order for the production_plant_id and the month column.
Hint:
Use the energy_production table.
Use window functions to get the previous and next month's production amounts. Order the results by plant ID and month. */

select 
	production_plant_id,
    date_format(date,"%Y-%m") month,
    sum(amount_kwh) current_month_production,
    lag(sum(amount_kwh)) over(partition by production_plant_id order by date_format(date,"%Y-%m")) previous_month_production,
    lead(sum(amount_kwh)) over(partition by production_plant_id order by date_format(date,"%Y-%m")) next_month_production
from energy_production
group by 1,2;

/* Using the energy_consumption table, which contains data on energy usage, your task is to write a SQL query that will 
list each customer's ID along with their first and last recorded energy consumption amounts in 2023. The table includes 
columns for customer_id, first_consumption and last_consumption. Return the resulting table in ascending order for customer ID.
Hint:
Use the energy_consumption table.
Use window functions to identify the first and last consumption amounts for each customer. Ensure that only one row per 
customer is returned, showing their first and last consumption amounts. */

select 
	distinct customer_id, 
    first_value(amount_kwh) over(partition by customer_id order by date) first_consumption,
    last_value(amount_kwh) over(partition by customer_id order by date rows between unbounded
    preceding and unbounded following) last_consumption
from energy_consumption 
where year(date) = 2023

/* Write a query to list each customer's total energy consumption and their average monthly consumption. 
The output table should contain the customer_id, name, total consumption, and average monthly energy consumption. 
The resulting table should be ordered in ascending order for the customer ID column.
Hint:
Use the energy_consumption and customers table.
Use a CTE to calculate the monthly consumption for each customer and then summarize this information to get the total 
and average monthly consumption. */

with cte as 
(
select 
	customer_id, name, date_format(date, "%Y-%m") month,
    sum(amount_kwh) amount_kwh
from customers
inner join energy_consumption using(customer_id)
group by 1,2,3
 )

select 
	customer_id, name, 
	sum(amount_kwh) total_consumption, 
	avg(amount_kwh) avg_monthly_consumption
from cte
group by 1, 2
order by 1

/* Your task is to create a detailed SQL query that analyzes carbon emission data across all production plants. 
This query should utilize the energy_production and production_plants tables to calculate both the average and total carbon 
emissions for each plant. The final output should list each production plant's ID, name, average carbon emissions, and 
total carbon emissions, ordered by the plant ID for easy reference.
Hint:
Use the energy_production and the production_plants tables.
Use a CTE to calculate the carbon emissions for each plant and then summarize this information to get the average and total emissions. */

select 
	production_plant_id,
    plant_name,
    avg(carbon_emission_kg) avg_emissions ,
    sum(carbon_emission_kg) total_emissions
from production_plants 
join energy_production on production_plant_id = plant_id
group by 1, 2
order by 1

/* Write a query to list each initiative's total energy savings and the average monthly energy savings. 
The final output should present the initiative ID, name, total savings, and average monthly savings, ordered by initiative ID.
Hint:
Use the sustainability_initiatives table.
Use a CTE to calculate the monthly energy savings for each initiative and then summarize this information to get the total and 
average monthly savings. */

with cte as
(	select
		initiative_id,
		initiative_name,
		TIMESTAMPDIFF(MONTH, start_date, end_date) Month_Diff,
        energy_savings_kwh / TIMESTAMPDIFF(MONTH, start_date, end_date) monthly_energy_savings
	from sustainability_initiatives )

select 
	initiative_id,
	initiative_name,
	sum(monthly_energy_savings) total_savings,
	avg(monthly_energy_savings) avg_monthly_savings
from cte
group by 1,2