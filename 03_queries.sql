-- =====================================================================
-- PROJECT   : Online Retail Sales Analysis
-- FILE      : 03_queries.sql
-- PURPOSE   : 27 business-driven SQL queries, ordered from beginner to
--             intermediate level, as would be assigned to a Data
--             Analyst Intern in their first few weeks on the job.
-- DIALECT   : MySQL 8.0+
--
-- Every query follows the same three-part pattern:
--   1. BUSINESS QUESTION -> what the manager actually asked
--   2. EXPLANATION        -> what the query does, in plain English
--   3. INSIGHT             -> what we'd tell the manager after running it
-- =====================================================================

USE online_retail_db;


-- #####################################################################
-- SECTION 1: SELECT, WHERE, ORDER BY  (Beginner)
-- #####################################################################

-- ---------------------------------------------------------------------
-- Q1. BUSINESS QUESTION: "Show me the full customer list."
-- EXPLANATION: A plain SELECT * pulls every column and every row from
--              the customers table. This is usually the first query
--              anyone runs to see what data they're working with.
-- ---------------------------------------------------------------------
SELECT *
FROM customers;

-- INSIGHT: We have 21 registered customers spread across 13 Indian
-- cities, giving us a reasonably diverse base to segment by geography.


-- ---------------------------------------------------------------------
-- Q2. BUSINESS QUESTION: "Which customers are based in Delhi?"
-- EXPLANATION: WHERE filters rows so only customers whose city column
--              equals 'Delhi' are returned.
-- ---------------------------------------------------------------------
SELECT customer_id, first_name, last_name, email
FROM customers
WHERE city = 'Delhi';

-- INSIGHT: Delhi is one of our top customer hubs (3 of 21 customers,
-- ~14% of the base) -- a strong candidate city for a regional promotion.


-- ---------------------------------------------------------------------
-- Q3. BUSINESS QUESTION: "List all products priced above ₹2,000,
--     cheapest first."
-- EXPLANATION: WHERE filters on price, ORDER BY price ASC sorts the
--              results from lowest to highest.
-- ---------------------------------------------------------------------
SELECT product_name, category, price
FROM products
WHERE price > 2000
ORDER BY price ASC;

-- INSIGHT: 7 of our 21 products sit in the "premium" (>₹2,000) band,
-- concentrated mostly in Electronics and Sports -- useful for deciding
-- which categories to feature in a high-ticket marketing campaign.


-- ---------------------------------------------------------------------
-- Q4. BUSINESS QUESTION: "What are our 5 most expensive products?"
-- EXPLANATION: ORDER BY price DESC sorts highest-to-lowest; LIMIT 5
--              keeps only the top 5 rows.
-- ---------------------------------------------------------------------
SELECT product_name, category, price
FROM products
ORDER BY price DESC
LIMIT 5;

-- INSIGHT: The 4K Action Camera (₹8,999) and Smartwatch Series 5
-- (₹6,499) are our flagship-priced items -- good hero products for
-- homepage banners since they carry the highest margin potential.


-- ---------------------------------------------------------------------
-- Q5. BUSINESS QUESTION: "Show all orders placed in December 2023."
-- EXPLANATION: WHERE with a BETWEEN clause filters order_date to a
--              specific date range.
-- ---------------------------------------------------------------------
SELECT order_id, customer_id, order_date, order_status
FROM orders
WHERE order_date BETWEEN '2023-12-01' AND '2023-12-31'
ORDER BY order_date;

-- INSIGHT: December logged 13 of our 35 total orders (~37%) -- clear
-- evidence of a holiday-season spike worth planning inventory around.


-- ---------------------------------------------------------------------
-- Q6. BUSINESS QUESTION: "Which orders were cancelled?"
-- EXPLANATION: A simple equality filter on order_status.
-- ---------------------------------------------------------------------
SELECT order_id, customer_id, order_date
FROM orders
WHERE order_status = 'Cancelled';

-- INSIGHT: 3 of 35 orders (~8.6%) were cancelled. That's within a
-- normal e-commerce range (typically 5-10%), so no red flag yet, but
-- worth tracking monthly.


-- #####################################################################
-- SECTION 2: AGGREGATE FUNCTIONS  (Beginner)
-- #####################################################################

-- ---------------------------------------------------------------------
-- Q7. BUSINESS QUESTION: "How many customers do we have in total?"
-- EXPLANATION: COUNT(*) counts every row in the table.
-- ---------------------------------------------------------------------
SELECT COUNT(*) AS total_customers
FROM customers;

