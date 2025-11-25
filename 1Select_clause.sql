SELECT * FROM customers;

SELECT EmailAddress FROM customers;

SELECT Gender FROM customers;

# print all the columns for those who have more than 3 children
SELECT * FROM customers
WHERE Totalchildren > 3 ;

#display the email address for females
SELECT EmailAddress FROM customers
WHERE Gender = 'F';

#display first name and last name of those customers who do not have 5 children
SELECT Firstname, LastName, TotalChildren FROM customers
WHERE TotalChildren != 5 	;# not equal to can be != or <> 

#1. Find all the details of those customers who have a bachelors degree and working as Professional
SELECT * FROM customers
WHERE EducationLevel =  'Bachelors' AND Occupation = 'Professional';

#2. Find the customers who are married and do not have any kids
SELECT * FROM customers
WHERE  MaritalStatus = 'M' AND TotalChildren = 0;

#3. Find the customers with 0 children and homeowners
SELECT * FROM customers
WHERE TotalChildren = 0 AND HomeOwner = 'Y';

#4. Find the customers who are not homeowners
SELECT * FROM customers
WHERE HomeOwner != 'Y' 	;	# or use NOT keyword
SELECT * FROM customers
WHERE NOT HomeOwner = 'Y';	# or use NOT IN keyword
SELECT * FROM customers
WHERE HomeOwner NOT IN ('Y');

#Find those customers who have either 0,2,3 or 6 children
SELECT * FROM customers
#PSEUDO-CODE ---- WHERE TotalChildren = 0 or TotalChildren = 2 or TotalChildren = 3 or TotalChildren = 6
WHERE TotalChildren IN (0,2,3,6);

#Find those customers who have >2 children and < 5 children
SELECT * FROM customers
#PSEUDO-CODE 
#WHERE TotalChildren > 2 and TotalChildren< 5
#WHERE TotalChildren IN (3,4)
WHERE TotalChildren BETWEEN 3 AND 4;
#NOTE
#WHERE TotalChildren BETWEEN 2 AND 5 ---is incorrect because that is inclusive of 2 and 5 
#Assume if the values btw 2 and 5 were like 2.4, 2.5, 3.6, 4.8 then the code would be
#WHERE TotalChildren BETWEEN 2.0001 AND 4.9999

