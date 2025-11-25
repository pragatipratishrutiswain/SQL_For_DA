select * from countries;
select * from sessions_data;
select * from users;

DESC countries;
DESC sessions_data;
DESC users;

1. A user can have multiple device type.
TRUE because each userid has duplicates
select user_id, device_type, count(*)
from airbnb.sessions_data
group by user_id, device_type having count(*)>1

2. Windows users spend more time than Mac and Iphone users combined.
select device_type,sum(secs_elapsed),495926322 + 188532489 as sum from c group by device_type order by sum desc
FALSE

3. ‘view’ is the most common action type.
select action_type, count(action_type) as count from sessions_data group by action_type order by count desc
TRUE

4.Problem statement
Identify the top 5 most active users who have spent more than 10,000 seconds on at least one session. 
'Most active' is defined as having the highest number of sessions. This will help you analyze user session data to 
find a potential correlation between session duration and user activity.

Instructions:
It is suggested to explore the data using the DESCRIBE and SELECT statement before writing the queries 
which will help you understand the relationship between tables.

Hints:
Use sessions_data table.

select user_id as Most_active_User, sum(secs_elapsed) as total_timespent, count(*) as count
from sessions_data
group by user_id
having count(secs_elapsed > 10000) >=1
order by 3 desc
limit 5

Ans according to Coding Ninjas----

SELECT user_id,  COUNT(*) 
FROM sessions_data
WHERE 
    user_id IN (
        SELECT DISTINCT 
            user_id
        FROM 
            sessions_data
        WHERE 
            secs_elapsed > 10000
    )
GROUP BY 
    user_id
ORDER BY 
    COUNT(*) DESC
LIMIT 5

5.Using the users data table, determine which country_destination appears most frequently. Identify and report the country code 
that occurs the highest number of times in the country_destination column.

Hints:
Use the Users table.
The country_destination column has ‘NDF’ entries which implies Not Defined. The output should not contain the countries as Not Defined.
Determine which country_destination appears most frequently. Identify and report the country code that 
occurs the highest number of times in the country_destination column.

select country_destination, count(*)
	from users
where
	country_destination != 'NDF'
group by
	country_destination
order by
	count(*) desc
limit 1

7.Using the user data table, determine the most frequently used signup method for each Gender category, considering only users who have made a booking 
(as indicated by a non-null value in the Date_first_booking column).
This exploration will help us understand if certain demographic factors are associated with specific signup preferences among users who follow through 
with bookings.

Hints:
The country_destination column has ‘NDF’ entries which implies Not Defined. The output should not contain the countries as Not Defined.
Your output must give the number of bookings made by each gender and signup method combination where the country is defined.

select gender, signup_method, count(*) from users
where country_destination != 'NDF' and date_first_booking != ''
group by gender, signup_method
#order by count(*) desc

#Information
select * from users
select count(*) from users where gender = '' # is null does not work
select count(*) from users where date_first_booking = '' # is null does not work

select gender, length(gender), count(*) from users group by gender order by 1
select date_first_booking, count(*) from users group by date_first_booking order by 1
desc users

7.Using the user data table, identify the most frequently used signup method among users categorized as female who have made a booking. 
Determine which signup method has the highest count for this group.

Hints:
Use the Users table.
The country_destination column has ‘NDF’ entries which implies Not Defined. The output should not contain the countries as Not Defined.

select gender, signup_method, count(*) from users
where country_destination != 'NDF' and date_first_booking != '' and gender = 'Female'
group by gender, signup_method
order by count(*) desc

8.Determine the average age of users by destination country, considering only those with a booking and available age data. 
Sort the results from the youngest to the oldest users.
This will help you understand the destination country preferences for different age of users.

Hints:
Use the Users table.
The country_destination column has ‘NDF’ entries which implies Not Defined. The output should not contain the countries as Not Defined.

select country_destination, avg(age) as average_age from users
where country_destination != 'NDF' and age != ''
group by 1
order by 2


9.Identify the anomalies in the age column, specifically the unusually large values. Determine the number of records where the age is greater than 100.

select count(*) from users
where age > 100

10.We want to analyze how user sessions impact bookings. Write a query to find users with fewer than 5 sessions who made a booking to the destination "US". 
Sort the results by the number of sessions in descending order.

select * from users
select * from sessions_data;

select user_id as id, count(*) as session_count from sessions_data
join users on id = user_id 
and country_destination = 'US'
group by user_id
having session_count < 5 
order by 2 desc

11.We want to analyze the activity of organic users, defined as those with "direct" listed as their affiliate provider. 
Specifically, we are interested in the total number of clicks made by these users. Please write a query to calculate the total clicks made by organic users.

select * from countries;
select * from sessions_data;
select * from users;

select count(*) as total_count_clicks
from sessions_data
join users 
on id = user_id 
and affiliate_channel = 'direct' and action_type = 'click'
order by 1 desc

