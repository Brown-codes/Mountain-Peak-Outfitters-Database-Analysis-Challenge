-- 11. Total amount spent by each customer
SELECT c.first_name, c.last_name, COALESCE(SUM(s.total_amount), 0) AS total_spent 
FROM customers c 
LEFT JOIN sales s ON c.customer_id = s.customer_id 
GROUP BY c.customer_id, c.first_name, c.last_name 
ORDER BY total_spent DESC;

-- 12. Average rating given by customers in each loyalty tier
SELECT c.loyalty_tier, ROUND(AVG(pr.rating), 2) AS avg_rating 
FROM customers c 
JOIN product_reviews pr ON c.customer_id = pr.customer_id 
GROUP BY c.loyalty_tier;

-- 13. Customers who made purchases but never left a review
SELECT DISTINCT c.first_name, c.last_name 
FROM customers c 
JOIN sales s ON c.customer_id = s.customer_id 
LEFT JOIN product_reviews pr ON c.customer_id = pr.customer_id 
WHERE pr.review_id IS NULL;

-- 14. Customers with increased spending in Q2 2023 vs Q1 2023
WITH q1_spend AS (
    SELECT customer_id, SUM(total_amount) AS q1_total FROM sales 
    WHERE sale_date >= '2023-01-01' AND sale_date < '2023-04-01' GROUP BY customer_id
),
q2_spend AS (
    SELECT customer_id, SUM(total_amount) AS q2_total FROM sales 
    WHERE sale_date >= '2023-04-01' AND sale_date < '2023-07-01' GROUP BY customer_id
)
SELECT c.first_name, c.last_name, COALESCE(q1.q1_total, 0) AS q1_spend, COALESCE(q2.q2_total, 0) AS q2_spend 
FROM customers c 
JOIN q2_spend q2 ON c.customer_id = q2.customer_id 
LEFT JOIN q1_spend q1 ON c.customer_id = q1.customer_id 
WHERE COALESCE(q2.q2_total, 0) > COALESCE(q1.q1_total, 0);

-- 15. Favorite product categories for Gold tier customers
SELECT c.category_name, SUM(si.quantity) AS items_purchased 
FROM customers cu 
JOIN sales s ON cu.customer_id = s.customer_id 
JOIN sale_items si ON s.sale_id = si.sale_id 
JOIN products p ON si.product_id = p.product_id 
JOIN categories c ON p.category_id = c.category_id 
WHERE cu.loyalty_tier = 'Gold' 
GROUP BY c.category_name 
ORDER BY items_purchased DESC;