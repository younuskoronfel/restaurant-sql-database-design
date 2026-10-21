-- All records are fictional and intentionally small for manual verification.
INSERT INTO menu_items(id,name,price_cents) VALUES
  (1,'Margherita Pizza',1400),
  (2,'Pepperoni Pizza',1700),
  (3,'Garlic Bread',700);

INSERT INTO ingredients(id,name,unit,current_stock_units,unit_cost_cents) VALUES
  (1,'Dough','portions',100,150),
  (2,'Mozzarella','portions',120,100),
  (3,'Tomato Sauce','portions',110,50),
  (4,'Pepperoni','portions',80,125),
  (5,'Garlic Butter','portions',60,35);

INSERT INTO recipes(menu_item_id,ingredient_id,units_per_item) VALUES
  (1,1,1),(1,2,1),(1,3,1),
  (2,1,1),(2,2,1),(2,3,1),(2,4,1),
  (3,1,1),(3,5,1);

INSERT INTO orders(id,order_date) VALUES
  (1,'2026-01-05'),(2,'2026-01-06'),(3,'2026-01-07');

INSERT INTO order_items(order_id,menu_item_id,quantity,sale_price_cents) VALUES
  (1,1,2,1400),  -- 2 Margherita
  (1,3,1,700),   -- 1 garlic bread
  (2,2,3,1700),  -- 3 pepperoni
  (3,1,1,1400),  -- 1 Margherita
  (3,2,1,1700);  -- 1 pepperoni