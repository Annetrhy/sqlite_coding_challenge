 
-- TASK 1
SELECT
    c.first_name || ' ' || c.last_name AS customer_full_name,
    SUM(COALESCE(oi.quantity, 0) * COALESCE(oi.unit_price, 0)) AS total_spend
FROM customers c
JOIN orders o ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY c.id
ORDER BY total_spend DESC
LIMIT 5;

--TASK2
SELECT
  p.category AS category,
  SUM(COALESCE(oi.quantity,0) * COALESCE(oi.unit_price,0)) AS revenue
FROM products p
JOIN order_items oi ON oi.product_id = p.id
JOIN orders o ON o.id = oi.order_id
GROUP BY p.category
ORDER BY revenue DESC;

--TASK3
SELECT
  e.first_name,
  e.last_name,
  d.name AS department_name,
  e.salary AS salary,
  avg_dept.avg_salary AS department_avg
FROM employees e
JOIN departments d ON d.id = e.department_id
JOIN (
  SELECT
    department_id,
    AVG(COALESCE(salary, 0)) AS avg_salary
  FROM employees
  GROUP BY department_id
) avg_dept ON avg_dept.department_id = e.department_id
WHERE e.salary > avg_dept.avg_salary
ORDER BY d.name, e.salary;

--TASK4
SELECT
  COALESCE(NULLIF(TRIM(city), ''), 'Unknown') AS city,
  COUNT(*) AS gold_customer_count
FROM customers
WHERE LOWER(COALESCE(loyalty_level, '')) = 'gold'
GROUP BY COALESCE(NULLIF(TRIM(city), ''), 'Unknown')
ORDER BY gold_customer_count DESC, city ASC;

--Extension:Loyalty distribution by city
SELECT
  COALESCE(NULLIF(TRIM(city), ''), 'Unknown') AS city,
  SUM(CASE WHEN LOWER(COALESCE(loyalty_level, '')) = 'gold' THEN 1 ELSE 0 END) AS gold_count,
  SUM(CASE WHEN LOWER(COALESCE(loyalty_level, '')) = 'silver' THEN 1 ELSE 0 END) AS silver_count,
  SUM(CASE WHEN LOWER(COALESCE(loyalty_level, '')) = 'bronze' THEN 1 ELSE 0 END) AS bronze_count,
  COUNT(*) AS total_customers
FROM customers
GROUP BY COALESCE(NULLIF(TRIM(city), ''), 'Unknown')
ORDER BY gold_count DESC, city ASC; 