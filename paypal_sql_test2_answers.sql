select * from countries;
#  select count(*) from countries;		#50

select * from currencies;
#select count(*) from currencies;	#5

select * from merchants;
#select count(*) from merchants;		#200

select * from transactions; 
#select count(*) from transactions;	#10003

select * from users;
#select count(*) from users; 		#1000

-- 1. Determine the top 5 countries by total transaction amount for both sending and receiving funds in the last quarter of 
-- 2023 (October to December 2023). Provide separate lists for the countries that sent the most funds and those that received 
-- the most funds. Additionally, round the totalsent and totalreceived amounts 
-- to 2 decimal places.
SELECT c.country_name, ROUND(SUM(t.transaction_amount), 2) AS total_sent
FROM Transactions t
JOIN Users u ON t.sender_id = u.user_id
JOIN Countries c ON u.country_id = c.country_id
WHERE t.transaction_date >= '2023-10-01' AND t.transaction_date < '2024-01-01'
GROUP BY c.country_name
ORDER BY total_sent DESC
LIMIT 5;

SELECT c.country_name, ROUND(SUM(t.transaction_amount), 2) AS total_received
FROM Transactions t
JOIN Users u ON t.recipient_id = u.user_id
JOIN Countries c ON u.country_id = c.country_id
WHERE t.transaction_date >= '2023-10-01' AND t.transaction_date < '2024-01-01'
GROUP BY c.country_name
ORDER BY total_received DESC
LIMIT 5;

-- 2. The sales team is interested in identifying the top-performing merchants based on the number of payments received. 
-- The analysis will help the sales team to better understand the performance of these key merchants during the specified timeframe.
-- Your task is to analyze the transaction data and determine the top 10 merchants, sorted by the total transaction amount 
-- they received, within the period from November 2023 to April 2024. For each of these top 10 merchants, 
-- provide the following details: merchant ID, business name, the total transaction amount received, and the average transaction amount.
-- Hints:
-- Use the Transactions and Merchants table in the PayPal Transaction schema.
-- Return the output table in descending order.

select merchant_id, business_name, 
    sum(transaction_amount) as total_recieved,
    avg(transaction_amount) as average_transaction
from merchants m
join transactions t on m.merchant_id = t.recipient_id
where transaction_date between '2023-11-01' and '2024-04-30'
group by 1,2
order by 3 desc
limit 10;

select count(distinct merchant_id) from merchants;					# 200
select count(distinct recipient_id), count(distinct sender_id) from transactions; # 1000
select count(distinct user_id) from users;				# 1000

-- 3. The finance team wants to analyze the company's exposure to currency risks.
-- Analyze currency conversion trends from 22 May 2023 to 22 May 2024.
-- Calculate the total amount converted from each source currency to the top 3 most popular destination currencies.
-- Hints:
-- - Focus on transactions between 22 May 2023 and 22 May 2024.
-- - Group the data by source currency and sum the transaction amounts.
-- - Order the results by the total converted amount in descending order.
-- - Limit the results to the top 3 destination currencies.

select currency_code, sum(transaction_amount)
from transactions
where transaction_date between '2023-05-22' and '2024--5-22'
group by 1
order by 2 desc
limit 3;

-- 4. To meet compliance requirements, the finance team needs to identify the nature of transactions conducted by the company. 
-- Specifically, you are required to analyze transaction data for the first quarter of 2024 (January to March).
-- Your task is to create a new column in the dataset that indicates whether each transaction is international 
-- (where the sender and recipient are from different countries) or domestic (where the sender and recipient are from the same country).
-- Additionally, provide a count of the number of international and domestic transactions for this period.
-- This classification will assist in ensuring compliance with relevant regulations and provide insights into the distribution 
-- of transaction types. Please include a detailed summary of the counts for each type of transaction.
-- Hints:
-- Use the Transactions and Users tables.

with senders as 
(select transaction_id, sender_id, country_id, transaction_date from transactions
 inner join users on user_id = sender_id),
 
 recipients as 
 (select transaction_id, recipient_id, country_id, transaction_date from transactions
  inner join users on user_id = recipient_id)

select
	(case when s.country_id != r.country_id then 'International'
     else 'Domestic'
     end) 
	as transaction_type,
    count(s.transaction_id) as transaction_count
from senders s
join recipients r on s.transaction_id = r.transaction_id
where date_format(s.transaction_date, '%Y') = 2024 
    and quarter(s.transaction_date) = 1
group by transaction_type

-- 5. To improve user segmentation, the finance team needs to analyze user transaction behavior.
-- Your task is to calculate the average transaction amount per user (Round up to 2 Decimal Places) for the past six months,
-- covering the period from November 2023 to April 2024. Once you have the average transaction amount for each user, identify 
-- and list the users whose average transaction amount exceeds $5,000.
-- This analysis will help the finance team to better understand high-value users and tailor strategies to meet their needs.
-- Hints:
-- Use the Transactions and Users table.
-- Calculate the average transaction amount per user and round it up to 2 decimal places.
-- Order the result by user_id in ascending order.
select user_id, email, round(avg(transaction_amount), 2) as avg_amount
from transactions t
join users u on user_id = sender_id or user_id = recipient_id
where transaction_date between "2023-11-01" and "2024-04-30"
group by user_id, email
having avg_amount > 5000
order by user_id

-- 6. Which currency had the highest transaction amount from in the past one year up to today indicating the greatest exposure?
-- (assume today is 22-05-2024)

select currency_code, sum(transaction_amount) from transactions
where transaction_date between '2023-05-22' and '2024-05-22'
group by 1
order by 2 desc

-- 7.The sales team wants to identify top-performing merchants. Which merchant should be considered as the most successful 
-- in terms of total transaction amount received between November 2023 and April 2024?

select business_name, sum(transaction_amount) from merchants
join transactions on merchant_id = recipient_id
where transaction_date between '2023-11-01' and '2024-04-30'
group by 1
order by 2 desc






