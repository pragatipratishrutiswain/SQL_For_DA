update customers
set full_name = concat(prefix, ' ', full_name)

String data Functions
1. Length
2. TRIM, LTRIM, RTRIM
3. CONCAT
4. CAST
5. SUBSTRING_INDEX
6. GROUP_CONCAT(name SEPARATOR ', ')

function name (col,parameters,...)

LENGTH
select emailaddress, LENGTH(emailaddress) as No_of_Char_email from customers

#which productname is the longest name?
select productname, LENGTH(productname) as Len from products
order by 2 desc # 1 = productname, 2 = Len
limit 4

#find the no of characters in the string "How are You?!"
select length("How are You?!")

select length('') #zero
select length(null) #unknown or null

TRIM
select Length(trim(' Hello '))
select trim(BOTH "a" From 'aaaaaaaHealloaaaaaaa')
select Length( LTRIM(" Hello   "))
select Length(RTRIM(" Hello   "))
select TRIM( both "A" FROM LTRIM(" AaHELLOAAAAAAA"))

CONCATENATE
select CONCAT(prefix,' ',FIRSTNAME,' ',LASTNAME) AS fullname from customers

#In customers table create a new column called full_name which shd be a combination of 
#firstname and lastname separated by a space
#Delete firstname and lastname columns from the table, verify the output

SELECT * FROM customers

alter table customers 
add full_name varchar(150) after lastname

update customers 
set full_name = concat(firstname, ' ',lastname)
select * from customers

alter table customers
drop column firstname;
alter table customers
drop column lastname 

select * from customers

add a new col in customers table which
shd give all values under it as 
"Customer: 10001"
"Customer: 10002"

alter table customers
add cust_id varchar(50);

update customers
set cust_id = concat("Customer:", customerkey)

select * from customers

CAST ---> converts one datatype to the other
select CAST(customerkey as char(30)) as customerKey from customers

desc customers

SUBSTRING_INDEX
#CREATE 2 Columns --> firstname, lastname from full name col
#Add these 2 cols afters prefix col

alter table customers
add firstname varchar(50) after prefix
alter table customers
add lastname varchar(50) after firstname

select * from customers

update customers
set firstname = substring_index(substring_index(full_name, ' ',2),' ',-1), lastname = substring_index(full_name, ' ',-1)

select substring_index(substring_index('Mr. Anna Hazare', ' ',2),' ',-1) as First_name, 
substring_index('Mr. Anna Hazare', ' ',-1) as Last_name

#Using mysql documentation only, figureout the meaning of the below query:
alter table customers
add column formatted_number varchar(50) 
after phone_number

update customers
set formatted_number = CONCAT ('(+91)',' ', LPAD(RIGHT(phone_number,10), 10, '0'));
select * from customers

select LPAD("khki87987", 10, '0') from customers

#Uppercase Lowercase
select UPPER('jsdjf')
select LOWER('FSAFDJ')

-----------------------------------------------------

alter table customers
add column Education_Occupation varchar(255)
after occupation;

select * from customers

update customers
set Education_Occupation = UPPER(concat(educationlevel,'_',occupation));

alter table customers
drop column EducationLevel;

alter table customers
drop column Occupation;

alter table customers
add column EducationLevel varchar(255)
after Education_Occupation;

alter table customers
add column Occupation varchar(255)
after EducationLevel;

update customers
set educationlevel = lower(substring_index(education_occupation,"_",1)),
	occupation = lower(substring_index(education_Occupation,"_",-1));

alter table customers
drop education_occupation;

select * from customers

#find the last 4 digits of the phone_number col with the phone_number col
select phone_number, right(phone_number,4) from customers

#mask remaining digits with * and show only the last 4 digits of the phone_number col with the phone_number col
select phone_number, lpad(right(phone_number,4),10,'*') as masked from customers

#mask all the remaining digits after the first 5 digits of 804804038532845 with #
select rpad(left(804804038532845,5), LENGTH(804804038532845),'#')


select distinct productcolor from products
# here "NA" here means a string not known

#Add a new column after productcolor to denote productcode which is a 3 upper char notation for every color: 
#For NA use "UNKNOWN" as the code, Red --> RED, White ---> WHI, Yellow ---> YEL

select * from products

alter table products
add productcode varchar(10) after productcolor

update products
set productcode = upper(left(productcolor,3)) 
where not productcolor = "NA"

update products
set productcode = upper('unknown') 
where productcolor = "NA"
