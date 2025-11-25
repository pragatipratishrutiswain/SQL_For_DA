Value		Description
DATE		Converts value to DATE. Format: "YYYY-MM-DD"
DATETIME	Converts value to DATETIME. Format: "YYYY-MM-DD HH:MM:SS"
DECIMAL		Converts value to DECIMAL. Use the optional M and D parameters to specify the maximum number of 
			digits (M) and the number of digits following the decimal point (D).
TIME		Converts value to TIME. Format: "HH:MM:SS"
CHAR		Converts value to CHAR (a fixed length string)
NCHAR		Converts value to NCHAR (like CHAR, but produces a string with the national character set)
SIGNED		Converts value to SIGNED (a signed 64-bit integer) (Can store both positive and negative values, including zero.)
UNSIGNED	Converts value to UNSIGNED (an unsigned 64-bit integer) (Can only store non-negative values (zero and positive numbers).)
BINARY		Converts value to BINARY (a binary string)

Convert a value to a DATE datatype:
SELECT CAST("2017-08-29" AS DATE);

SELECT CAST('1' AS UNSIGNED);