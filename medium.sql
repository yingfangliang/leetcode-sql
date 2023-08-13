-- 176. Second Highest Salary (subquery)
SELECT (
    SELECT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary; -- use SELECT(subquery) to show NULL when the result is empty.

-- 177. Nth Highest Salary (function)
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
DECLARE skip_N INT DEFAULT N-1; 
    -- DECLARE: create a new variable with specified data type
    -- SET: change the value
  RETURN (
      SELECT(
        SELECT salary
        FROM Employee
        GROUP BY salary
        ORDER BY salary DESC
        LIMIT 1 OFFSET skip_N
      ) AS "getNthHighestSalary(2)"
  );
END

-- *178. Rank Scores (DENSE_RANK())
SELECT 
  score, 
  DENSE_RANK() OVER(ORDER BY score DESC) AS "rank"
  -- DENSE_RANK(): 1,2,3,3,"4"
  -- RANK(): 1,2,3,3,"5" 
FROM Scores
ORDER BY "rank";

-- *180. Consecutive Numbers (LEAD(), CTE)
WITH cte AS (
  SELECT 
    num AS num0,
    LEAD(num, 1) OVER(ORDER BY id) AS num1,
    LEAD(num, 2) OVER(ORDER BY id) AS num2
  FROM Logs
)
SELECT DISTINCT num0 AS ConsecutiveNums
FROM cte
WHERE num0 = num1 AND 
      num1 = num2;

-- 184. Department Highest Salary (CTE)
WITH cte AS (
  SELECT 
    d.id AS departmentId,
    d.name AS departmentName, 
    MAX(e.salary) AS maxSalary
  FROM Employee e
  LEFT JOIN Department d
  ON e.departmentId = d.id
  GROUP BY d.id
)
SELECT 
  cte.departmentName AS "Department",
  e.name AS "Employee",
  e.salary AS "Salary"
FROM Employee e
LEFT JOIN cte
ON e.departmentId = cte.departmentId
WHERE e.salary = cte.maxSalary;

-- 570. Managers with at Least 5 Direct Reports (subquery)
SELECT name
FROM Employee
WHERE id IN (
  SELECT managerId
  FROM Employee
  GROUP BY managerId
  HAVING COUNT(*) >= 5
);

-- 585. Investments in 2016 (subquery, ROUND())
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE 
  tiv_2015 IN (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
  ) AND
  pid IN (
    SELECT pid
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
  )

-- 602. Friend Requests II: Who Has the Most Friends (UNION ALL)
SELECT id, SUM(num) AS num
FROM(
  SELECT 
    requester_id AS id,
    Count(*) AS num
  FROM RequestAccepted
  GROUP BY requester_id
  UNION ALL -- use UNION ALL since requested friends num and accepted friends num might be the same
  SELECT 
    accepter_id AS id,
    Count(*) AS num
  FROM RequestAccepted
  GROUP BY accepter_id
) AS tmp
GROUP BY id
ORDER BY SUM(num) DESC
LIMIT 1;

-- 608. Tree Node (CASE)
SELECT 
  id,
  CASE
    WHEN p_id IS NULL THEN "Root"
    WHEN id = ANY(SELECT p_id FROM Tree) THEN "Inner"
  ELSE "Leaf"
  END AS type
FROM Tree

-- 626. Exchange Seats (CASE, LEAD, LAG
)
SELECT
  id,
  CASE
    WHEN id = (SELECT MAX(id) FROM Seat) AND MOD(id, 2) = 1 THEN student
    WHEN MOD(id, 2) = 1 THEN LEAD(student, 1) OVER(ORDER BY id)
  ELSE LAG(student, 1) OVER(ORDER BY id)  
  END AS student
FROM Seat