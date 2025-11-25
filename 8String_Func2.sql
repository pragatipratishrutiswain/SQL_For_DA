# REVERSE
# REPLACE
# SUBSTRING
# INSTR
# LOCATE

USE cn_3;

1. REVERSE
select phone_number, reverse(phone_number) from customers

select * from Products

#Findout the reverse of the last 5 digits of every phonenumber
select phone_number, reverse(right(phone_number,5)) from customers

2.REPLACE
select replace('ABCDEF',"BCD","XYZ") 
select replace('A*B*C*D*E*F',"*","##")

#display "N/A" instead of 0 in productstyle column
select productstyle from products
select distinct(replace (productstyle, 0, 'N/A')) from products

#display $90,000 as $90K in annualincome column
select annualincome, concat(substring_index(annualincome,',', 1),'K') from customers
where not annualincome = ''

or better approach

select annualincome, 
replace(annualincome, right(TRIM(annualincome), 4),'K') as annualincome_new from customers

--------------------------------------------------

Update customers
set annualincome = replace(replace(annualincome,'$',''),',','');

alter table customers
modify annualincome int;
Error Code: 1366. Incorrect integer value: '' for column 'annualincome' at row 4

#mysql ----> cannot convert empty string into an empty integer, so error comes

Update customers
set annualincome = null
where annualincome = 0

select * from customers

3.SUBSTRING --------> MID dunction in excel

select modelname from products #SKU -- stock keeping units, different variance of a same product based on color or size etc

#return 2nd, 3rd and 4th characters from every row
#sport ---> por, mountain ---> oun

select modelname, substring(modelname,2,3) from products

4.INSTR -- in string similar to find() in excel, 
# returns the position of first occurence of a char or a string from the leftside
# INSTR(str, substr) → syntax is (where, what)

select emailaddress , instr(emailaddress, 'o') from customers
select instr('dfadf@gmail.com','@')+1  	#7
select instr('dfadf@gmail.com','@')-1	#5
select instr('dfadf@gmail.com','.')		#12

5. LOCATE() -- also similar to find() in excel,
# returns the position of first occurence of a char or a string from the leftside
# LOCATE(substr, str) → syntax is (what, where)

SELECT LOCATE('world', 'hello world');  -- 7

🔹 Difference between LOCATE() and INSTR()
LOCATE(substr, str) → syntax is (what, where)
INSTR(str, substr) → syntax is (where, what)

SELECT LOCATE('world', 'hello world');  -- 7
SELECT INSTR('hello world', 'world');   -- 7
-- ----------------------------------------

select substring('dfadf@gmail.com', 7, 12-6-1)

select substring_index('dfadf@gmail.com','@',-1)
select substring_index('dfadf@gmail.com','.',1)

select substring_index(substring_index('dfadf@gmail.com','@',-1),'.',1)
or
select substring('dfadf@gmail.com',instr('dfadf@gmail.com','@')+1,instr('dfadf@gmail.com','.')-instr('dfadf@gmail.com','@')-1)


