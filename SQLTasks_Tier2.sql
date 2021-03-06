/* QUESTIONS

/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name
FROM 
	Facilities
WHERE
	membercost != 0

/* Result:
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court
*/

/* Q2: How many facilities do not charge a fee to members? */
SELECT 
	count(*) as Quantity
FROM 
	Facilities
WHERE 
	membercost = 0

/* Result:
4
*/

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT 
	facid, name, membercost, monthlymaintenance
FROM 
	Facilities
WHERE 
	membercost != 0 AND
	membercost < (monthlymaintenance * 20 / 100)

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT 
	*
FROM 
	Facilities
WHERE 
	facid in (1,5)

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT 
	name, monthlymaintenance, 
	CASE WHEN monthlymaintenance >= 100 then 'expensive'
		   ELSE 'cheap' END AS label
FROM 
	Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT 
	firstname, surname
FROM 
	Members
WHERE joindate = 
	    (SELECT MAX(joindate) FROM Members)

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT 
	DISTINCT f.name, CONCAT( m.firstname, ' ', m.surname ) AS membername
FROM 
	Bookings AS b
INNER JOIN 
	Facilities AS f ON f.facid = b.facid
INNER JOIN 
	Members AS m ON m.memid = b.memid
WHERE f.name LIKE 'Tennis%'
ORDER BY membername

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */


 Showing rows 0 - 11 (12 total, Query took 0.0031 sec)
SELECT 
	f.name, CONCAT( m.firstname, ' ', m.surname ) AS membername,
	CASE WHEN b.memid =0 THEN b.slots * f.guestcost
	ELSE b.slots * f.membercost
	END AS cost
FROM Bookings AS b
INNER JOIN Facilities AS f ON f.facid = b.facid
INNER JOIN Members AS m ON m.memid = b.memid
WHERE 
	DATE( b.starttime ) = '2012-09-14' AND 
	((b.memid = 0 AND (b.slots * f.guestcost) >30) OR 
	 (b.memid !=0 AND (b.slots * f.membercost) >30))
ORDER BY cost

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT 
	f.name, 
	(SELECT CONCAT( m.firstname, ' ', m.surname )
	 FROM Members AS m 
     	 WHERE m.memid = b.memid) as name, 
	CASE WHEN b.memid =0 THEN b.slots * f.guestcost
		ELSE b.slots * f.membercost END AS cost
FROM Bookings AS b
INNER JOIN Facilities AS f ON f.facid = b.facid
WHERE 
	DATE( b.starttime ) = '2012-09-14' AND 
	((b.memid = 0 AND (b.slots * f.guestcost) >30) OR 
	 (b.memid !=0 AND (b.slots * f.membercost) >30))
ORDER BY cost