-- INSIGHT: 21 customers total -- a small but workable dataset for
-- practicing segmentation and retention analysis.


-- ---------------------------------------------------------------------
-- Q8. BUSINESS QUESTION: "What is our average product price?"
-- EXPLANATION: AVG() calculates the mean of the price column.
-- ---------------------------------------------------------------------
SELECT ROUND(AVG(price), 2) AS avg_product_price
FROM products;

-- INSIGHT: The average catalog price is roughly ₹2,211, giving us a
-- benchmark to classify products as "budget" vs "premium".


-- ---------------------------------------------------------------------
-- Q9. BUSINESS QUESTION: "What is the total revenue generated from
--     completed orders?"
-- EXPLANATION: We JOIN order_items to orders so we can filter by
--              order_status, then SUM(quantity * unit_price) to get
--              revenue. Cancelled/Pending orders are excluded because
--              they haven't actually generated confirmed revenue.
-- ---------------------------------------------------------------------
SELECT ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed';

-- INSIGHT: Completed orders have generated a little over ₹1 lakh in
-- revenue in this sample window -- our baseline figure for measuring
-- month-over-month growth.


-- ---------------------------------------------------------------------
-- Q10. BUSINESS QUESTION: "What is the average value of a completed
--      order?"
-- EXPLANATION: We first compute revenue per order in a subquery, then
--              take the AVG() of those order totals. This is different
--              from averaging line items -- it answers "how much does
--              a typical basket cost?"
-- ---------------------------------------------------------------------
SELECT ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY o.order_id
) AS order_totals;

-- INSIGHT: The average completed order is worth roughly ₹3,300 -- a
-- useful KPI ("Average Order Value" / AOV) to track against future
-- discount campaigns, since deep discounts often shrink AOV.


-- ---------------------------------------------------------------------
-- Q11. BUSINESS QUESTION: "How many units of each product have been
--      sold (completed orders only)?"
-- EXPLANATION: SUM(quantity) rolled up per product via GROUP BY.
-- ---------------------------------------------------------------------
SELECT p.product_name, SUM(oi.quantity) AS units_sold
FROM order_items oi
INNER JOIN orders o   ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_name
ORDER BY units_sold DESC;

-- INSIGHT: Wireless Earbuds Pro, the Self-Help Bestseller Book and
-- Herbal Face Wash are tied for the most units sold -- a mix of price
-- points confirming that volume leaders aren't always the cheapest
-- items, which is useful context when planning bundle deals.


-- #####################################################################
-- SECTION 3: GROUP BY and HAVING  (Beginner -> Intermediate)
-- #####################################################################

-- ---------------------------------------------------------------------
-- Q12. BUSINESS QUESTION: "What is the total revenue per product
--      category?"
-- EXPLANATION: GROUP BY category rolls up all products in the same
--              category into one row; SUM() adds up their revenue.
-- ---------------------------------------------------------------------
SELECT p.category,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS category_revenue
FROM order_items oi
INNER JOIN orders o   ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY category_revenue DESC;

-- INSIGHT: Electronics dominates total revenue even though its unit
-- volume is on par with cheaper categories like Beauty and Books --
-- a classic high-price/high-margin dynamic worth highlighting to
-- management when deciding where to invest marketing budget.


-- ---------------------------------------------------------------------
-- Q13. BUSINESS QUESTION: "How many completed orders has each customer
--      placed?"
-- EXPLANATION: GROUP BY customer_id + COUNT() counts rows per group.
-- ---------------------------------------------------------------------
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC;

-- INSIGHT: A handful of customers have placed 2+ completed orders --
-- these repeat buyers are prime targets for a loyalty program.


-- ---------------------------------------------------------------------
-- Q14. BUSINESS QUESTION: "Which customers have placed more than 1
--      completed order?" (i.e. identify repeat customers only)
-- EXPLANATION: HAVING filters groups AFTER aggregation -- unlike
--              WHERE, which can only filter individual rows before
--              grouping. Here we keep only customers whose order COUNT
--              exceeds 1.
-- ---------------------------------------------------------------------
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- INSIGHT: Repeat customers make up a meaningful slice of our active
-- buyers -- worth measuring our repeat-purchase rate every month as a
-- retention KPI.


