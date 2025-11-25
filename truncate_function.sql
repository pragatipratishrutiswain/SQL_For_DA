# Truncate Function inside the SQL query
/* 
In MySQL, TRUNCATE() is a mathematical function that truncates a number to a specified number of decimal 
places without any rounding. It accepts two arguments: the number to truncate and the number of decimal places.
*/
-- Syntax: TRUNCATE(number, decimals)

-- Truncating to a positive number upto 2 decimal places
SELECT TRUNCATE(123.4367, 2);

-- Truncating to zero decimal places
SELECT TRUNCATE(123.4567, 0);

-- Truncating with a negative number of decimal places 
SELECT TRUNCATE(12345.67, -1);
SELECT TRUNCATE(12345.67, -2);
SELECT TRUNCATE(12345.67, -3);
SELECT TRUNCATE(12345.67, -4);
SELECT TRUNCATE(12345.67, -5);

-- Positive value: Truncates the number to the specified number of decimal places to the right of the decimal point.
-- Zero (0): Truncates the number to an integer, removing all digits after the decimal point.
-- Negative value: Truncates the number to the left of the decimal point, replacing that many digits with zeros.

-- Primary Usecase: Creating groups for numbers
use cn_3;
-- Example
/*
Show all of the patients grouped into weight groups.
Show the total amount of patients in each weight group.
Order the list by the weight group decending.
For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
*/
  
select 
	count(*) as cnt_patients_in_to_groups,
    truncate(weight, -1) as weight_group
from patients
group by 2
order by 2 desc;

/*
Each admission costs $50 for patients without insurance, and $10 for patients with insurance. 
All patients with an even patient_id have insurance.
Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance.
Add up the admission_total cost for each has_insurance group.
*/
with cte as(
    select 
      patient_id,
      IF(patient_id % 2 = 0, 'Yes', 'No') as has_insurance
    from patients
  )
select
	has_insurance,
	sum(if(has_insurance = 'Yes', 10, 50)) as cost_per_consultation
from cte
group by 1 order by 1;

-- Note
/*
In MySQL (and most databases), an AUTO_INCREMENT value is not designed to guarantee continuity, only uniqueness.
When you delete a row, the database does not reuse that old ID — it keeps counting forward from the last generated value.

Why MySQL does this?

1. Concurrency safety:
In a multi-user environment, many inserts can happen simultaneously.
If MySQL tried to “fill gaps,” it would have to lock the table or risk giving two users the same ID — hurting performance and integrity.

2. Uniqueness guarantee:
The main purpose of AUTO_INCREMENT is to provide unique identifiers, not continuous sequences.

3. Performance:
MySQL maintains an internal counter (in memory).
Each new row just increments the counter — simple and fast.
Reusing deleted IDs would require searching for missing numbers → slow and complex.

Work around: If you aspire for conituous id increment then switch to window function like row_number().
*/

# Insert two rows to the table patients.
INSERT INTO patients (
  first_name, last_name, gender, birth_date, city,
  province_id, allergies, height, weight
)
VALUES
('John', 'Doe', 'M', '1990-01-01', 'Toronto', 'ON', 'Penicillin', 180, 75),
('Rekha', 'Race', 'F', '1994-09-23', 'Chicago', 'AX', 'Pllen', 178, 70);

select * from patients order by patient_id desc;

# delete the row with patient_id = 103
delete from patients where patient_id = 103;

# delete the last row from the table ordered by patient_id
delete from patients order by patient_id desc limit 1;

select * from patients order by patient_id;

select * from patients order by patient_id desc;

# select the last inserted id.
-- LAST_INSERT_ID() returns the most recent automatically generated AUTO_INCREMENT value for the current session (i.e., connection).
SELECT last_insert_id();
