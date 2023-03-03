# 176. Second Highest Salary
SELECT MAX(salary) AS SecondHighestSalary
FROM Employee
WHERE salary != (SELECT MAX(salary) FROM Employee)

# 177. Nth Highest Salary
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
SET N = N-1;
  RETURN (
      # Write your MySQL query statement below.
      SELECT DISTINCT(salary) FROM Employee 
      ORDER BY salary DESC LIMIT 1 OFFSET N
  );
END

# 178. Rank Scores
SELECT S.score, tmp.rank
FROM Scores S, (SELECT DISTINCT(score), ROW_NUMBER() OVER (ORDER BY score DESC) AS 'rank'
FROM Scores
GROUP BY score
ORDER BY score) AS tmp
WHERE S.score = tmp.score
ORDER BY S.score DESC

# 180. Consecutive Numbers
SELECT DISTINCT L1.num AS ConsecutiveNums
FROM Logs L1, Logs L2, Logs L3 
WHERE L1.id + 1 = L2.id AND L2.id + 1 = L3.id 
AND L1.num = L2.num AND L2.num = L3.num

# 184. Department Highest Salary
SELECT D.name AS "Department", E.name AS "Employee", E.salary
FROM Employee E, Department D
WHERE E.departmentId = D.id AND 
(E.departmentId , E.salary) IN
    (SELECT departmentId, MAX(salary)
     FROM Employee
     GROUP BY departmentId)
     
# 608. Tree Node
SELECT id, CASE 
    WHEN p_id IS null THEN "Root"
    WHEN p_id IN (SELECT id FROM tree) AND id IN (SELECT p_id FROM tree) THEN "Inner"
    ELSE 'Leaf'
END AS "type"
FROM Tree    