-- ---------------------------------------------------------------------
-- Q15. BUSINESS QUESTION: "Which product categories generate more than
--      ₹15,000 in total revenue?"
-- EXPLANATION: Same idea as Q14, but HAVING filters on SUM() instead
--              of COUNT() -- this is the classic "filter after
--              aggregating" use case.
-- ---------------------------------------------------------------------
SELECT p.category,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS category_revenue
FROM order_items oi
INNER JOIN orders o   ON oi.order_id = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
HAVING SUM(oi.quantity * oi.unit_price) > 15000
ORDER BY category_revenue DESC;

-- INSIGHT: Only 2-3 categories clear the ₹15,000 mark -- these are
-- our "core" categories and deserve the biggest share of ad spend.


-- #####################################################################
-- SECTION 4: JOINS  (Intermediate)
-- #####################################################################

-- ---------------------------------------------------------------------
-- Q16. BUSINESS QUESTION: "Give me a full list of orders with the
--      customer's name attached."
-- EXPLANATION: INNER JOIN returns only rows that have a match in BOTH
--              tables -- here, every order that has a valid customer.
-- ---------------------------------------------------------------------
SELECT o.order_id, o.order_date, o.order_status,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

-- INSIGHT: This is the base "single source of truth" view analysts use
-- for almost every downstream report -- worth saving as a reusable VIEW.


-- ---------------------------------------------------------------------
-- Q17. BUSINESS QUESTION: "Break every order down into its individual
--      products, with product name and category."
-- EXPLANATION: A 3-table INNER JOIN chains orders -> order_items ->
--              products so we can see exactly what was bought in each
--              order.
-- ---------------------------------------------------------------------
SELECT o.order_id, o.order_date, p.product_name, p.category,
       oi.quantity, oi.unit_price,
       (oi.quantity * oi.unit_price) AS line_total
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p     ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- INSIGHT: This line-item-level view is the foundation for almost
-- every revenue, category, and product query in this project.


-- ---------------------------------------------------------------------
-- Q18. BUSINESS QUESTION: "Which customers have NEVER placed an
--      order?" (useful for a "win-back" email campaign)
-- EXPLANATION: LEFT JOIN keeps every customer row regardless of
--              whether they have a matching order; customers with no
--              orders will show NULL in the order_id column, which we
--              then filter for with WHERE o.order_id IS NULL.
-- ---------------------------------------------------------------------
SELECT c.customer_id, c.first_name, c.last_name, c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- INSIGHT: At least one registered customer has never checked out --
-- a prime candidate for a "welcome back" discount code to convert
-- them into a first-time buyer.


-- ---------------------------------------------------------------------
-- Q19. BUSINESS QUESTION: "Which products have never actually been
--      sold?" (useful for identifying dead stock)
-- EXPLANATION: Same LEFT JOIN + IS NULL pattern as Q18, applied to
--              products instead of customers.
-- ---------------------------------------------------------------------
SELECT p.product_id, p.product_name, p.category, p.stock_quantity
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- INSIGHT: The product(s) returned here are tying up capital in
-- unsold stock -- strong candidates for a clearance discount or
-- bundling with a best-seller.


-- ---------------------------------------------------------------------
-- Q20. BUSINESS QUESTION: "For each customer, how much have they
--      spent in total (including customers who spent ₹0)?"
-- EXPLANATION: LEFT JOIN from customers all the way through to
--              order_items ensures customers with no purchases still
--              appear, with COALESCE turning their NULL total into 0.
-- ---------------------------------------------------------------------
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_spent
FROM customers c
LEFT JOIN orders o       ON c.customer_id = o.customer_id AND o.order_status = 'Completed'
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC;

-- INSIGHT: This full customer-spend view (including zero-spenders) is
-- exactly what a marketing team needs to build tiered customer
-- segments -- e.g. "High Value", "Low Value", "Never Purchased".


-- #####################################################################
-- SECTION 5: SUBQUERIES  (Intermediate)
-- #####################################################################

-- ---------------------------------------------------------------------
-- Q21. BUSINESS QUESTION: "Which products are priced above the average
--      product price?"
-- EXPLANATION: The inner query (SELECT AVG(price)...) runs first and
--              returns a single number; the outer query then compares
--              every product's price against that number.
-- ---------------------------------------------------------------------
SELECT product_name, category, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- INSIGHT: 6 products sit above the average price point -- these carry
-- more margin per unit and should be prioritized in upsell prompts at
-- checkout.


