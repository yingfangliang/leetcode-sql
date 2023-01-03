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