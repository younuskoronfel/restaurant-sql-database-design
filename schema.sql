-- Educational reconstruction of a restaurant reporting data model.
-- NOT a copy of a real restaurant's private database.
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS menu_items (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  price_cents INTEGER NOT NULL CHECK (price_cents >= 0)
);

CREATE TABLE IF NOT EXISTS ingredients (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  unit TEXT NOT NULL,
  current_stock_units INTEGER NOT NULL CHECK (current_stock_units >= 0),
  unit_cost_cents INTEGER NOT NULL CHECK (unit_cost_cents >= 0)
);

-- Bridge table: many menu items use many ingredients.
CREATE TABLE IF NOT EXISTS recipes (
  menu_item_id INTEGER NOT NULL REFERENCES menu_items(id),
  ingredient_id INTEGER NOT NULL REFERENCES ingredients(id),
  units_per_item INTEGER NOT NULL CHECK (units_per_item > 0),
  PRIMARY KEY (menu_item_id, ingredient_id)
);

CREATE TABLE IF NOT EXISTS orders (
  id INTEGER PRIMARY KEY,
  order_date TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS order_items (
  id INTEGER PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES orders(id),
  menu_item_id INTEGER NOT NULL REFERENCES menu_items(id),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  sale_price_cents INTEGER NOT NULL CHECK (sale_price_cents >= 0)
);

CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_orders_date ON orders(order_date);