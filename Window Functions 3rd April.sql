IPL matches

Team1, Team2, Winner
RCB,   CSK.    RCB
CSK.    MI.     MI
KKR.   RCB.     RCB
KKR.   DC.      DC
PBKS.   RR.     NONE


teams, # of wins, # of losses, # of draws, #draws/#wins
RCB.       2       0              0.        0/2
KKR.     0          2.          0.           0


-----------------------------------------------------

#Window Functions
SUM,Min, max, count, avg


select * from sales_sample


#find the dates where salesperson are having more salesamount 
#than the average sales amount of that salesperson

WITH mean_amount_person_agg as
(select *, AVG(SaleAmount) over(partition by salesperson) as mean_amount_person
from sales_sample)

select * from mean_amount_person_agg
where saleamount > mean_amount_person







-------------------------------------------------------


#find the sales date on which the 2nd highest sales amount occured using row_number



WITH row_numbered_data as
(select *, row_number() over(order by saleamount desc, saledate desc) as rn
 from
sales_sample)

select saledate,saleamount, rn
from row_numbered_data
where rn <=5