-- ---------------------------------------------------------------------
-- Q22. BUSINESS QUESTION: "Which customers have spent more than the
--      average customer?" (identify our high-value customers)
-- EXPLANATION: The inner subquery calculates total spend per customer;
--              a second subquery averages those totals; the outer
--              query keeps only customers above that average.
-- ---------------------------------------------------------------------
SELECT customer_name, total_spent
FROM (
    SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    INNER JOIN orders o       ON c.customer_id = o.customer_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, customer_name
) AS customer_spend
WHERE total_spent > (
    SELECT AVG(cust_total)
    FROM (
        SELECT SUM(oi.quantity * oi.unit_price) AS cust_total
        FROM orders o
        INNER JOIN order_items oi ON o.order_id = oi.order_id
        WHERE o.order_status = 'Completed'
        GROUP BY o.customer_id
    ) AS sub
)
ORDER BY total_spent DESC;

-- INSIGHT: This "above-average spender" list is a ready-made VIP
-- segment -- a great starting point for an exclusive early-access
-- sale.


-- ---------------------------------------------------------------------
-- Q23. BUSINESS QUESTION: "Which orders included at least one product
--      from the Electronics category?"
-- EXPLANATION: An IN subquery first finds every order_id that touched
--              an Electronics product, then the outer query pulls the
--              full order details for those IDs.
-- ---------------------------------------------------------------------
SELECT order_id, customer_id, order_date, order_status
FROM orders
WHERE order_id IN (
    SELECT oi.order_id
    FROM order_items oi
    INNER JOIN products p ON oi.product_id = p.product_id
    WHERE p.category = 'Electronics'
);

-- INSIGHT: Electronics appears in 14 of 35 orders (40%) -- confirming
-- it's a strong traffic-driving category even though it's not always
-- the biggest basket by item count.


-- #####################################################################
-- SECTION 6: COMMON TABLE EXPRESSIONS (CTEs)  (Intermediate)
-- #####################################################################

-- ---------------------------------------------------------------------
-- Q24. BUSINESS QUESTION: "What is our month-by-month revenue trend?"
-- EXPLANATION: A CTE (WITH ... AS (...)) lets us name a temporary
--              result set -- here, revenue per order -- and reuse it
--              cleanly in the final SELECT, instead of nesting
--              subqueries inside subqueries.
-- ---------------------------------------------------------------------
WITH order_revenue AS (
    SELECT o.order_id,
           DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
           SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY o.order_id, order_month
)
SELECT order_month,
       COUNT(order_id)        AS total_orders,
       ROUND(SUM(order_total), 2) AS monthly_revenue
FROM order_revenue
GROUP BY order_month
ORDER BY order_month;

-- INSIGHT: Revenue peaks in December and holds strong into January --
-- consistent with a holiday-shopping and New Year sales pattern, and
-- useful for planning next year's ad budget by month.


-- ---------------------------------------------------------------------
-- Q25. BUSINESS QUESTION: "Rank our product categories by total
--      revenue, using a CTE to keep the logic readable."
-- EXPLANATION: The CTE first computes revenue per category; the outer
--              query then simply orders and ranks the CTE's output.
-- ---------------------------------------------------------------------
WITH category_sales AS (
    SELECT p.category,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM order_items oi
    INNER JOIN orders o   ON oi.order_id = o.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Completed'
    GROUP BY p.category
)
SELECT category,
       ROUND(revenue, 2) AS revenue,
       RANK() OVER (ORDER BY revenue DESC) AS category_rank
FROM category_sales;

-- INSIGHT: Electronics and Fashion rank #1 and #2 -- these two
-- categories alone account for well over half of total revenue, so
-- any site-wide promotion should lead with them.


-- #####################################################################
-- SECTION 7: WINDOW FUNCTIONS  (Intermediate)
-- #####################################################################

-- ---------------------------------------------------------------------
-- Q26. BUSINESS QUESTION: "For each customer, tag their orders in
--      chronological order (1st order, 2nd order, 3rd order...)."
-- EXPLANATION: ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY
--              order_date) restarts the count at 1 for every new
--              customer and increases by exactly 1 each row, with no
--              ties -- perfect for finding "first order" vs "repeat
--              orders."
-- ---------------------------------------------------------------------
SELECT customer_id, order_id, order_date,
       ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_sequence
FROM orders
WHERE order_status = 'Completed'
ORDER BY customer_id, order_sequence;

-- INSIGHT: Filtering this result to order_sequence = 1 instantly gives
-- us every customer's first-ever purchase -- the basis for a
-- "first purchase category" analysis (which category hooks new
-- customers best).


