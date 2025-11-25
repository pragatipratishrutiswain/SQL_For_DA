Table-Level vs Column-Level Constraints in SQL
Constraints in SQL are rules enforced on table data to maintain integrity. They can be applied at two levels: Column-Level and Table-Level.

1️⃣ Column-Level Constraints
Defined inside the column definition.

Applied to a single column.

Suitable for constraints that affect only one column (e.g., NOT NULL, UNIQUE, CHECK).

Example
sql
Copy
Edit
CREATE TABLE PRODUCTS (
    ProductKey INT PRIMARY KEY,  -- Column-level PRIMARY KEY
    ProductName VARCHAR(100) NOT NULL,  -- Column-level NOT NULL
    Price DECIMAL(10,2) CHECK (Price > 0)  -- Column-level CHECK constraint
);
✅ When to use Column-Level Constraints?
When the constraint is applied to only one column.

Keeps the table definition concise and readable.

2️⃣ Table-Level Constraints
Defined after all columns are declared.

Can be applied to one or multiple columns.

Required when enforcing multi-column constraints (e.g., composite primary key, foreign key referencing multiple columns).

Example
sql
Copy
Edit
CREATE TABLE ORDERS (
    OrderID INT,
    ProductKey INT,
    CustomerID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductKey),  -- Table-level composite PRIMARY KEY
    FOREIGN KEY (ProductKey) REFERENCES PRODUCTS(ProductKey),  -- Table-level FOREIGN KEY
    CHECK (Quantity > 0)  -- Table-level CHECK constraint
);
✅ When to use Table-Level Constraints?
When defining constraints involving multiple columns.

For better organization when constraints are complex.

🔍 Key Differences
Feature	Column-Level Constraints	Table-Level Constraints
Definition Placement	Within a column definition	After all columns are declared
Scope	Affects only the column where defined	Can apply to one or more columns
Multi-Column Constraints	❌ Not possible	✅ Possible (e.g., composite primary keys)
Common Use Cases	NOT NULL, CHECK, UNIQUE, DEFAULT	PRIMARY KEY, FOREIGN KEY, multi-column CHECK

🚀 Quick Rule of Thumb
Use column-level constraints for single-column rules.

Use table-level constraints for multi-column dependencies.