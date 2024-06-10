/*
Question #1: 
Installers receive performance based year end bonuses. Bonuses are calculated by taking 10% of the total value of parts installed by the installer.

Calculate the bonus earned by each installer rounded to a whole number. Sort the result by bonus in increasing order.

Expected column names: name, bonus
*/

-- q1 solution:

SELECT
i.name AS name,
(SUM(pt.price * o.quantity)*.10)::integer AS bonus
FROM
installs AS ins
INNER JOIN
installers AS i ON ins.installer_id = i.installer_id
INNER JOIN
orders AS o ON ins.order_id = o.order_id
INNER JOIN
parts AS pt ON o.part_id = pt.part_id
GROUP BY
i.name
ORDER BY 
bonus;


/*
Question #2: 
RevRoll encourages healthy competition. The company holds a “Install Derby” where installers face off to see who can change a part the fastest in a tournament style contest.

Derby points are awarded as follows:

- An installer receives three points if they win a match (i.e., Took less time to install the part).
- An installer receives one point if they draw a match (i.e., Took the same amount of time as their opponent).
- An installer receives no points if they lose a match (i.e., Took more time to install the part).

We need to calculate the scores of all installers after all matches. Return the result table ordered by `num_points` in decreasing order. 
In case of a tie, order the records by `installer_id` in increasing order.

Expected column names: `installer_id`, `name`, `num_points`

*/

-- q2 solution:

WITH table1 AS (
  SELECT derby_id,
  installer_one_id AS installers_id,
  CASE 
  WHEN installer_one_time < installer_two_time THEN 3
  WHEN installer_one_time = installer_two_time THEN 1
  ELSE 0 
  END AS num_points
  FROM install_derby
  
  UNION ALL
  
  SELECT derby_id,
  installer_two_id AS installers_id,
  CASE
  WHEN installer_two_time < installer_one_time THEN 3
  WHEN installer_two_time = installer_one_time THEN 1
  ELSE 0 
  END AS num_points
  FROM install_derby)
  
SELECT
i.installer_id,
i.name,
COALESCE(SUM(t1.num_points), 0) AS num_points
FROM installers AS i
LEFT JOIN table1 AS t1
ON i.installer_id = t1.installers_id
GROUP BY installer_id, i.name
ORDER BY num_points DESC, installer_id;

/*
Question #3:

Write a query to find the fastest install time with its corresponding `derby_id` for each installer. 
In case of a tie, you should find the install with the smallest `derby_id`.

Return the result table ordered by `installer_id` in ascending order.

Expected column names: `derby_id`, `installer_id`, `install_time`
*/

-- q3 solution:

WITH fastest_time AS (
SELECT installer_one_id AS player,
MIN(installer_one_time) AS fastest
FROM install_derby
GROUP by installer_one_id

UNION ALL

SELECT installer_two_id AS player,
MIN(installer_two_time) AS fastest
FROM install_derby
GROUP by installer_two_id),

table1 AS (
SELECT
player AS installer_id,
MIN(fastest) as install_time
FROM fastest_time
GROUP by player),

table2 AS (
SELECT
COALESCE(id1.derby_id, id2.derby_id) AS derby_id,
t1.installer_id,
t1.install_time
FROM table1 AS t1
LEFT JOIN install_derby AS id1
ON t1.installer_id = id1.installer_one_id AND t1.install_time = id1.installer_one_time
LEFT JOIN install_derby AS id2
ON t1.installer_id = id2.installer_two_id AND t1.install_time = id2.installer_two_time)

SELECT
MIN(derby_id) AS derby_id,
installer_id,
install_time
FROM table2
GROUP BY installer_id, install_time
ORDER BY installer_id;

/*
Question #4: 
Write a solution to calculate the total parts spending by customers paying for installs on each Friday of every week in November 2023. 
If there are no purchases on the Friday of a particular week, the parts total should be set to `0`.

Return the result table ordered by week of month in ascending order.

Expected column names: `november_fridays`, `parts_total`
*/

-- q4 solution:

WITH table1 AS (
SELECT
ins.install_date,
SUM(pt.price * o.quantity) AS total_spend
FROM
installs AS ins
INNER JOIN
orders AS o ON ins.order_id = o.order_id
INNER JOIN
parts AS pt ON o.part_id = pt.part_id
WHERE ins.install_date IN ('2023-11-03', '2023-11-03'::date + 7, '2023-11-03'::date +14, '2023-11-03'::date+ 21)
GROUP BY
ins.install_id),

table2 AS (
  SELECT '2023-11-03' AS fri
  
  UNION ALL
  
  SELECT '2023-11-03'::date + 7 AS fri
  
  UNION ALL
  
  SELECT '2023-11-03'::date + 14 AS fri
  
  UNION ALL
  
  SELECT '2023-11-03'::date + 21 AS fri),

table3 AS (
SELECT
install_date AS november_fridays,
SUM(total_spend) AS parts_total
FROM table1
GROUP BY
november_fridays
ORDER BY
november_fridays)

SELECT
t2.fri AS november_fridays,
COALESCE(t3.parts_total, 0) AS parts_total
FROM table2 AS t2
LEFT JOIN table3 AS t3
ON t2.fri = t3.november_fridays
ORDER BY t2.fri;

