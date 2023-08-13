-- 175. Combine Two Tables (JOIN)
SELECT p.firstName, p.lastName, a.city, a.state
FROM Person p
LEFT JOIN Address a
ON p.personId = a.personId; --USING (personId)

-- 181. Employees Earning More Than Their Managers (JOIN)
SELECT e.name AS Employee
FROM Employee e
LEFT JOIN Employee m
on e.managerId = m.id
WHERE e.salary > m.salary;

-- 182. Duplicate Emails (HAVING)
SELECT email
FROM Person p
GROUP BY email
HAVING COUNT(*) > 1;

-- 183. Customers Who Never Order (subquery)
SELECT name AS Customers
FROM Customers
WHERE id NOT IN (
  SELECT DISTINCT customerId
  FROM Orders
  );

-- *197. Rising Temperature (DATEDIFF())
SELECT tday.id
FROM Weather tday
LEFT JOIN Weather yday
ON DATEDIFF(tday.recordDate, yday.recordDate) = 1 -- DATEDIFF(today, yesterday) = 1
WHERE tday.temperature > yday.temperature;

-- 577. Employee Bonus (JOIN)
SELECT e.name, b.bonus
FROM Employee e
LEFT JOIN Bonus b
ON e.empId = b.empId
WHERE b.bonus < 1000 OR
      b.empId IS NULL;

-- *584. Find Customer Referee (<>, NULL, COALESCE())
SELECT name
FROM Customer
WHERE referee_id <> 2 OR
      referee_id IS NULL;

SELECT name
FROM Customer
WHERE COALESCE(referee_id, 0) <> 2;

-- 586. Customer Placing the Largest Number of Orders (subquery, CTE)
-- ORDER BY and LIMIT is not applicable since there might be multiple customers having max order numbers.
WITH cte AS (
  SELECT customer_number, COUNT(*) AS qty
  FROM Orders
  GROUP BY customer_number
)
SELECT customer_number
FROM cte
WHERE qty = (SELECT MAX(qty) FROM summary);

-- 595. Big Countries (OR)
SELECT name, population, area
FROM World
WHERE area >= 3000000 OR
      population >= 25000000;