# A regular expression or REGEXP() is a powerful way of specifying a pattern for a complex search; often useful while cleaning the data.

SELECT
	column_list
FROM 
	table_name
WHERE
	string_column REGEXP pattern;
    
# Metacharacter Behaviour
/*
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
*/
-- ------------------------------------------------
CREATE DATABASE regular_expressions;

USE regular_expressions;

DROP TABLE IF EXISTS user_info;

CREATE TABLE user_info (
Name VARCHAR(50),
Phone_Number VARCHAR(20),
EmailAddress VARCHAR(20),
Gender CHAR(5),
City VARCHAR(30),
Country VARCHAR(20),
Country_Code INT
);

INSERT INTO user_info 
(Name, Phone_Number, EmailAddress, Gender, City, Country, Country_Code)
VALUES
('Alice Johnson', '+1 (987) 654-3210', 'alice.j@ex.com', 'F', 'New York', 'USA', 1),
('Bob Smith', '+1 (876) 543-2109', 'bob.s@ex.com', 'M', 'Los Angeles', 'USA', 1),
('Charlie Brown', '+1 (765) 432-1098', 'charlie.b@ex.com', 'O', 'Chicago', 'USA', 1),
('12!*() $#89%@', '+1 (658) 344-8732', '12!*().$@ex.com', 'F', 'Ontario', 'Canada', 1),
('Diana Prince', '+44 (654) 321@-0987', 'diana.p@ex.com', 'F', 'London', 'UK', 44),
('Edward Green', '+44 (543) 210$- 9876', 'edward.g@ex.com', 'M', 'Manchester', 'UK', 44),
('Fatima Khan', '+91 (432) 109-8765', 'fatima.k@ex.com', 'F', 'Mumbai', 'India', 91),
('George Lee', '+86 (321) 098-7654', 'george.l@ex.com', 'M', 'Beijing', 'China', 86),
('Hannah White', '+61 (210) 987--6543', 'hannah.w@ex.com', 'F', 'Sydney', 'Australia', 61),
('Ivan Petrov', '+7 (109) 876-5432', 'ivan.p@ex.com', 'M', 'Moscow', 'Russia', 7),
('Liv@#an Pestr$$ov', '+7 (909) 656-5232', 'livan.p@ex.com', 'M', 'Moscow', 'Russia', 7),
('!*() $#%@', '+86 (298) 134-8632', '!*().$@ex.com', 'O', 'Omsk', 'Russia', 7),
('Julia Silva', '+55 (998) 8776*655', 'julia.s@ex.com', 'O', 'São Paulo', 'Brazil', 55),
('Dow Silva', '+55 (921) 7376_642', 'dow.s@ex.com', 'M', 'Recife', 'Brazil', 55),
('Racy Chhapra0', '+91 (966) 8326*655', 'racy.c@ex.com', 'F', 'New Delhi', 'India', 91),
('Rahul@ Batra0', '+91 (891) 4321*785', 'rahul.b@ex.com', 'M', 'Champaran', 'India', 91),
('Cookie', '+91 (657) 1234^342', 'cookie@ex.com', 'F', 'Indore', 'India', 91);

SELECT * FROM user_info;

-- 1. Compare the Phone_Number column with a New_Phone_Number column that removes the country code from the Phone_Number column.
-- 2. Show the CountryCode with + sign in a separate column.
-- 3. Remove all the special characters (" ", "@", "(", ")" etc) from New_Phone_Number column. Use REGEXP() to create a Formatted_Ph.
WITH CTE AS (
	SELECT 
		Phone_Number,
		LENGTH(Phone_Number) AS Len_Phone_Number,
		SUBSTRING(Phone_Number, LOCATE(' ', Phone_Number) + 1) AS New_Phone_Number,
		LENGTH(SUBSTRING(Phone_Number, LOCATE(' ', Phone_Number) + 1)) AS Len_New_Phone_Number,
		SUBSTRING_INDEX(Phone_Number, " ", 1) AS CountryCode
	FROM user_info
)
SELECT Phone_Number, New_Phone_Number, CountryCode
FROM CTE;

-- 4. Select all the names that end with the letter n.
SELECT Name FROM user_info
WHERE Name REGEXP 'n$';

-- 5. Select all the names which start with the letter A.
SELECT Name FROM user_info
WHERE Name REGEXP '^a|^A';

-- 6. 
-- a. Select all the names which contain letters e,r,g in them in any order.
SELECT Name
FROM user_info
WHERE Name REGEXP '(?=.*e)(?=.*r)(?=.*g)';
-- OR --
SELECT Name FROM user_info
WHERE Name REGEXP 'e'
  AND Name REGEXP 'r'
  AND Name REGEXP 'g';
-- b. Select all the names which contain letters e,o,r,g,e in them in the same order
SELECT Name
FROM user_info
WHERE Name REGEXP 'e.*o.*r.*g.*e';

-- 7. Find names containing double letters (like ee or ll)?
SELECT Name
FROM user_info
WHERE Name REGEXP '(.)\\1'; 		# (.) captures a character, \\1 repeats it

🔎 Explanation
(.)
. = any single character

( ) = capturing group → remember this character as Group 1

\1
A backreference → matches the exact same text that was captured in group 1

(.)\1 means: “Match any character, followed immediately by the same character again.” = Detects repeated/double characters.

\ is an escape character, so you need to double it → \\1.
Escape character - “Treat the next character in a special way, or interpret it differently than normal.”

SELECT 'letter' REGEXP '(.)\\1' AS rpt;

(.) captures a character.
\\1 → tells MySQL to send \1 to regex engine. Matches tt.

-- 8. How do I find names that contain either “son” or “silva”?
SELECT Name
FROM user_info
WHERE Name REGEXP 'son|silva';

-- 9. Find names with only alphabetic characters (no digits or symbols)?
SELECT Name
FROM user_info
WHERE Name REGEXP '^[A-Za-z ]+$';

-- 9. Find only those names which contain alphabetic characters and digits or symbols?
SELECT Name
FROM user_info
WHERE Name REGEXP '[A-Za-z]'      -- must contain a letter
  AND Name REGEXP '[^A-Za-z ]';   -- must contain something other than letters or space

-- 10. Find the names which contain atleast one special characters?
SELECT Name
FROM user_info
WHERE Name REGEXP '[^A-Za-z0-9 ]';   -- must contain something other than letters or space

-- 11. Find the names which contains no alphabet.
SELECT Name
FROM user_info
WHERE Name NOT REGEXP '[A-Za-z]';

-- 12. Find the names which contains no alphabet or digit.
SELECT Name
FROM user_info
WHERE Name NOT REGEXP '[A-Za-z0-9]';

-- 13. How do I find names with 2 words (first and last name)?
SELECT Name
FROM user_info
WHERE Name REGEXP '^[A-Za-z]+ [A-Za-z]+$';  	# Case insensitive
/*
^ Start of the string.

[A-Za-z]+
→ One or more (+) uppercase or lowercase letters.
→ This represents the first word.
(space) Exactly one space between the two words.

[A-Za-z]+
→ One or more letters again.
→ This represents the second word.

$ End of the string. 
*/

⚡ Key Difference
'^[A-Za-z]' → checks the first character of the string is a letter.
'[^A-Za-z]' → checks for any character in the string that is NOT a letter.
'[A^Z]' → Inside [] (but NOT at the beginning), Loses its special meaning → it’s just a literal.
