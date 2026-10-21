"""Verify the educational database using only Python's standard library."""
from pathlib import Path
import sqlite3
import unittest

ROOT = Path(__file__).resolve().parents[1]


class ReportingTests(unittest.TestCase):
    def setUp(self):
        self.db = sqlite3.connect(":memory:")
        self.db.execute("PRAGMA foreign_keys = ON")
        self.db.executescript((ROOT / "schema.sql").read_text())
        self.db.executescript((ROOT / "seed.sql").read_text())

    def tearDown(self):
        self.db.close()

    def test_known_total_revenue(self):
        revenue, = self.db.execute(
            "SELECT SUM(quantity * sale_price_cents) FROM order_items"
        ).fetchone()
        self.assertEqual(revenue, 11_700)  # $117.00

    def test_recipe_relation_is_many_to_many(self):
        items_for_dough, = self.db.execute(
            "SELECT COUNT(*) FROM recipes WHERE ingredient_id = 1"
        ).fetchone()
        self.assertEqual(items_for_dough, 3)
        ingredients_for_pepperoni, = self.db.execute(
            "SELECT COUNT(*) FROM recipes WHERE menu_item_id = 2"
        ).fetchone()
        self.assertEqual(ingredients_for_pepperoni, 4)

    def test_recipe_join_does_not_double_count_revenue(self):
        # Joining straight through recipes repeats order items once per ingredient.
        proper, = self.db.execute(
            "SELECT SUM(quantity * sale_price_cents) FROM order_items"
        ).fetchone()
        improper, = self.db.execute("""
            SELECT SUM(oi.quantity * oi.sale_price_cents)
            FROM order_items oi JOIN recipes r ON oi.menu_item_id = r.menu_item_id
        """).fetchone()
        self.assertEqual(proper, 11_700)
        self.assertGreater(improper, proper)

    def test_foreign_key_rejects_missing_menu_item(self):
        with self.assertRaises(sqlite3.IntegrityError):
            self.db.execute("INSERT INTO order_items(order_id,menu_item_id,quantity,sale_price_cents) VALUES (1,999,1,100)")

    def test_ingredient_use(self):
        result = dict(self.db.execute("""
            SELECT i.name, SUM(oi.quantity * r.units_per_item)
            FROM order_items oi
            JOIN recipes r ON oi.menu_item_id = r.menu_item_id
            JOIN ingredients i ON r.ingredient_id = i.id
            GROUP BY i.name
        """).fetchall())
        self.assertEqual(result["Dough"], 8)
        self.assertEqual(result["Pepperoni"], 4)


if __name__ == "__main__":
    unittest.main()