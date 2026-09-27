# 🛒 Online Retail Sales Analysis — SQL Portfolio Project

A beginner-to-intermediate SQL project built to mirror a real **Data
Analyst Intern** task: given a small online retail sales database,
answer real business questions using SQL — from basic filtering all the
way up to CTEs and window functions.

> **Tech stack:** MySQL 8.0+ | Relational schema (4 tables) | 30 business
> queries | ERD | Business insights for every query

---

## 📌 Project Overview

An online retail company wants to understand its customers, products,
and sales performance. As the Data Analyst Intern, I was asked to:

- Design a clean relational database for orders, customers, and products
- Write SQL to answer questions from marketing, sales, and inventory teams
- Translate raw query output into plain-English business insights

This repository contains everything needed to reproduce that analysis
end-to-end: schema, sample data, and 30 documented SQL queries.

---

## 🗂️ Repository Structure

```
online-retail-sql-project/
│
├── README.md                  # You are here
├── sql/
│   ├── 01_schema.sql           # CREATE TABLE statements + indexes
│   ├── 02_seed_data.sql        # INSERT INTO statements (sample data)
│   └── 03_queries.sql          # 30 business queries with explanations
├── erd/
│   └── er_diagram.md           # Entity-relationship diagram (Mermaid)
└── docs/
    └── business_questions.md   # Full list of business questions solved
```

---

## 🧱 Database Schema

The database models a typical online store: customers place orders,
and each order contains one or more line items (products).

| Table          | Description                                             |
|-----------------|----------------------------------------------------------|
| `customers`     | Registered customers (name, email, city, signup date)   |
| `products`      | Product catalog (name, category, price, stock)          |
| `orders`        | One row per order (who ordered, when, status)            |
| `order_items`   | Line items per order (product, quantity, price at sale)  |

**Relationships**
- One `customer` → many `orders` (1:N)
- One `order` → many `order_items` (1:N)
- One `product` → many `order_items` (1:N)

See [`erd/er_diagram.md`](erd/er_diagram.md) for the full diagram.

---

## 🚀 How to Run This Project

1. Install MySQL 8.0+ (or use a free sandbox like [DB Fiddle](https://www.db-fiddle.com/) set to MySQL).
2. Run the files **in this order**:
   ```bash
   mysql -u root -p < sql/01_schema.sql
   mysql -u root -p < sql/02_seed_data.sql
   mysql -u root -p < sql/03_queries.sql
   ```
   Or open each file in MySQL Workbench / DBeaver and execute top to bottom.
3. Explore! Every query in `03_queries.sql` is self-contained — run
   them individually and compare your output to the insight written
   below each one.

---

## 🎯 Business Questions Solved

This project answers the kinds of questions a real internship manager
would ask in the first month, grouped by SQL concept:

**Beginner**
- Who are our customers, and where are they based?
- What are our most expensive / most popular products?
- Which orders were placed in a given time window, or got cancelled?
- What's our total revenue, average order value, and average product price?

**Intermediate**
- Which categories and products drive the most revenue?
- Who are our repeat customers, and who has never ordered at all?
- Which products have never sold (dead stock)?
- Who are our above-average / VIP spenders?
- What does our month-over-month revenue trend look like?
- How do products and customers rank *within* their category or overall?
- What is a customer's order sequence, and their running (cumulative) spend?

A full mapped list lives in [`docs/business_questions.md`](docs/business_questions.md).

---

## 🧠 SQL Concepts Demonstrated

| Concept                                   | Where to find it        |
|--------------------------------------------|--------------------------|
| `SELECT`, `WHERE`, `ORDER BY`               | Queries 1–6               |
| Aggregate functions (`COUNT`, `SUM`, `AVG`) | Queries 7–11              |
| `GROUP BY` and `HAVING`                     | Queries 12–15             |
| `INNER JOIN` and `LEFT JOIN`                | Queries 16–20             |
| Subqueries (scalar & `IN`)                  | Queries 21–23             |
| Common Table Expressions (CTEs)             | Queries 24–25, 27–30      |
| Window functions: `ROW_NUMBER`, `RANK`, `DENSE_RANK`, running `SUM() OVER` | Queries 26–30 |

Every query includes:
1. **Business question** — what a manager would actually ask
2. **Explanation** — how the query works, in plain English
3. **Insight** — what to tell the manager after seeing the result

---

## 📊 Sample Insight (from the project)

> **Q12 — Revenue by category:** Electronics generates the highest
> total revenue even though its unit volume is on par with cheaper
> categories like Beauty and Books — a classic high-price/high-margin
> dynamic worth highlighting when deciding where to invest marketing
> budget.

---

## 🛠️ Tools Used

- **MySQL 8.0+** for all SQL (CTEs and window functions require 8.0+)
- Any SQL client works: MySQL Workbench, DBeaver, or the CLI

---

## 🙋 About This Project

This project was built as a hands-on portfolio piece to demonstrate
job-ready SQL skills for a **Data Analyst Internship**, following the
same workflow used in real analytics teams: understand the schema,
translate business questions into SQL, and turn results into
actionable insights.

**Skills demonstrated:** Data modeling · SQL querying · Joins ·
Subqueries · CTEs · Window functions · Business analysis ·
Data storytelling

---

## 📬 Contact

Feel free to connect if you have feedback or questions about this project!

Name- Antima Pandey 
