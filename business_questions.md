# Business Questions Solved

Full index of the 30 queries in [`sql/03_queries.sql`](../sql/03_queries.sql),
mapped to the business question each one answers.

| # | Business Question | SQL Concept |
|---|---|---|
| 1 | Show me the full customer list | `SELECT *` |
| 2 | Which customers are based in Delhi? | `WHERE` |
| 3 | List all products priced above ₹2,000, cheapest first | `WHERE`, `ORDER BY` |
| 4 | What are our 5 most expensive products? | `ORDER BY`, `LIMIT` |
| 5 | Show all orders placed in December 2023 | `WHERE BETWEEN` |
| 6 | Which orders were cancelled? | `WHERE` |
| 7 | How many customers do we have in total? | `COUNT()` |
| 8 | What is our average product price? | `AVG()` |
| 9 | What is the total revenue from completed orders? | `SUM()`, `JOIN` |
| 10 | What is the average value of a completed order? | Subquery + `AVG()` |
| 11 | How many units of each product have been sold? | `GROUP BY`, `SUM()` |
| 12 | What is total revenue per product category? | `GROUP BY` |
| 13 | How many completed orders has each customer placed? | `GROUP BY`, `COUNT()` |
| 14 | Which customers placed more than 1 completed order? | `HAVING` |
| 15 | Which categories generate more than ₹15,000 revenue? | `HAVING` |
| 16 | Full order list with customer names attached | `INNER JOIN` |
| 17 | Break every order down into individual products | `INNER JOIN` (3-table) |
| 18 | Which customers have never placed an order? | `LEFT JOIN` + `IS NULL` |
| 19 | Which products have never been sold? | `LEFT JOIN` + `IS NULL` |
| 20 | Total spend per customer, including zero-spenders | `LEFT JOIN`, `COALESCE` |
| 21 | Which products are priced above the average price? | Scalar subquery |
| 22 | Which customers spent more than the average customer? | Nested subquery |
| 23 | Which orders included an Electronics product? | `IN` subquery |
| 24 | What is our month-by-month revenue trend? | CTE |
| 25 | Rank product categories by revenue | CTE + `RANK()` |
| 26 | Tag each customer's orders in chronological order | `ROW_NUMBER()` |
| 27 | Top 2 products by revenue within each category | CTE + `RANK()` (partitioned) |
| 28 | Rank customers by spend into loyalty tiers | CTE + `DENSE_RANK()` |
| 29 | Running (cumulative) monthly revenue total | CTE + `SUM() OVER` |
| 30 | Who are our top 3 highest-spending customers? | CTE + `ROW_NUMBER()` (top-N) |

---

### Why these questions?

Each question mirrors a real request that would land on a Data Analyst
Intern's desk in the first few weeks — from a marketing manager asking
"who are our best customers?" to an inventory lead asking "what's not
selling?" The goal is a portfolio that reads as **applied business
analysis**, not just SQL syntax practice.
