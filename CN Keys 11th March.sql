#constraints

CREATE TABLE USERS (
ID INT NOT NULL,
Name Varchar(200) NOT NULL)

DESC USERS;


CREATE TABLE students (
ID INT PRIMARY KEY,
Name Varchar(200))

DESC students;

customers ---> customerkey
Primary key refers to a column or multiple columns which have unique values and are non null


CUSTOMERS
ID,  NAME, AGE
1    A     30
1    A     35
2    C     35
3    D     40
3    E     40

NAME + AGE  --> CK  ---> Composite CK,  CK = candidate keys
NAME  + AGE ---> PK ---> Composite PK,  PK = primary keys






students  
student_id



		
     
18-100


Candidate keys ---> Name, Age
Primary key ---> Name


Every candidate key will become a primary key?
No
Every pk will be a ck?
YES


DESC products;


products      SUBCATEGORY   CATEGORY
SONY TV 1      TV              ELE
SONT TV 2  	   TV              ELE
SONY TV 3      TV              ELE


Category ---> Subcategory ---> Products
Electronics ---> TV        ---> SONY TV 1
                 AC
Alter table products
add primary key (ProductKey)

DESC products;

#Composite keys

demographics
Aadhar ID


email id ---> pk ---> level 

table1 ---> emails
PK ----> email id
email id, cust id
A1           1
A2           1

JOINS


table2
cust_id



DESC products


ALTER TABLE products
ADD PRIMARY KEY (ID, NAME)

ALTER table customers
MODIFY customerkey INT PRIMARY KEY


#FOREIGN KEYS 

users                                 orders                                             emails
user_id, name, email_id             user_id, order_id, sales, email_id                   phone_number, email_id, country, age


users  --> orders

users ---> emails
orders ---> emails


CREATE TABLE Users5 (
    user_id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    order_id INT,
	FOREIGN KEY(order_id) REFERENCES Orders5(order_id)
);

CREATE TABLE Orders5 (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    FOREIGN KEY(user_id) REFERENCES Users5(user_id)
);

emails





users
uid, name


JOIN ---> DATA TYPES SHOULD BE SAME
DEFINGING A FK ---> 

MYSQL----> data types should be same

orders
id
name
foreign key (id,name) references users(uid, name)



desc users5;
desc orders5

FOREIGN KEY ---> REFERS TO A COLUMN OR A GROUP OF COLUMNS WHICH REFERENCES TO PK OF FOREIGN TABLE
Entity Relationship 




CREATE TABLE Users5 (
    user_id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255)
    );

INSERT INTO users5
VALUES (1, "C1","abc@gmail.com")

INSERT INTO users5
VALUES (1, "C2","xyz@gmail.com")

select * from users5


insert 
DESC users5




select * from users5


ID,   NAME
1      A
2      A
3      B
4      C

ID, NAME, (ID+NAME)








ALTER TABLE users
ADD CONSTRAINT primary key (ID, Name)

create table class
(student_id int,
course_id int,
PRIMARY KEY (student_id, course_id)
)


DESC class











CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,    -- fk references to customers
    product_id INT,     -- fk references to  products
    order_date DATE,
    FOREIGN KEY (customer_id) references customers(customer_id),
    FOREIGN KEY (product_id) references products(product_id)

);



CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,    -- fk references to customers
    product_id INT,     -- fk references to  products
    order_date DATE,
    quantity INT,
    unit_price DECIMAL(5,2),
    CONSTRAINT check_positive_revenue CHECK (quantity*unit_price > 0)
    )
    
DESC Orders

qty - 

up -


CREATE TABLE customers(
age int check_age check (age>18)
)



ALTER TABLE customers
ADD CONSTRAINT check_age CHECK (age>18)

INSERT INTO customers(order_id, user_id)
VALUES (100, "C1")

ALTER TABLE customers
MODIFY age int DEFAULT 18

amount_withdrawn < bank_balance


#Entity Relationship Diagrams (ER Digrams)


create an erd diagram of 10 tables