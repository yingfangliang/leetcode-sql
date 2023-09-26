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

-- 601. Human Traffic of Stadium
SELECT id, visit_date, people
FROM(
    SELECT id, visit_date, people, 
        LEAD(people, 1) OVER (ORDER BY id) people_next1day,
        LEAD(people, 2) OVER (ORDER BY id) people_next2day,
        LAG(people, 1) OVER (ORDER BY id) people_last1day,
        LAG(people, 2) OVER (ORDER BY id) people_last2day
    FROM Stadium) AS tmp
WHERE 
    people >= 100 AND (
        (people_next1day >= 100 AND people_next2day >= 100) OR
        (people_next1day >= 100 AND people_last1day >= 100) OR
        (people_last1day >= 100 AND people_last2day >= 100)
        )