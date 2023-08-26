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
FROM Tree;

-- 626. Exchange Seats (CASE, LEAD, LAG)
SELECT
  id,
  CASE
    WHEN id = (SELECT MAX(id) FROM Seat) AND MOD(id, 2) = 1 THEN student
    WHEN MOD(id, 2) = 1 THEN LEAD(student, 1) OVER(ORDER BY id)
  ELSE LAG(student, 1) OVER(ORDER BY id)  
  END AS student
FROM Seat;

-- 1045. Customers Who Bought All Products
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product);

-- 1070. Product Sales Analysis III
SELECT
  s.product_id,
  s.year AS first_year,
  s.quantity,
  s.price
FROM Sales s
LEFT JOIN (
    SELECT product_id, MIN(year) AS year
    FROM Sales
    GROUP BY product_id
) s_first
USING (product_id)
WHERE s.year = s_first.year;

-- 550. Game Play Analysis IV (DATE_SUB)
SELECT ROUND(COUNT(a2.player_id)/COUNT(a1.player_id), 2) AS fraction
FROM (
  SELECT player_id, MIN(event_date) AS first_login
  FROM Activity
  GROUP BY player_id
  ) AS a1
LEFT JOIN Activity AS a2
ON a1.player_id = a2.player_id AND DATEDIFF(a1.first_login, a2.event_date) = -1

SELECT 
  ROUND(COUNT(DISTINCT player_id)/(SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM Activity
WHERE (player_id, DATE_SUB(event_date, INTERVAL 1 DAY)) IN (
  SELECT player_id, MIN(event_date)
  FROM Activity
  GROUP BY player_id
  )

-- 1158. Market Analysis I (execution order)
SELECT 
  u.user_id AS buyer_id, 
  u.join_date, 
  COUNT(o.order_id) AS orders_in_2019
FROM Users AS u
LEFT JOIN Orders AS o
ON u.user_id = o.buyer_id AND YEAR(o.order_date) = 2019
GROUP BY u.user_id

-- 1164. Product Price at a Given Date (UNION)
WITH cte AS (
  SELECT 
    product_id, 
    MAX(change_date) AS last_change
  FROM Products
  WHERE change_date <= "2019-08-16"
  GROUP BY product_id
)

SELECT 
  last.product_id AS product_id,
  p.new_price AS price
FROM cte AS last
LEFT JOIN Products AS p
ON last.product_id = p.product_id
WHERE last.last_change = p.change_date
UNION
SELECT product_id, 10 AS price
FROM Products
WHERE product_id NOT IN (SELECT product_id FROM cte)

-- 1174. Immediate Food Delivery II (True or False statement in SELECT)
WITH cte AS (
  SELECT 
    customer_id,
    MIN(order_date) AS first_order_date
  FROM Delivery
  GROUP BY customer_id
)
SELECT ROUND(100*AVG(d.order_date = d.customer_pref_delivery_date), 2) AS immediate_percentage
FROM Delivery d
LEFT JOIN cte
ON d.customer_id = cte.customer_id
WHERE d.order_date = cte.first_order_date 

-- 1193. Monthly Transactions I (DATE_FORMAT(), IF statement in SUM())
SELECT 
  DATE_FORMAT(trans_date, "%Y-%m") AS month,
  country,
  COUNT(*) AS trans_count,
  SUM(state = "approved") AS approved_count,
  SUM(amount) AS trans_total_amount,
  SUM(IF(state = "approved", amount, 0)) AS approved_total_amount
FROM Transactions
GROUP BY country, DATE_FORMAT(trans_date, "%Y-%m")

-- 1204. Last Person to Fit in the Bus (SUM() OVER(ORDER BY))
WITH cte AS (
  SELECT 
    *,
    SUM(weight) OVER(ORDER BY turn) AS total_weight  
  FROM Queue
)
SELECT person_name
FROM cte
WHERE total_weight <= 1000
ORDER BY total_weight DESC
LIMIT 1

-- 1321. Restaurant Growth (SELF JOIN, DATEDIFF())
WITH cte AS (
  SELECT 
    visited_on,
    SUM(amount) AS daily_sum
  FROM Customer
  GROUP BY visited_on
)
SELECT 
  curr.visited_on,
  SUM(prev.daily_sum )AS amount,
  ROUND(SUM(prev.daily_sum)/7, 2) AS average_amount
FROM cte curr, cte prev
WHERE DATEDIFF(curr.visited_on, prev.visited_on) BETWEEN 0 AND 6
GROUP BY curr.visited_onHAVING curr.visited_on >= (SELECT DATE_ADD(MIN(visited_on), INTERVAL 6 DAY) FROM Customer) 
ORDER BY curr.visited_on

-- 1341. Movie Rating (UNION ALL, GROUP BY then ORDER BY)
(SELECT u.name AS results
FROM MovieRating mr LEFT JOIN Users u ON u.user_id = mr.user_id
GROUP BY mr.user_id ORDER BY COUNT(*) DESC, u.name ASC LIMIT 1)
UNION ALL
(SELECT m.title AS results
FROM MovieRating mr LEFT JOIN Movies m ON m.movie_id = mr.movie_id
WHERE DATE_FORMAT(mr.created_at, "%Y-%m") = "2020-02"
GROUP BY mr.movie_id ORDER BY AVG(mr.rating) DESC, m.title ASC LIMIT 1)

-- 1393. Capital Gain/Loss (CASE)
SELECT 
    stock_name,
    SUM(
        CASE
            WHEN operation = "Sell" THEN price
            WHEN operation = "Buy" THEN -price
        END
        ) AS capital_gain_loss
FROM Stocks
GROUP BY stock_name