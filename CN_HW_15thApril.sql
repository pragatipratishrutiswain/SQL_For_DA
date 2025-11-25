-No clarification is needed or should be given for any of the questions.
Question 1: [by Amazon]
Imagine a table named “Movies” with columns: MovieID, Title, ReleaseDate, GenreID.
There’s another table “Genres” with columns: GenreID, GenreName.
Write a SQL query to fetch the genres that don’t have any movies associated with them.

with cte as
( select GenreID, GenreName
  from Genres g
  left join Movies m 
	on g.GenreID = m.GenreID
)
select * from cte
where 
	GenreID not in
		(select GenreID from Movies)

Question 2: [by Meta]
You are given a table named “Attendance” with columns: StudentID, ClassDate, IsPresent -
(A Boolean where ‘True’ indicates presence and ‘False’ indicates absence).
Write a SQL query to identify students who have missed more than 3 consecutive classes.

With cte as (
	SELECT
	StudentID,
	ClassDate,
	IsPresent,
	ROW_NUMBER() OVER (PARTITION BY StudentID ORDER BY ClassDate) -
	ROW_NUMBER() OVER (PARTITION BY StudentID, IsPresent ORDER BY ClassDate)
	AS ConsecutiveGroup
	FROM
	Attendance )
SELECT DISTINCT StudentID
FROM cte
WHERE IsPresent = FALSE
GROUP BY StudentID, ConsecutiveGroup
HAVING COUNT (*) > 3;

/*
StudentID	ClassDate	IsPresent	rn	rn_False	grp
101			2023-01-01	FALSE		1	1			0
101			2023-01-02	FALSE		2	2			0
101			2023-01-03	FALSE		3	3			0
101			2023-01-04	TRUE		4	1			3
101			2023-01-05	FALSE		5	4			1
102			2023-01-01	FALSE		1	1			0
102			2023-01-02	FALSE		2	2			0
*/


Question 3: [by Airbnb]
Consider a table named “Elections” with columns: CandidateID, VoterID, VoteDate. Write a SQL query to calculate the candidate who 
received the highest number of votes each month.

with cte as 
(select CandidateID, month, count(VoterID) as vote_cnt
from cte 
group by 1, 2
order by 2)

select *, row_number() over(partition by CandidateID, month order by vote_cnt desc) as rank_can_ID
from cte
where rank() over(partition by CandidateID, month order by vote_cnt desc) = 1
order by rank_can_ID;


Question 4: [Unknown]
You are provided with a table named “LibraryBooks” with columns: BookID, BorrowerID, BorrowDate, Due_ReturnDate, ReturnDate.
Write a SQL query to find out which books are currently borrowed and have passed their return date without being returned.

select BookID, BorrowerID
from LibraryBooks
where 
		DateDiff( Due_ReturnDate, ReturnDate) < 0
    or
		(DateDiff( Due_ReturnDate, ReturnDate) is Null And Due_ReturnDate < current_date)

Question 5: [Unknown]
Consider a table named “OnlineCourses” with columns: CourseID, EnrollmentDate, StudentID, CompletionDate. Write a SQL query to 
determine the courses which have the highest drop rate (i.e., students enrolling but not completing).

