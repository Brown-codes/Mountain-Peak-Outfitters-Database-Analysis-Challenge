-- 16. Total sales and transactions per employee
SELECT e.first_name, e.last_name, COUNT(s.sale_id) AS transactions, COALESCE(SUM(s.total_amount), 0) AS total_sales 
FROM employees e 
LEFT JOIN sales s ON e.employee_id = s.employee_id 
GROUP BY e.employee_id, e.first_name, e.last_name 
ORDER BY total_sales DESC;

-- 17. Average transaction value for each employee
SELECT e.first_name, e.last_name, ROUND(AVG(s.total_amount), 2) AS avg_transaction 
FROM employees e 
JOIN sales s ON e.employee_id = s.employee_id 
GROUP BY e.employee_id, e.first_name, e.last_name 
ORDER BY avg_transaction DESC;

-- 18. Store performance and staffing report
SELECT st.store_name, m.first_name || ' ' || m.last_name AS manager, 
       (SELECT COUNT(*) FROM employees e2 WHERE e2.store_id = st.store_id) AS staff_count, 
       COALESCE(SUM(s.total_amount), 0) AS total_sales 
FROM stores st 
LEFT JOIN employees m ON st.store_id = m.store_id AND m.position = 'Store Manager' 
LEFT JOIN sales s ON st.store_id = s.store_id 
GROUP BY st.store_id, st.store_name, m.first_name, m.last_name;

-- 19. Stores where average salary is higher than company average
SELECT st.store_name, ROUND(AVG(e.salary), 2) AS store_avg_salary 
FROM stores st 
JOIN employees e ON st.store_id = e.store_id 
GROUP BY st.store_name 
HAVING AVG(e.salary) > (SELECT AVG(salary) FROM employees);

-- 20. Product performance matrix
WITH product_stats AS (
    SELECT p.product_name, ((p.price - p.cost) / p.price) AS margin, COALESCE(SUM(si.quantity), 0) AS total_sold 
    FROM products p LEFT JOIN sale_items si ON p.product_id = si.product_id 
    GROUP BY p.product_id, p.product_name, p.price, p.cost
),
avg_metrics AS (
    SELECT AVG(margin) AS avg_margin, AVG(total_sold) AS avg_sold FROM product_stats
)
SELECT ps.product_name, 
       CASE WHEN ps.margin >= am.avg_margin AND ps.total_sold >= am.avg_sold THEN 'Stars' 
            WHEN ps.margin < am.avg_margin AND ps.total_sold >= am.avg_sold THEN 'Volume Drivers' 
            WHEN ps.margin >= am.avg_margin AND ps.total_sold < am.avg_sold THEN 'Opportunities' 
            ELSE 'Problems' END AS matrix_category 
FROM product_stats ps CROSS JOIN avg_metrics am;