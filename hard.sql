-- 185. Department Top Three Salaries
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