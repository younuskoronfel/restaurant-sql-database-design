-- Q1. Revenue by menu item. Expected Margherita $42, Pepperoni $68,
-- Garlic Bread $7. Revenue = sum(quantity * PRICE AT SALE).
SELECT m.name AS menu_item,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.sale_price_cents) AS revenue_cents
FROM order_items AS oi
JOIN menu_items AS m ON m.id = oi.menu_item_id
GROUP BY m.id, m.name
ORDER BY revenue_cents DESC;

-- Q2. Revenue by day. Each order may have multiple order items.
SELECT o.order_date,
       COUNT(DISTINCT o.id) AS orders,
       SUM(oi.quantity * oi.sale_price_cents) AS revenue_cents
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.id
GROUP BY o.order_date
ORDER BY o.order_date;

-- Q3. Theoretical ingredient consumption based on sold quantities.
-- Does NOT establish actual food waste.
SELECT i.name AS ingredient,
       SUM(oi.quantity * r.units_per_item) AS estimated_units_consumed
FROM order_items AS oi
JOIN recipes AS r ON r.menu_item_id = oi.menu_item_id
JOIN ingredients AS i ON i.id = r.ingredient_id
GROUP BY i.id, i.name
ORDER BY estimated_units_consumed DESC, i.name;

-- Q4. Estimated contribution after *ingredient costs only*, by item.
-- Not net profit: excludes labor, rent, utilities, tax, etc.
WITH cost_per_item AS (
  SELECT r.menu_item_id,
         SUM(r.units_per_item * i.unit_cost_cents) AS food_cost_cents
  FROM recipes AS r
  JOIN ingredients AS i ON i.id = r.ingredient_id
  GROUP BY r.menu_item_id
)
SELECT m.name,
       SUM(oi.quantity * oi.sale_price_cents) AS revenue_cents,
       SUM(oi.quantity * c.food_cost_cents) AS estimated_food_cost_cents,
       SUM(oi.quantity * (oi.sale_price_cents - c.food_cost_cents)) AS estimated_contribution_cents
FROM order_items AS oi
JOIN menu_items AS m ON m.id = oi.menu_item_id
JOIN cost_per_item AS c ON c.menu_item_id = oi.menu_item_id
GROUP BY m.id, m.name
ORDER BY revenue_cents DESC;