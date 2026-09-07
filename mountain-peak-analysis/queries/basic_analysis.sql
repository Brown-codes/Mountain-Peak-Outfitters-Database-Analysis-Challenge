-- 1. Products with less than 20 items in stock
SELECT product_name, stock_quantity 
FROM products 
WHERE stock_quantity < 20 
ORDER BY stock_quantity ASC;

-- 2. Products currently out of stock
SELECT product_name 
FROM products 
WHERE stock_quantity = 0;

-- 3. Profit margin percentage for each product
SELECT product_name, 
       ROUND(((price - cost) / price * 100), 2) AS profit_margin_pct 
FROM products 
ORDER BY profit_margin_pct DESC;

-- 4. Products with no assigned category or supplier
SELECT product_name 
FROM products 
WHERE category_id IS NULL AND supplier_id IS NULL;

-- 5. All products along with their category and supplier names
SELECT p.product_name, c.category_name, s.supplier_name 
FROM products p 
LEFT JOIN categories c ON p.category_id = c.category_id 
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id;