# Restaurant SQL Database Design — educational reconstruction

**SQL • Relational modeling • JOINs • Sales reporting • Inventory analysis**

This repository is a reproducible, **synthetic-data reconstruction** inspired by an independent January–March 2026 database-design project involving Red Pepper Pizzeria & Pasta. The earlier work involved planning relationships among **orders, menu items, recipes, ingredients, and inventory**, and drafting example queries for sales and menu analysis.

**Important:** These files are a later teaching implementation, **not a claim that this exact SQL, sample data, or test suite was created or deployed for the restaurant in 2026**. The sample data is invented. The repository was assembled with AI assistance; the owner should document personal changes honestly.

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

## Learning and disclosure

This educational reconstruction was AI-assisted. Before presenting it to Stripe, independently run the examples, verify totals by hand, identify your real historical contributions, and document any code you personally modify. Original private business data is deliberately excluded.