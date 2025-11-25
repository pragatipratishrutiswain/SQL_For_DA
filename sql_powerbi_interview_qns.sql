1. 𝐋𝐨𝐲𝐚𝐥 𝐛𝐮𝐭 𝐋𝐨𝐰-𝐒𝐩𝐞𝐧𝐝 𝐂𝐮𝐬𝐭𝐨𝐦𝐞𝐫𝐬
Tables: Customers, Orders, Order_Items
Columns:
Customers: customer_id, signup_date
Orders: order_id, customer_id, order_date
Order_Items: order_id, item_price, quantity
Question:
Find customers who placed at least one order every month in the last 6 months, but whose average order value is in the bottom 
20% across all customers.

2. 𝐃𝐢𝐬𝐜𝐨𝐮𝐧𝐭 𝐂𝐨𝐝𝐞 𝐀𝐛𝐮𝐬𝐞𝐫𝐬
Tables: Users, Orders, Discounts
Columns:
Users: user_id, email
Orders: order_id, user_id, order_date, shipping_address, discount_code
Discounts: discount_code, discount_value, valid_from, valid_to
Question:
Find users who used more than 3 different discount codes in the same month, with each order delivered to a different shipping address.

3. 𝐑𝐞𝐭𝐮𝐫𝐧-𝐇𝐞𝐚𝐯𝐲 𝐒𝐡𝐨𝐩𝐩𝐞𝐫𝐬 𝐢𝐧 𝐚 𝐒𝐩𝐞𝐜𝐢𝐟𝐢𝐜 𝐂𝐚𝐭𝐞𝐠𝐨𝐫𝐲
Tables: Orders, Order_Items, Returns, Products
Columns:
Orders: order_id, customer_id, order_date
Order_Items: order_id, product_id, quantity
Returns: order_id, product_id, quantity_returned
Products: product_id, category
Question:
Find customers who have returned more than 50% of the total quantity they ordered for any product in the 'Footwear' category.

4. 𝐒𝐢𝐥𝐞𝐧𝐭 𝐂𝐡𝐮𝐫𝐧𝐞𝐫𝐬
Tables: Users, App_Usage, Purchases
Columns:
Users: user_id, signup_date
App_Usage: user_id, activity_date
Purchases: user_id, purchase_date, amount
Question:
 Find users who logged in at least 5 times in the last 60 days, didn’t purchase anything in the last 90 days, but had made 
 at least one purchase in the 3 months prior.

5. 𝐈𝐧𝐜𝐨𝐧𝐬𝐢𝐬𝐭𝐞𝐧𝐭 𝐃𝐞𝐥𝐢𝐯𝐞𝐫𝐲 𝐀𝐠𝐞𝐧𝐭𝐬
Tables: Delivery_Agents, Orders, Deliveries
Columns:
Delivery_Agents: agent_id, agent_name
Orders: order_id, city
Deliveries: order_id, agent_id, delivery_time_minutes
Question:
Find agents whose average delivery time differs by more than 2 hours between any two cities they’ve delivered in.

6. 𝐇𝐢𝐠𝐡-𝐕𝐚𝐥𝐮𝐞 𝐒𝐚𝐦𝐞-𝐃𝐚𝐲 𝐁𝐮𝐲𝐞𝐫𝐬
Tables: Users, Orders, Payments
Columns:
Users: user_id, signup_date
Orders: order_id, user_id, order_date
Payments: order_id, payment_amount
Question:
Find users who placed multiple orders on the same day, and whose combined order value that day exceeded ₹10,000.

7. 𝐌𝐨𝐧𝐭𝐡𝐥𝐲 𝐂𝐚𝐭𝐞𝐠𝐨𝐫𝐲 𝐒𝐡𝐢𝐟𝐭 𝐀𝐧𝐚𝐥𝐲𝐬𝐢𝐬
Tables: Orders, Order_Items, Products
Columns:
Orders: order_id, customer_id, order_date
Order_Items: order_id, product_id, quantity
Products: product_id, category
Question:
Identify customers who mostly bought from one category last month and switched to a different dominant category this month.

A measure of how often users return to a product

Here are some real-world Power BI questions that test your DAX, data modeling, and practical thinking:

🔹 Advanced DAX & Business Logic

How do you calculate a 3-month moving average for revenue, while respecting filter context and avoiding blanks at the start of the year?
How would you calculate the repeat purchase rate based on customers who ordered more than once in the last 90 days?
How can you create dynamic customer segments (Bronze, Silver, Gold) based on total spend, with thresholds controlled via a slicer?
How do you return a distinct count of customers who purchased last month but not in the previous month?

🔹 Data Modeling Challenges

Sales and return data are in separate tables, and returns may happen in later months. How would you model this and calculate 
monthly net revenue?
With Sales, Marketing Spend, and Support Tickets as fact tables sharing dimensions, how would you design the model to avoid 
circular dependencies?
A campaign table has start and end dates. How do you display only the sales that fall within active campaign periods?

🔹 Filtering, RLS & Report Behavior

How would you set up RLS so regional managers see only their region, but central team members see all data?
How do you ensure the report always loads data for the “Last Completed Week,” even if refreshed mid-week?
How can you apply a filter that affects only selected visuals on a page and not all?

🔹 Performance & Optimization

If key visuals are slow due to DAX, how would you identify the issue and improve performance?
You’re working with a 30M+ row table. What Power Query and DAX optimizations would you use to maintain performance?

🔹 Real Business Use-Cases

How would you show only those cities that contribute at least 2% of total sales for the selected time period?
How would you create a slicer-based discount simulation (5%, 10%, 15%) to see its effect on profit and margin?
How would you allow users to toggle between Open, Closed, and Escalated ticket trends using a single dropdown?
How do you compare a selected product’s performance with the average of its product category?