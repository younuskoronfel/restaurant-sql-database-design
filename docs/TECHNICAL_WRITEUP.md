---
title: "SQL Database Design & Operations Analytics"
subtitle: "Technical project write-up | Red Pepper Pizzeria & Pasta"
author: "Younus Koronfel"
date: "October 2026"
geometry: margin=0.82in
fontsize: 10pt
---

# Project overview

**Project:** SQL Database Design & Operations Analytics  
**Setting:** Independent project involving Red Pepper Pizzeria & Pasta, Carnation, Washington  
**Period:** January - March 2026  
**My documented contribution:** Designed a relational database structure connecting orders, menu items, recipes, ingredients, and inventory; wrote example SQL queries for sales, orders, and menu performance; and designed ingredient-use comparisons for evaluating potential waste.

A restaurant's sales tell only part of the operational story. Orders generate revenue, but each menu item also consumes ingredients. I wanted to explore how a database could connect those events so a manager could understand both *what sells* and *what ingredients those sales imply were used*. The goal of the project was to organize that information coherently enough for reliable reporting and future inventory analysis.

# Technical design

The central decision was to **separate entities into related tables instead of storing everything in one spreadsheet-like table**. The design described in my project included orders, menu items, recipes, ingredients, and inventory. An order links to what a customer purchased; a menu item links through a recipe to the ingredients required to make it. Inventory represents ingredient quantities that can be compared against estimated consumption.

An illustrative version of the relationships is:

```text
orders -> order_items -> menu_items
                           |
                           v
                         recipes -> ingredients -> inventory quantities
```

The intermediate `order_items` and `recipes` structures in this diagram explain how a normalized implementation can represent relationships; **this diagram is a reconstruction for explaining the design, not a claim that these were the precise names or columns in my original files.** A menu item can use several ingredients, and the same ingredient can appear in multiple menu items. Modeling those relationships separately makes sales and ingredient-use queries more flexible.

## Hardest design decision

**The most important design tradeoff was connecting sales to ingredient usage without duplicating inventory data for every transaction.** A single flat table is simpler to look at, but repeated recipe ingredients create duplicate rows and can make reporting totals inaccurate. Splitting menu items, recipes, and ingredients into linked tables adds joins, but gives each fact a clearer home. My documented project supports that general design choice; I would review the original schema before asserting a particular constraint, index, or database engine in an interview.

# Example reporting logic

I wrote example SQL queries targeting sales revenue, order activity, and menu performance. The following is a **reconstructed teaching example**, not a verbatim excerpt from the original project:

```sql
SELECT m.name,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price_cents) AS revenue_cents
FROM order_items AS oi
JOIN menu_items AS m ON m.id = oi.menu_item_id
GROUP BY m.id, m.name
ORDER BY revenue_cents DESC;
```

This query joins each sold line item to its menu item's name, groups the rows by menu item, and adds up quantities and dollar amounts. It assumes sample column names and prices stored in integer cents; those choices are illustrative unless confirmed against my original SQL files.

An ingredient-use analysis can multiply quantities sold by the recipe amount needed per item. That estimates theoretical usage, which can later be compared against actual inventory changes. **A difference is not automatically proof of waste**: spoilage, substitutions, measurement error, and inventory-count timing can also explain it.

# Testing, limitations, and next steps

The materials currently available document **schema design and example query writing**, but do not establish that I deployed a production database or ran a particular automated test suite. I am not representing this independent project as a live point-of-sale integration. To validate a reconstruction, I would prepare a small synthetic dataset; check one known sale's revenue by hand; test a menu item with multiple ingredients; verify that joins do not double-count orders; and compare expected versus actual query outputs. Those are **proposed validation steps**, not completed test results from 2026.

If I continued the project, I would add constraints on foreign keys and quantities, reproducible SQL tests, transaction-safe inventory changes, and a clear distinction between estimated ingredient usage and actual waste. I would also document any sample data as synthetic and avoid placing a real business's private information in a public repository.

# What I learned

This project moved my understanding of business analytics beyond isolated charts. The way information is **modeled before analysis** determines the questions a system can answer and the mistakes a report might make. It also showed me the practical connection between software engineering and small-business operations: reliable data structures help turn everyday sales into useful decisions.

**Before submitting:** Check this draft against your original SQL files and your own recollection. Confirm the exact choices you made, whether/how you actually ran the queries, and any authentic debugging or feedback examples. Do not describe the illustrative code or proposed testing as completed original work.