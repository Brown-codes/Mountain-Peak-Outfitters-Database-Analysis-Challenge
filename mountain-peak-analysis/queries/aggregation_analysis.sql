-- 6. Total sales amount for each store
SELECT st.store_name, st.region, COALESCE(SUM(s.total_amount), 0) AS total_sales 
FROM stores st 
LEFT JOIN sales s ON st.store_id = s.store_id 
GROUP BY st.store_name, st.region;

-- 7. Total sales amount and transactions for each month in 2023
SELECT EXTRACT(MONTH FROM sale_date) AS month, 
       SUM(total_amount) AS total_sales, 
       COUNT(sale_id) AS transaction_count 
FROM sales 
WHERE EXTRACT(YEAR FROM sale_date) = 2023 
GROUP BY EXTRACT(MONTH FROM sale_date)
ORDER BY month;

-- 8. Product categories generating the most revenue
SELECT c.category_name, SUM(si.quantity * si.price_sold) AS total_revenue 
FROM categories c 
JOIN products p ON c.category_id = p.category_id 
JOIN sale_items si ON p.product_id = si.product_id 
GROUP BY c.category_name 
ORDER BY total_revenue DESC;

-- 9. Top 5 most frequently purchased products
SELECT p.product_name, SUM(si.quantity) AS total_quantity_sold 
FROM products p 
JOIN sale_items si ON p.product_id = si.product_id 
GROUP BY p.product_name 
ORDER BY total_quantity_sold DESC 
LIMIT 5;

-- 10. Customer purchase counts and most recent purchase
SELECT c.first_name, c.last_name, c.email, 
       COUNT(s.sale_id) AS total_purchases, 
       MAX(s.sale_date) AS most_recent_purchase 
FROM customers c 
LEFT JOIN sales s ON c.customer_id = s.customer_id 
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;