12.The product team wants to understand the most common actions performed by users who have made a booking, as well as the devices they 
use for these actions. This information can help in optimizing the user experience and tailoring the interface to common user behaviors.
Write a SQL query to identify the top 5 most common actions performed by users who made a booking (i.e., country_destination is not 'NDF') and 
the devices they use for these actions.

select action, device_type, count(*) as action_count
from sessions_data
join users 
on id = user_id 
and country_destination != 'NDF' and date_first_booking != ''
group by 1,2 
order by 3 desc 
limit 5

13. To understand user engagement better, calculate the average time users who have made a booking spend on different actions. 
Check the results across action type and device type. This will help identify which actions and devices are associated with longer engagement times, 
potentially indicating more complex or interesting tasks.

Write a SQL query to determine the average time spent on actions by users who have made a booking (i.e., country_destination is not 'NDF'), 
across action type and device type. Sort the results by average time spent in descending order.

Hints:
Use the Users and Session_data table.
The country_destination column has ‘NDF’ entries which implies Not Defined. The output should not contain the countries as Not Defined.

select * from users
select * from sessions_data

select action_type, device_type, avg(secs_elapsed) as average_time_spent 
from sessions_data
join users 
on id = user_id 
and country_destination != 'NDF'
group by 1,2
order by 3 desc

14.To further understand user behavior, identify the most frequent combinations of two actions performed by users who have made a booking, 
specifically on Windows Desktop devices. Determine which pairs of actions result in the most time spent. This insight can help optimize the user 
journey by focusing on significant action pairs on Windows Desktop.

Write a SQL query to find the most frequent combinations of two actions (performed by the same user on Windows Desktop devices) where the most time is spent, 
for users who have made a booking (i.e., country_destination is not 'NDF'). Consider the top 10 combinations from the resulting table which will be considered 
as most frequent.

APPROACH
--------
				sessions_data TABLE
id		action							id		action
1		a1								1		a1		
1		a2			SELF JOIN			1		a2
2		a3			count(*)=4			2		a3
2		a4								2		a4

OUTPUT
1		a1		1		a1
1		a1		1		a2
1		a2		1		a1
1		a2		1		a2				count(*) = 8
2		a3		2		a3
2		a3		2		a4
2		a4		2		a3
2		a4		2		a4

select 
	s1.action as first_action, 
	s2.action as second_action,
	count(*) as action_pair_count, 
	sum(s1.secs_elapsed + s2.secs_elapsed) as total_time_spent
from sessions_data s1
join sessions_data s2 
on s1.user_id = s2.user_id
and  s1.action <> s2.action
join Users
on id = s1.user_id
where country_destination != 'NDF' and date_first_booking <> ''
and s1.device_type = 'Windows Desktop' and s2.device_type = 'Windows Desktop'
group by 1,2
order by 4 DESC
limit 10

15.To understand which affiliate channels are most effective, analyze the number of bookings made through each first affiliate channel and calculate 
their conversion rates.

Write an SQL query to find the number of bookings and the conversion rate for each first affiliate channel. Consider a booking as made 
if country_destination is not 'NDF'.

Hints:
Use the Users table.
The country_destination column has ‘NDF’ entries which implies Not Defined. The output should not contain the countries as Not Defined.
To calculate the conversion rates, use the following formula:
Total Bookings / Total Users * 100

select * from countries;			DESC countries;
select * from sessions_data;		DESC sessions_data;
select * from users;				DESC users;

SELECT 
	first_affiliate_tracked AS affiliate_channel, 
	COUNT(id) AS total_users,
	COUNT(CASE WHEN country_destination != 'NDF' THEN id END) AS bookings,
	ROUND(COUNT(CASE WHEN country_destination != 'NDF' THEN id END) * 100.0 / COUNT(id), 4) AS conversion_rate
FROM Users
GROUP BY 1
ORDER BY conversion_rate DESC;

16.To further understand the effectiveness of different affiliate providers and signup methods, determine the conversion rate for each combination.

Write a SQL query to calculate the conversion rate for each combination of affiliate provider and signup method. 
Consider a booking as made if country_destination is not 'NDF'.
Use the Users table.

SELECT 
	affiliate_provider,
    signup_method,
	COUNT(id) AS total_users,
	COUNT(CASE WHEN country_destination != 'NDF' THEN id END) AS bookings,
	ROUND(COUNT(CASE WHEN country_destination != 'NDF' THEN id END) * 100.0 / COUNT(id), 4) AS conversion_rate
FROM Users
GROUP BY 1,2
ORDER BY conversion_rate DESC;

17.To understand which marketing channels are driving the most bookings, assess the effectiveness of different marketing channels by 
calculating the conversion rate for each channel.

Write a SQL query to assess the effectiveness of different marketing channels by calculating the conversion rate for each affiliate channel. 
Consider a booking as made if country_destination is not 'NDF'.
Use the Users table.

select
	affiliate_channel,
    count(id) as total_users,
    count(case when country_destination != 'NDF' then id end) as bookings,
    round(count(case when country_destination != 'NDF' then id end)*100/count(id), 4) as conversion_rate
from users
group by 1
order by 4 desc
