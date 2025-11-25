															https://www.w3schools.com/mysql/mysql_datatypes.asp
Data Type Description

String Data Types:
1. CHAR(size) A FIXED length string (can contain letters, numbers, and special characters). The
size parameter specifies the column length in characters - can be from 0 to 255.
Uses: Best used for storing data that has a consistent length, such as abbreviations,
country codes, postal codes, or other standardized data.

2. VARCHAR(size) A VARIABLE length string (can contain letters, numbers, and special characters).
The size parameter specifies the maximum column length in characters - can be
from 0 to 65535.
Uses: Ideal for storing strings where the length can vary significantly, such as
names, addresses, and descriptions.

3. TEXT(size) Holds a string with a maximum length of 65,535 bytes.
Uses: Suitable for storing large texts such as articles, emails, or content of books
where the length exceeds the limits of VARCHAR.

4. BLOB(size) For BLOBs (Binary Large Objects). Holds up to 65,535 bytes of data.
Uses: Used for storing binary data such as images, audio files, video files, and
other multimedia formats.

5. VARBINARY(size) Equal to VARCHAR(), but stores binary byte strings. The size parameter specifies
the maximum column length in bytes.
Uses: Commonly used to store files directly in the database, such as PDF
documents, Word documents, or executable files.

6. ENUM(val1, val2, val3, ...)	A string object that can have only one value, chosen from a list of possible values. 
You can list up to 65535 values in an ENUM list. If a value is inserted that is not in the list, a blank value will be inserted. 
The values are sorted in the order you enter them.
e.g. if the values are entered in the order ENUM('Y', 'N') then the value allocated to 'Y' = 1 and 'N' = 2 and not in the order 
of their ASCII value which is 78 for 'N' and 89 for 'Y', therefore 'Y' < 'N' → TRUE or 'Y' is "lower" than 'N' in this particular case.


Numeric Data Types:
1. INT(size) A medium integer. The signed range is from -2147483648 to 2147483647. The
unsigned range is from 0 to 4294967295. The size parameter specifies the maximum
display width (which is 255)
Uses: Ideal for storing data that represent counts, such as the number of users, posts,
or transactions, where fractional numbers are not applicable.

2. BIGINT(Size) A large integer. The size parameter specifies the maximum display width (which is
255)
Uses: Useful in scenarios involving very high counts, such as counting the number of
interactions on a high-traffic website or application.

2. Numeric (size, d) The NUMERIC data type in SQL is a highly precise data type used primarily for
storing numbers with fixed precision and scale. The total number of digits is specified
in size. The number of decimal digits specified in d.
Uses: NUMERIC is favored in any scenario where the exactness of decimal numbers
is crucial and where rounding errors cannot be tolerated.

2. FLOAT(p) A floating point number. MySQL uses the p value to determine whether to use FLOAT
or DOUBLE for the resulting data type. If p is from 0 to 24, the data type becomes
FLOAT().
Uses: Suitable for scientific calculations where the exact precision is less critical than
the ability to represent numbers in a large range.

3. DECIMAL(size, d) An exact fixed-point number. The total number of digits is specified in size. The
number of digits after the decimal point is specified in the d parameter. The maximum
number for size is 65. The maximum number for d is 30. The default value for size is 10.
Uses: Predominantly used in financial and accounting applications where precision in
calculations like currency operations is mandatory.

4. DOUBLE (size, d) A normal-size floating point number. The total number of digits is specified in size.
The number of digits after the decimal point is specified in the d parameter.

Date Data types:
1. DATE A date. Format: YYYY-MM-DD. The supported range is from '1000-01-01' to
'9999-12-31'

2. DATETIME A date and time combination. Format: YYYY-MM-DD hh: mm: ss. The supported range
is from '1000-01-01 00:00:00' to '9999-12-31 23:59:59'.

3. TIMESTAMP The TIMESTAMP values are stored as the number of seconds since the Unix epoch
('1970-01-01 00:00:00' UTC). Format: YYYY-MM-DD hh:mm:ss.

3. YEAR A year in four-digit format. Values allowed in four-digit format: 1901 to 2155, and 0000.