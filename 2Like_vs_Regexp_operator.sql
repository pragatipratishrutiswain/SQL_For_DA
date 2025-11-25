#LIKE operator

#Findout those firstname which starts with "S"
SELECT * FROM customers
WHERE FirstName LIKE 'S%';

#Wildcard operators % ----> 0 or more characters, _ ----> excatly 1 character

#Findout those firstname which starts with "S" and ends with "A"
SELECT * FROM customers
WHERE FirstName LIKE 'S%A';
#OR
SELECT * FROM customers
WHERE FirstName LIKE 'S%' AND FirstName LIKE '%A'; #---> Lengthy, so avoid

#Findout those firstname which have atleast 1 "A" in them
SELECT * FROM customers
WHERE FirstName LIKE "%A%";

#Findout those firstname which have first letter as J and 3rd letter as H 
SELECT * FROM customers
WHERE FirstName LIKE "J_H%";

#Findout those firstname which have 2nd letter as a and 5th letter as e
SELECT * FROM customers
WHERE FirstName LIKE "_A__E%";

#Findout those firstname which have 2nd letter as a and 5th letter as e
SELECT * FROM customers
WHERE FirstName LIKE "_A__E%";

#DISTINCT - Unique
SELECT DISTINCT TotalChildren FROM customers;
SELECT DISTINCT MaritalStatus FROM customers;
SELECT DISTINCT TotalChildren, MaritalStatus FROM customers; #Unique combinations
SELECT DISTINCT MaritalStatus, Gender FROM customers; #Unique combinations
SELECT DISTINCT MaritalStatus, Gender, HomeOwner FROM customers; #Unique combinations
SELECT DISTINCT AnnualIncome FROM customers;

#Sorting Data

#Sorting Data by customerskey in Asce order
SELECT * FROM customers
ORDER BY customerkey;

#Sorting Data by customerskey in desc order
SELECT * FROM customers
ORDER BY customerkey DESC;

#Sorting Data by firstname in desc order
#a-z ; asce
#z-a ; desc
SELECT * FROM customers
ORDER BY FirstName DESC;

#Sorting Data by totalchildren in desc order 
#in case there is a tie btw multiple rows having same totalchildren, 
#prioritize the row which has higher customerkey
SELECT * FROM customers
ORDER BY TotalChildren DESC, CustomerKey DESC;

-- find out those firstnames which contain both "a and e" letters and return the output 
-- sorted based on the totalchildren in ascending order, in case there is a tie, prioritize the one having lower alphabetical value
-- based on education level. If still there is a tie, use higher customerkey to break the tie
SELECT * FROM customers
WHERE FirstName LIKE '%a%e%' OR FirstName LIKE '%e%a%' 
ORDER BY TotalChildren, EducationLevel, CustomerKey DESC;


# Regular Expressions or REGEXP 
-- ----------------------------
/* https://dev.mysql.com/doc/refman/8.4/en/regexp.html */			# MySQL documentation
/* https://www.youtube.com/watch?v=PhTeFJAllcA */					# Video explanation
-- ----------
REGEXP (or RLIKE in some databases) is a powerful tool for pattern matching — more flexible than LIKE
A regular expression is a powerful way of specifying a pattern for a complex search.

CREATE TABLE STATION (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    CITY VARCHAR(21) NOT NULL,
    STATE CHAR(2) NOT NULL,
    LAT_N DECIMAL(9,6) CHECK (LAT_N BETWEEN -90 AND 90),
    LONG_W DECIMAL(9,6) CHECK (LONG_W BETWEEN -180 AND 180)
);

INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) 
VALUES 
	(1, 'New York', 'NY', 40.71, -74.01),
	(2, 'Los Angeles', 'CA', 34.05, -118.25),
	(3, 'Chicago', 'IL', 41.88, -87.63),
	(4, 'Houston', 'TX', 29.76, -95.37),
	(5, 'Phoenix', 'AZ', 33.45, -112.07),
	(6, 'Philadelphia', 'PA', 39.95, -75.16),
	(7, 'San Antonio', 'TX', 29.42, -98.49),
	(8, 'San Diego', 'CA', 32.71, -117.16),
	(9, 'Dallas', 'TX', 32.77, -96.79),
	(10, 'San Jose', 'CA', 37.33, -121.89),
	(11, 'Austin', 'TX', 30.26, -97.73),
	(12, 'Jacksonville', 'FL', 30.33, -81.65),
	(13, 'Fort Worth', 'TX', 32.75, -97.33),
	(14, 'Columbus', 'OH', 39.96, -83.00),
	(15, 'Charlotte', 'NC', 35.22, -80.84),
	(16, 'San Francisco', 'CA', 37.77, -122.42),
	(17, 'Indianapolis', 'IN', 39.77, -86.16),
	(18, 'Seattle', 'WA', 47.60, -122.33),
	(19, 'Denver', 'CO', 39.73, -104.99),
	(20, 'Boston', 'MA', 42.36, -71.06);

select * from station;

 1. Basic REGEXP Syntax
 
SELECT * FROM STATION  
WHERE city REGEXP '^[AEIOU]';

✅ Explanation:
^: Matches the start of the string.
[AEIOU]: Matches any of the uppercase vowels.
This returns cities that start with A, E, I, O, or U.

 2. Case-Insensitive Matching
If you want both uppercase and lowercase vowels:

SELECT * FROM STATION  
WHERE city REGEXP '^[AEIOUaeiou]';

Or even shorter (MySQL supports this):

SELECT * FROM STATION  
WHERE city REGEXP '^[aeiou]' COLLATE utf8mb4_general_ci;

✅ COLLATE utf8mb4_general_ci forces case-insensitive comparison.

3. Match Cities Ending with Vowels

SELECT DISTINCT city  
FROM STATION  
WHERE city REGEXP '[AEIOU]$';

✅ $: Matches the end of the string.

4. Match Cities with Vowels Anywhere (Contains a vowel)

SELECT DISTINCT city  
FROM STATION  
WHERE city REGEXP '[AEIOU]';

✅ This matches any city containing at least one vowel — anywhere in the name.

5. Match Cities with Exactly 5 Letters

SELECT city  
FROM STATION  
WHERE city REGEXP '^.{5}$';

✅ . means any character, and {5} ensures exactly 5 characters.

🔥 Bonus: Match Complex Patterns
Let’s say you want cities that start and end with a vowel:

SELECT city  
FROM STATION  
WHERE city REGEXP '^[AEIOU].*[AEIOU]$';

✅ This checks:

^[AEIOU]: Starts with a vowel.

.*: Allows anything in between (zero or more characters).

[AEIOU]$: Ends with a vowel.
-- -------------------------------------
# Metacharacter Behavioour

Pattern	What the Pattern matches
*	Zero or more instances of string preceding it
+	One or more instances of strings preceding it
.	Any single character
?	Match zero or one instances of the strings preceding it.
^	caret(^) matches Beginning of string
$	End of string
[abc]	Any character listed between the square brackets
[^abc]	Any character not listed between the square brackets
[A-Z]	match any upper case letter.
[a-z]	match any lower case letter
[0-9]	match any digit from 0 through to 9.
[[:<:]]	matches the beginning of words.
[[:>:]]	matches the end of words.
[:class:]	matches a character class i.e. [:alpha:] to match letters, [:space:] to match white space, 
			[:punct:] is match punctuations and [:upper:] for upper class letters.
p1|p2|p3	Alternation; matches any of the patterns p1, p2, or p3
{n}	Exactly n instances of preceding element
{m,n}	between m and n instances of preceding element






