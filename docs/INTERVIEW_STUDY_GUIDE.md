# Understanding the SQL database design (practice guide)

## What you must be able to explain

1. **Primary key:** unique row identifier, e.g. `menu_items.id`.
2. **Foreign key:** ID pointing at a row in another table, e.g. `order_items.menu_item_id` references `menu_items.id`.
3. **One-to-many:** an order has many line items, each line item has one order.
4. **Many-to-many:** one menu item needs multiple ingredients; one ingredient belongs to many menu items. `recipes` is a *bridge table*.
5. **Composite primary key:** the combination of menu item and ingredient uniquely identifies a recipe requirement.
6. **JOIN:** combines related rows using their matching key columns.
7. **GROUP BY:** combines several rows into aggregates by date or menu item.
8. **SUM(quantity * price):** revenue should use units actually sold times the price recorded on that sale.
9. **Query trap:** joining `order_items` directly to `recipes` *before aggregating revenue* repeats the same sale for every ingredient in the recipe. It inflates totals.
10. **Synthetic data:** test data intentionally invented; no private restaurant information is used.

## Verify a known result

The sample orders total $117: (2 × $14) + $7 + (3 × $17) + $14 + $17.

In cents: `2800 + 700 + 5100 + 1400 + 1700 = 11700`.

Check `test_known_total_revenue` for an executable assertion of this expectation.

## Walk through the reporting queries

**Q1:** Start with `order_items`, JOIN the menu item name, group by menu item, sum units sold and revenue. Crucially do NOT join ingredients yet, because that repeats sales rows.

**Q2:** JOIN orders to the line items and GROUP BY date. Use `COUNT(DISTINCT o.id)` because an order with multiple lines still counts as one order.

**Q3:** For each purchased menu item, JOIN through its recipe to its ingredients. Multiply purchased quantity times `units_per_item`, GROUP BY ingredient. This estimates *theoretical usage*, not measured waste.

**Q4:** First calculate food cost for each recipe in a `WITH` common table expression. THEN join that one-per-menu-item cost to sold lines. The separation avoids the duplicate-sales issue.

## Interview rehearsal

**Why separate ingredients from orders?** Because a recipe is reusable across many orders. Separate entities avoid storing the same recipe details on every sale, reducing inconsistencies.

**Why record the sale price in `order_items`?** Historical sales should keep the checkout price even if today's menu price changes.

**What did you personally do in early 2026?** Discuss only facts you can substantiate from your original materials: designing linked entities, example reporting queries, and ingredient-use comparisons. Do not claim you built the reconstructed test suite at that time.

**Was this deployed at the restaurant?** No production deployment is established by the records currently available. Describe it as a design and sample-query project unless you can independently verify more.

**How did you test the historical project?** Your original testing details are not available. Do not claim these later automated tests were conducted in 2026. Explain what you can now demonstrate with synthetic data and what remains to validate.

**What would you improve?** Add actual measured inventory counts, deliveries, waste logs, ingredient conversions, reporting filters, access controls, and safe migrations. Prevent negative inventory with constraints and transaction-safe updates if turning the model into an operational application.

## Hands-on exercises

1. Change the sale price of Pepperoni Pizza for one `order_items` row; predict and verify the total.
2. Add a new ingredient to a recipe; run Q1 and show its revenue doesn't change.
3. Add a new menu item and recipe, then record a mock order.
4. Explain the failure in `test_recipe_join_does_not_double_count_revenue` when a naive join duplicates revenue.
5. Write a new test yourself and make a separate commit describing exactly what you changed.