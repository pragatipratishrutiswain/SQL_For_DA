select count(*) from merchant; #150
select count(*) from merchant_category;	#5
select count(*) from transaction;	#3500

select * from merchant;
select * from merchant_category;
select * from transaction;

Tasks:
1.) Creating Views:
Step 1: You must have to utilize the methods of importing data in your MySQL Workbench which you have learned in the 
initial classes of this module. Create a separate schema for this particular activity.
Step 2: Create different views with the help of the above-mentioned datasets which will help you understand how views are created. 
Also, in the next step, we will be utilizing these views while writing queries which will indicate the importance of 
views in SQL in terms of query optimization.
Note: The questions mentioned below are open-ended questions and the purpose of this activity is to help you practice. 
Here are some of the suggested views which can be created from the above datasets.

1. Create a view named transaction_summary in MySQL that summarizes the total number of transactions, total spending, and average 
transaction amount for each user from the transactions table.

create or replace
	view transaction_summary as
		select
			count(*) count_transactions, 
			round(sum(amount), 2) total_spending_per_user, 
			round(avg(amount), 2) avg_transaction_amount_per_user
		from transaction;
select * from transaction_summary;

2. Create a view named category_spending that shows the total spending amount grouped by merchant category name from 
the transactions, merchants, and merchant_categories tables.

create or replace view 
	category_spending as
		select
			mc.name as merchant_category_name,
			round(sum(t.amount), 2) total_spending_for_merchant_category
		from transaction t
		join merchant m 
			on t.id_merchant = m.id
		join merchant_category mc
			on m.id_merchant_category = mc.id
		group by 1;
select * from category_spending;

3. Create a view named daily_transactions that shows the number of transactions and the total amount spent 
for each day from the transactions table.

create or replace view 
	daily_transactions as
		select 
			date(date) as transaction_date,
            count(*) as number_of_transactions,
            round(sum(amount), 2) as amount_spent 
		from transaction
        group by transaction_date;
select * from daily_transactions;

4. Create a view named user_merchant_interaction that shows the total number of transactions and total amount spent 
by each user at each merchant from the transactions table.

CREATE VIEW user_merchant_interaction AS
SELECT
    Card,
    ID_merchant,
    COUNT(*) AS total_transactions,
    SUM(Amount) AS total_amount_spent
FROM
    Transaction
GROUP BY
    Card,
    ID_merchant;
-------------------
create or replace view
	user_merchant_interaction as
		select 
            t.id_merchant,
            count(*) number_of_transactions,
            round(sum(amount), 2) as amount_spent
		from transaction t
        join merchant m on t.id_merchant = m.id
        group by 1;
select * from user_merchant_interaction;

Step 3: Here are some of the query-related questions that can be created using the above views that you 
have created which helps you optimize your query.
1. Write a query to select user_id, transaction_count, and total_spent from the user_merchant_interaction view for merchant_id 5, 
where transaction_count is greater than 10, and order the results by total_spent in descending order.

select * from user_merchant_interaction
where 
	id_merchant = 5 and
	number_of_transactions > 10
order by amount_spent desc;

2. Write a query to select transaction_date and the average transaction amount from the daily_transactions view for the past month, 
ordering the results by transaction_date.
Note: We have added a few questions above, but feel free to explore the data, create new views, and extract additional insights 
using those views.

WITH max_date AS (
    SELECT MAX(transaction_date) AS latest_transaction_date
    FROM daily_transactions
)
SELECT
    transaction_date,
    round(amount_spent / number_of_transactions, 2) AS past_month_avg_transaction_amount #, latest_transaction_date
FROM
    daily_transactions, max_date
WHERE
    month(transaction_date) = month(max_date.latest_transaction_date) - 1
ORDER BY
    transaction_date;

2.) Creating Indexes:
1. Create a unique index on the transaction_id column in the transactions table to ensure each transaction ID is unique. 
Write the SQL statement to achieve this.

EXPLAIN SELECT * FROM TRANSACTION;
create unique index transaction_id on transaction (id);
show index from transaction;

2. Create a unique index on the merchant_id column in the merchants table to ensure each merchant ID is unique. 
Write the SQL statement for this index.

EXPLAIN SELECT * FROM Merchant;
create unique index merchant_id on Merchant (id);
show index from Merchant;

3. Create a clustered index on the transaction_date column in the transactions table to optimize queries that filter or 
sort by transaction date. Write the SQL statement to create this clustered index.

alter table transaction
modify date timestamp Primary Key;

explain select * from transaction;
show index from transaction;

create clustered index transaction_date on transaction(date);

4. Create a clustered index on the user_id column in the transactions table to optimize user-specific queries. Write the 
SQL statement to create this clustered index.

create index user_id on transaction(id); /* clustered */

5. Create a non-clustered index on the amount column in the transactions table to improve the performance of queries that 
filter by the transaction amount. Write the SQL statement to create this index.
Note: The indexes should created on those where you will be using the WHERE clause, and JOIN statement frequently 
to increase the efficiency and optimize performance.

The above questions will not make any visible changes to the data but indexing will help optimize the query and return 
the output efficiently. 
The questions are meant for your practice and understanding of how you can insert indexes in your dataset.

create index amount on transaction(amount); /* nonclustered */

3.) Creating Data Partitions:
1. Partition the transaction table using range partitioning based on the transaction_date column, creating partitions for each quarter
of the year. Write the SQL statement to create these partitions.

drop table if exists transaction2;

CREATE TABLE transaction2 as
select * from transaction
PARTITION BY RANGE (TO_DAYS(date)) (
    PARTITION p_q1 VALUES LESS THAN (TO_DAYS('2023-04-01')),   -- Jan 1 - Mar 31
    PARTITION p_q2 VALUES LESS THAN (TO_DAYS('2023-07-01')),   -- Apr 1 - Jun 30
    PARTITION p_q3 VALUES LESS THAN (TO_DAYS('2023-10-01')),   -- Jul 1 - Sep 30
    PARTITION p_q4 VALUES LESS THAN (TO_DAYS('2024-01-01'))    -- Oct 1 - Dec 31
);

2. Create range partitions on the amount column in the transactions table, dividing the data into ranges (e.g., 0-100, 100-500, 500-1000, 
1000+). Write the SQL statement to create these partitions.



3. Partition the merchants table using list partitioning based on the category_id column, assuming you have specific categories 
(e.g., 1 for Electronics, 2 for Groceries, 3 for Clothing). Write the SQL statement to create these partitions.



4. Create list partitions on the transactions table based on the amount column, categorizing transactions into low, medium, 
and high-value ranges. Write the SQL statement to create these partitions.



5. Partition the transactions table using hash partitioning on the user_id column to distribute the data across 4 partitions. 
Write the SQL statement to create this partition.
Note: The above questions will not make any visible changes to the data but data partitioning will help optimize the query and return 
the output efficiently. The questions are meant for your practice and understanding of how you can create partitions in your dataset.