-- ---------------------------------------------------------------------
-- Q27. BUSINESS QUESTION: "Rank products within each category by
--      revenue, and show the top 2 performers per category."
-- EXPLANATION: RANK() OVER (PARTITION BY category ORDER BY revenue
--              DESC) restarts ranking for every category. Unlike
--              ROW_NUMBER, RANK() gives tied values the same rank and
--              skips the next number (e.g. 1, 2, 2, 4) -- a truer
--              reflection of a genuine tie in revenue.
-- ---------------------------------------------------------------------
WITH product_revenue AS (
    SELECT p.category, p.product_name,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM order_items oi
    INNER JOIN orders o   ON oi.order_id = o.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Completed'
    GROUP BY p.category, p.product_name
),
ranked_products AS (
    SELECT category, product_name, revenue,
           RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS category_rank
    FROM product_revenue
)
SELECT category, product_name, ROUND(revenue, 2) AS revenue, category_rank
FROM ranked_products
WHERE category_rank <= 2
ORDER BY category, category_rank;

-- INSIGHT: These top-2-per-category products are our "hero SKUs" --
-- the ones that should always be in stock and featured on category
-- landing pages.


-- ---------------------------------------------------------------------
-- Q28. BUSINESS QUESTION: "Rank customers by total spend, but this
--      time don't skip numbers when there's a tie."
-- EXPLANATION: DENSE_RANK() behaves like RANK() but never skips a
--              number after a tie (e.g. 1, 2, 2, 3 instead of
--              1, 2, 2, 4) -- useful when we want clean, consecutive
--              tier numbers for a loyalty program (Tier 1, Tier 2...).
-- ---------------------------------------------------------------------
WITH customer_spend AS (
    SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    INNER JOIN orders o       ON c.customer_id = o.customer_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, customer_name
)
SELECT customer_name,
       ROUND(total_spent, 2) AS total_spent,
       DENSE_RANK() OVER (ORDER BY total_spent DESC) AS spend_tier
FROM customer_spend
ORDER BY spend_tier;

-- INSIGHT: These clean, consecutive spend tiers map directly onto a
-- 3-tier loyalty program (e.g. Gold/Silver/Bronze) without gaps in
-- the numbering, which is much easier to communicate to customers.


-- ---------------------------------------------------------------------
-- Q29. BUSINESS QUESTION: "Show a running (cumulative) revenue total
--      by month, so we can see growth over time."
-- EXPLANATION: SUM() OVER (ORDER BY order_month) is a window function
--              that keeps adding each month's revenue to a running
--              total, without collapsing rows the way GROUP BY does.
-- ---------------------------------------------------------------------
WITH monthly_revenue AS (
    SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY order_month
)
SELECT order_month,
       ROUND(revenue, 2) AS monthly_revenue,
       ROUND(SUM(revenue) OVER (ORDER BY order_month), 2) AS running_total_revenue
FROM monthly_revenue
ORDER BY order_month;

-- INSIGHT: The running total makes it easy to see we crossed key
-- revenue milestones by December -- a chart-ready metric for a
-- monthly business review deck.


-- ---------------------------------------------------------------------
-- Q30. BUSINESS QUESTION: "Who are our top 3 highest-spending
--      customers overall?" (final capstone query combining CTE +
--      window function + filtering)
-- EXPLANATION: We compute total spend per customer in a CTE, rank
--              customers with ROW_NUMBER(), then keep only rank 1-3
--              in the outer query -- a clean way to answer "top N per
--              group" questions in SQL.
-- ---------------------------------------------------------------------
WITH customer_totals AS (
    SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    INNER JOIN orders o       ON c.customer_id = o.customer_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, customer_name
),
ranked_customers AS (
    SELECT customer_name, total_spent,
           ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS rn
    FROM customer_totals
)
SELECT customer_name, ROUND(total_spent, 2) AS total_spent
FROM ranked_customers
WHERE rn <= 3;

-- INSIGHT: These 3 customers are our most valuable accounts -- a
-- prime list to hand to the customer-success team for personal
-- outreach (thank-you note, early access to new arrivals, etc.).

-- =====================================================================
-- END OF FILE -- 30 business-driven queries covering every requested
-- SQL concept, each with a plain-English explanation and a takeaway
-- insight, mirroring the deliverables of a real Data Analyst
-- internship task.
-- =====================================================================
