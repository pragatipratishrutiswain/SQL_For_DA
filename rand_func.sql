select RAND(); #(floating value between 0 to 1 (exclusive))

ALTER TABLE ppsdb.sales 
DROP COLUMN random_numbers;
alter table ppsdb.sales
add column random_numbers float;
update ppsdb.sales
set random_numbers = CEILING(RAND() * 10);
select * from ppsdb.sales;
