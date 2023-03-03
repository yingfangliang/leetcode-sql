# 175. Combine Two Tables
SELECT P.firstname, P.lastname, A.city, A.state
FROM Person P
LEFT JOIN Address A
ON P.personId = A.personId

# 181. Employees Earning More Than Their Managers
SELECT ename AS Employee
FROM
(SELECT E.name AS ename, E.salary AS esalary, M.salary AS msalary
FROM Employee E, Employee M
WHERE E.managerId = M.id) AS tmp
WHERE esalary > msalary

# 182. Duplicate Emails
SELECT email AS Email
FROM
(SELECT COUNT(*) AS count, email
FROM Person
GROUP BY email) AS tmp
WHERE count > 1

# 183. Customers Who Never Order
SELECT name AS Customers
FROM Customers
WHERE id NOT IN (SELECT DISTINCT customerId FROM Orders)

# 196. Delete Duplicate Emails
DELETE FROM Person
WHERE id NOT IN 
(SELECT mid 
FROM
(SELECT MIN(id) AS mid
FROM Person
GROUP BY email) AS tmp)

# 197. Rising Temperature
SELECT today.id AS Id
FROM Weather today
LEFT JOIN Weather yesterday
ON DATEDIFF(today.recordDate,yesterday.recordDate) = 1
WHERE today.temperature > yesterday.temperature

# 511. Game Play Analysis I
SELECT player_id, MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id

# 584. Find Customer Referee
SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL

# 586. Customer Placing the Largest Number of Orders
SELECT customer_number
FROM(
SELECT COUNT(*) AS count, customer_number
FROM Orders
GROUP BY customer_number) AS tmp
WHERE count =(SELECT MAX(count) FROM
(
SELECT COUNT(*) AS count, customer_number
FROM Orders
GROUP BY customer_number) AS tmpp
)

# 595. Big Countries
SELECT name, population, area
FROM World
WHERE population >= 25000000 OR area >= 3000000

# 596. Classes More Than 5 Students
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5

# 607. Sales Person
SELECT name
FROM SalesPerson
WHERE sales_id NOT IN (
SELECT DISTINCT s.sales_id
FROM SalesPerson s, Company c, Orders o
WHERE s.sales_id = o.sales_id AND c.com_id = o.com_id
AND c.name = "RED")

# 620. Not Boring Movies
SELECT * FROM Cinema
WHERE description NOT LIKE "%boring%" AND
mod(id,2) = 1
ORDER BY rating DESC

# 627. Swap Salary
UPDATE Salary 
SET sex = CASE 
            WHEN sex = 'f' THEN 'm' ELSE 'f' 
            END 