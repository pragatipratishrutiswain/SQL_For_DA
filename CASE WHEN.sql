drop table employees;

create table employees(
	empl_id varchar(10),
    salary decimal(10,2),
    firstname varchar(10),
    lastname varchar(10),
    email varchar(50),
    gender char(1),
    birthdate date
    );

INSERT INTO employees (empl_id, salary, firstname, lastname, email, gender, birthdate)
VALUES 
    ('EMP001', 55000.75, 'John', 'Doe', 'john.doe@example.com', 'M', '1990-05-12'),
    ('EMP002', 62000.00, 'Jane', 'Smith', 'jane.smith@example.com', 'F', '1988-08-21'),
    ('EMP003', 47000.50, 'Mike', 'Johnson', 'mike.johnson@example.com', 'M', '1995-03-15'),
    ('EMP004', 71000.20, 'Sara', 'Brown', 'sara.brown@example.com', 'F', '1992-11-02'),
    ('EMP005', 58000.60, 'Alex', 'Taylor', 'alex.taylor@example.com', 'M', '1993-07-19'),
    ('EMP006', 53000.00, 'Emma', 'Williams', 'emma.william-s@example.com', 'F', '1994-02-23'),
    ('EMP007', 64000.40, 'Chris', 'Evans', 'chris.evans@example.com', 'M', '1987-12-10'),
    ('EMP008', 49000.80, 'Olivia', 'Martinez', 'olivia.martinez@example.com', 'F', '1991-04-30'),
    ('EMP009', 60000.00, 'Ethan', 'Clark', 'ethan.clark@example.com', 'M', '1989-09-05'),
    ('EMP010', 72000.30, 'Sophia', 'Lewis', 'sophia.lewis@example.com', 'F', '1986-06-18');
    
insert into employees(empl_id, salary,firstname, lastname, email)
values
	('EMP011', 89000.30, 'Sazia', 'Khan', 'sazia.khan@example.com')

insert into employees(empl_id, salary,firstname,birthdate)
values
	('EMP012', 59000.30, 'Rupa', '1995-09-16')

SELECT * FROM EMPLOYEES;

#Count no of columns in employees table
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'employees';

#Show all column names
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'employees';

OR

SELECT *
FROM employees
LIMIT 0;

#Deleting 2nd last row from employees table
DELETE FROM employees
WHERE empl_id = (
    SELECT empl_id 
    FROM employees 
    ORDER BY empl_id DESC 
    LIMIT 1 OFFSET 1
);
Error Code: 1093. You can not specify target table 'employees' for update in FROM clause

USE of CASE WHEN
---------
SELECT 
    column_name,
    CASE 
        WHEN condition1 THEN result1
        WHEN condition2 THEN result2
        ELSE default_result
    END AS alias_name
FROM table_name;

The CASE WHEN statement in SQL is a conditional expression that works like an "IF-THEN-ELSE" logic.

Example 1: Categorizing Sales Performance

SELECT 
    employee_name,
    sales,
    CASE 
        WHEN sales >= 10000 THEN 'High Performer'
        WHEN sales >= 5000 THEN 'Average Performer'
        ELSE 'Low Performer'
    END AS performance_category
FROM sales_data;

Example 2: Handling Null Values

SELECT 
    customer_name,
    COALESCE(phone_number, 'N/A') AS phone_status,
    CASE 
        WHEN phone_number IS NULL THEN 'Missing'
        ELSE 'Available'
    END AS phone_check
FROM customers;

Example 3: Using CASE in ORDER BY

SELECT 
    product_name,
    category,
    price
FROM products
ORDER BY 
    CASE 
        WHEN category = 'Electronics' THEN 1
        WHEN category = 'Clothing' THEN 2
        ELSE 3
    END;

Key Points to Remember:
1. CASE works in SELECT, WHERE, ORDER BY, and even GROUP BY.
2. The ELSE part is optional — if omitted, unmatched cases return NULL.
3. SQL runs through conditions sequentially, stopping at the first TRUE match.

Example 3: Use CASE WHEN in an Update
Want conditional updates? No problem!

UPDATE orders
SET status = 
    CASE 
        WHEN shipped_date IS NOT NULL THEN 'Shipped'
        WHEN cancelled_date IS NOT NULL THEN 'Cancelled'
        ELSE 'Pending'
    END;