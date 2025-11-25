What Does RECURSIVE Mean?
In SQL, RECURSIVE is a keyword used with Common Table Expressions (CTEs) to allow a query to call itself 
repeatedly until a certain condition is met. This is useful for generating sequences, hierarchical data 
(like trees and graphs), and patterns.

How Recursive CTEs Work?

A recursive CTE consists of two parts:
1. Base Case (Anchor Query): This is the starting point.
2. Recursive Case (Recursive Query): This refers to itself and continues until a stopping condition is met.

e.g. 1- print 5 to 1 in a column in descending order:

WITH RECURSIVE countdown(n) AS (
    SELECT 5  					-- Anchor Query, Base case: Start with 5
    
    UNION ALL
    
    SELECT n - 1 FROM countdown -- Recursive step: Decrease by 1
    WHERE n > 1  				-- Filter to stop the Recursive
)
SELECT * FROM countdown;

-- Slice out 4 to 7 from 1 to 10 numbers and exlude them in the final output
with recursive cte(n) as(
select 1 as n
union all
select n+1
from cte
where n<10)
select n from cte where n not between 4 and 7;

-- print 1 to 5
WITH RECURSIVE RECURSIVE_CTE(N) AS (
	SELECT 1 AS N
    
    UNION ALL
    
    SELECT N+1
    FROM RECURSIVE_CTE			-- Recursive step: increase by 1
    WHERE N < 5		
)
SELECT N FROM RECURSIVE_CTE;
-- --------------------------------
-- Start from n as 10 and go till 0 displaying n value, remainder by deviding n by 3 and divisibility test as True or False
with recursive cte(n) as(
select 10 as n
union all
select n-1
from cte
where n > 0
)
select n, n%3 as remainder, 
	case when n%3 = 0 then "True" else "False" end
    as divisibility_by_3 
from cte;

								-- -- SLICING INTO GROUPS (LINKEDIN INTERVIEW) ----
-- Take the sequence 10 → 0, then slice it into groups where each group ends when n % 3 = 0, and 
-- within each group concatenate the values separated by comma-space ', '.

-- WITHOUT WINDOW FUNCTION --
WITH RECURSIVE cte(n) AS (
  SELECT 10
  UNION ALL
  SELECT n - 1 FROM cte WHERE n > 0
)
SELECT 
	(n DIV 3) + 1 AS grp, -- or ceiling(rnk/3)
	-- DIV is integer division in MySQL. Unlike / (which gives decimals), DIV discards the fractional part: 10/3 → 3.3333, 10 DIV 3 → 3

	GROUP_CONCAT(n ORDER BY n DESC separator ', ') AS numbers
FROM cte
GROUP BY grp
ORDER BY grp DESC;

-- USING WINDOW FUNCTION --
WITH RECURSIVE cte(n) AS (
  SELECT 10
  UNION ALL
  SELECT n - 1 FROM cte WHERE n > 0
),
labeled AS (
  SELECT
    n,
    SUM(CASE WHEN n % 3 = 0 THEN 1 ELSE 0 END)
      OVER (ORDER BY n DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
    + CASE WHEN n % 3 <> 0 THEN 1 ELSE 0 END AS grp
  FROM cte
)
SELECT grp, GROUP_CONCAT(n ORDER BY n DESC SEPARATOR ', ') AS numbers
FROM labeled
GROUP BY grp
ORDER BY grp;
-- -------------------------
select 10%(3/21) = 0; # False because 10 % 0.428 != 0
select 10%(3/12) = 0; # True because 10 % 0.25 = 0
-- -------------------------
e.g. - 2
P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):
* * * * * 
* * * * 
* * * 
* * 
*
Write a query to print the pattern P(20) e.g. to draw a traingle.

SOLUTION-

WITH RECURSIVE PATTERN(N) AS (		-- 20 19
SELECT 20						-- Starts with 20 rows
UNION ALL
SELECT (N-1) FROM PATTERN		-- Recursive step: Decrease by 1
WHERE N > 1
)
SELECT REPEAT('* ', N) FROM PATTERN

e.g. 2.
P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):
* 
* * 
* * * 
* * * * 
* * * * *
Write a query to print the pattern P(20).

solution-

with recursive pattern(n) as (
select 1 
union all
select n + 1 from pattern
where n < 20
)

select repeat("* ", n) from pattern

e.g. 4.
print all the prime numbers less than or equal to 1000. 
Print your result on a single line, and use the ampersand (&) character as your separator (instead of a space).

soln-

WITH RECURSIVE NUM (N) AS (
SELECT 2
UNION ALL
SELECT N + 1 FROM NUM
WHERE N < 1000 ),

PRIMES AS (
SELECT N FROM NUM
WHERE NOT EXISTS (SELECT 1 FROM NUM AS FACTORS 
			      WHERE FACTORS.N < NUM.N AND NUM.N % FACTORS.N = 0)
 )
SELECT GROUP_CONCAT( N ORDER BY N SEPARATOR '&') AS Prime FROM PRIMES

e.g. 4.
print all the composite numbers less than or equal to 1000. 
Print your result on a single line, and use the space ( ) character as your separator (instead of a space).

soln-

WITH RECURSIVE NUM (N) AS (
SELECT 2
UNION ALL
SELECT N + 1 FROM NUM
WHERE N < 1000 ),

COMPOSITE AS (
SELECT N FROM NUM
WHERE EXISTS (SELECT 1 FROM NUM AS FACTORS 
			      WHERE FACTORS.N < NUM.N AND NUM.N % FACTORS.N = 0)
 )
SELECT GROUP_CONCAT( N ORDER BY N SEPARATOR ' ') AS Composite FROM COMPOSITE

-- How to insert a date table with auto increment?
DROP TABLE date_table;

CREATE TABLE date_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_value DATE NOT NULL
);

WITH RECURSIVE date_series AS (
    SELECT DATE('2024-01-01') AS date_value
    UNION ALL
    SELECT DATE_ADD(date_value, INTERVAL 1 DAY)
    FROM date_series
    WHERE date_value < '2024-12-31'
)
#INSERT INTO date_table (date_value)
SELECT date_value FROM date_series;

select * from date_table;