select 
	CourseID, 
    count(EnrollmentDate) as cnt_enrolled, 
    count(CompletionDate) as cnt_completed,
    count(CompletionDate) /(count(EnrollmentDate) as ratio
from OnlineCourses
group by CourseID
order by ratio asc
limit 1
---------------------------------------

WITH cte AS (
    SELECT 
        CourseID, 
        COUNT(CASE WHEN EnrollmentDate IS NOT NULL THEN StudentID END) AS cnt_enrolled, 
        COUNT(CASE WHEN CompletionDate IS NULL THEN StudentID END) AS cnt_incomplete
    FROM OnlineCourses
    GROUP BY CourseID
)

SELECT 
    CourseID, 
    CAST(cnt_incomplete AS FLOAT) / NULLIF(cnt_enrolled, 0) AS drop_rate
FROM cte
ORDER BY drop_rate DESC
LIMIT 1;


Question 6: [by Oracle]
You have a table named “EmployeeFeedback” with columns: EmployeeID, FeedbackDate, Rating (from 1 to 10). 
Write a SQL query to identify employees whose rating has been declining for the past 3 consecutive feedbacks.

with 
	t as
		(select 
			EmployeeID,
            FeedbackDate,
			Rating,
			lead(Rating) over(partition by EmployeeID order by FeedbackDate) as next_rating,
            lead(Rating, 2) over(partition by EmployeeID order by FeedbackDate) as nxt_to_nxt_rating
		 from EmployeeFeedback
		 order by 1)
select distinct EmployeeID 
from t where 
	Rating > next_rating and next_rating > nxt_to_nxt_rating


Question 7: [by Medium]
There are two tables: “BlogPosts” and “Comments”. 
The “BlogPosts” table has columns: PostID, Title, PostDate, AuthorID.
The “Comments” table has columns: CommentID, PostID, CommentDate, CommentText.
Write a SQL query to fetch the blog posts that have not received any comments within a week of their posting.

with cte as
(	select PostID, PostDate, CommentID, CommentDate, 
	Date_add(PostDate, interval 7 day) as 8th_day_date,
    Dense_Rank() over(partition by PostID order by CommentDate) as rnkcmt
	from BlogPosts b
	left join Comments c on b.PostID = c.PostID 
	order by PostID
)
select PostID, PostDate, CommentDate
from cte 
where 
rnkcmt = 1 AND
PostID 
	not in
		(select PostID
		 from cte
		 where CommentDate < 8th_day_date)
------------------------------------------


postID		postdate		commentdate	 commentID	Rnkcmt  8th_Day			Status
A			01-01-2020		01-01-2020		1		1		08-01-2020		N
A			01-01-2020		01-01-2020		2		1		08-01-2020		N
A			01-01-2020		09-01-2020		6		2		08-01-2020		N
A			01-01-2020		09-01-2020		7		2		08-01-2020		N
B			01-01-2020		08-01-2020		1		1		08-01-2020		Y
B			01-01-2020		09-01-2020		2		2		08-01-2020		Y
B			01-01-2020		09-01-2020		3		2		08-01-2020		Y
B			01-01-2020		09-01-2020		4		2		08-01-2020		Y

where rank = 1 and commentdate < 8th_Day

Question 8: [by Expedia]
Consider a table named “TouristSpots” with columns: SpotID, SpotName, VisitorID, VisitDate. 
Write a SQL query to find the least visited tourist spots in the last summer.

select 
	spotID, 
	SpotName, 
    count(VisitorID) as visitor_count
from TouristSpots
where 
	Month(VisitDate) in(6,7,8) 	# june, july and august
    and 
    year(VisitDate) = Year(current_date)	# summer of this year if exists in data = last summer
group by 1, 2, 3
order by visitor_count
limit 1

Question 9: [by Amazon]
There are two tables: “Books” and “Authors”.
The “Books” table has columns: BookID, BookName, AuthorID, SoldCopies. The “Authors” table has columns: AuthorID, AuthorName.
Write a SQL query to find authors whose books, on average, have sold more than 10,000 copies, but have written less than 3 books.

select a.AuthorID, AuthorName, count(BookID) as bookcnt, avg(SoldCopies) as avgsoldcopies
from Authors a
left join Books b on a.AuthorID = b.AuthorID
group by 1, 2
having avgsoldcopies > 1000 and bookcnt < 3

Question 10: [by Booking.com]
You have a table named “FlightBookings” with columns: BookingID, FlightDate, PassengerID, Destination.
Write a SQL query to determine which destination has seen a steady month-on-month increase in bookings over the last year.

with 
	cte as
		(select 
			Destination, 
			Date_format(FlightDate, '%Y-%m') as booking_year_month,
			count(BookingID) as cnt_bookings,
			lag(count(BookingID)) over( partition by Destination order by month(FlightDate)) as cnt_prv_booking,
			lead(count(BookingID)) over( partition by Destination order by month(FlightDate)) as cnt_nxt_booking
		 from FlightBookings where
			FlightDate >= CURRENT_DATE - INTERVAL 1 YEAR
		 group by 1, 2
		 order by booking_year_month
		)
select Destination
from cte where
	cnt_prv_booking < cnt_booking and cnt_booking < cnt_nxt_booking

