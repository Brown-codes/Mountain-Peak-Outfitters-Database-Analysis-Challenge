-- 21. Management hierarchy report
WITH RECURSIVE hierarchy AS (
    SELECT employee_id, first_name, last_name, position, manager_id, store_id, 1 AS level 
    FROM employees WHERE manager_id IS NULL
    UNION ALL 
    SELECT e.employee_id, e.first_name, e.last_name, e.position, e.manager_id, e.store_id, h.level + 1 
    FROM employees e JOIN hierarchy h ON e.manager_id = h.employee_id
)
SELECT h.level, h.first_name, h.last_name, h.position, s.store_name 
FROM hierarchy h LEFT JOIN stores s ON h.store_id = s.store_id 
ORDER BY h.store_id, h.level;

-- 22. Comprehensive customer analysis by loyalty tier
SELECT c.loyalty_tier, ROUND(AVG(s.total_amount), 2) AS avg_transaction_value, 
       COUNT(DISTINCT pr.review_id) AS total_reviews,
       (SELECT cat.category_name 
        FROM customers cu JOIN sales sa ON cu.customer_id = sa.customer_id 
        JOIN sale_items si ON sa.sale_id = si.sale_id 
        JOIN products p ON si.product_id = p.product_id 
        JOIN categories cat ON p.category_id = cat.category_id 
        WHERE cu.loyalty_tier = c.loyalty_tier 
        GROUP BY cat.category_name ORDER BY SUM(si.quantity) DESC LIMIT 1) AS top_category
FROM customers c 
LEFT JOIN sales s ON c.customer_id = s.customer_id 
LEFT JOIN product_reviews pr ON c.customer_id = pr.customer_id 
GROUP BY c.loyalty_tier;