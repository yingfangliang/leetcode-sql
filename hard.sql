-- 185. Department Top Three Salaries (DENSE_RANK())
SELECT 
    d.name AS "Department",
    e.name AS "Employee",
    e.salary AS Salary
FROM (
    SELECT 
        id, 
        name,
        salary,
        departmentId,
        DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS ranking
    FROM Employee) AS e
LEFT JOIN Department AS d
ON e.departmentId = d.id
WHERE e.ranking <= 3

-- 262. Trips and Users
SELECT 
    t.request_at AS "Day", 
    ROUND(AVG(IF(t.status = "completed", 0, 1)), 2) AS "Cancellation Rate"
FROM Trips t, Users c, Users d
WHERE
    t.client_id = c.users_id AND
    t.driver_id = d.users_id AND
    c.banned = "NO" AND
    d.banned = "NO" AND
    t.request_at >= "2013-10-01" AND
    t.request_at <= "2013-10-03"
GROUP BY t.request_at