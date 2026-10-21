# Restaurant SQL Database Design

**SQL • Relational modeling • JOINs • Sales reporting • Inventory analysis**

I worked on database design and sales-reporting ideas for **Red Pepper Pizzeria & Pasta** in early 2026. The core problem was connecting what a restaurant sells to the ingredients each item consumes. My original work included planning relationships among **orders, menu items, recipes, ingredients, and inventory**, along with example SQL reports for revenue and menu analysis.

The files in this repository make those ideas runnable with **fictional sample data**.

**Scope:** This is a later, AI-assisted reconstruction for learning and demonstration—not the original 2026 SQL files, an operational client system, or private restaurant data.

## Problem

Restaurant owners want to answer two related questions: *What is selling?* and *Which ingredients should those sales consume?* A flat sales spreadsheet makes it hard to reuse recipe information or connect sales to estimated ingredient usage.

## Design

```text
orders (1) ──< (many) order_items >── (1) menu_items
                                             |
                                             | (many)
                                          recipes
                                             | (many)
                                         ingredients
```

- `orders`: dates of orders
- `order_items`: items sold, quantities, price at sale
- `menu_items`: menu catalog
- `recipes`: bridge table between menu items and ingredients
- `ingredients`: basic inventory quantities and sample costs

The `recipes` table has a composite primary key `(menu_item_id, ingredient_id)` because each menu item's recipe should have at most one row for a given ingredient. Reporting queries separate revenue aggregation from recipe aggregation, avoiding duplicate revenue when the same item has multiple recipe ingredients.

## Run and explore (no packages needed)

Install Python 3.10+ and run:

```bash
python3 -m unittest discover -s tests -v
```

You can inspect the SQL using the command-line SQLite client:

```bash
sqlite3 restaurant-demo.db < schema.sql
sqlite3 restaurant-demo.db < seed.sql
sqlite3 -header -column restaurant-demo.db < queries.sql
```

If you don't have `sqlite3` installed, the Python tests run in memory using the built-in `sqlite3` module.

## Key examples

- `queries.sql` Q1: menu item revenue and unit sales, without recipe joins
- Q2: revenue by date with `COUNT(DISTINCT order_id)`
- Q3: estimated ingredient consumption using sale quantity times recipe quantity
- Q4: estimated food-only contribution; **not net profit**

### Why ingredient consumption isn't the same as waste

Estimated usage measures what the recipes imply should have been used. Waste also depends on recorded starting/ending stock, restocks, spoilage, substitutions, and count errors. This dataset cannot prove actual waste.

## Files

- `schema.sql` — tables, keys, checks, indexes
- `seed.sql` — fictional menu, recipes, orders
- `queries.sql` — four reproducible business queries
- `tests/test_database.py` — repeatable tests
- `docs/TECHNICAL_WRITEUP.md` — original project overview and honest scope
- `docs/INTERVIEW_STUDY_GUIDE.md` — explanation questions and exercises

## What I would expand next

My next step would be to add a clearer comparison between expected recipe usage and actual stock movements, along with queries that test unusual orders and ingredient substitutions. The included technical write-up explains the distinction between the original database-design work and this reproducible example.