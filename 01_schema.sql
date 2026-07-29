-- =====================================================================
-- PROJECT   : Online Retail Sales Analysis
-- FILE      : 01_schema.sql
-- PURPOSE   : Creates the database and all tables used in this project
-- DIALECT   : MySQL 8.0+
-- =====================================================================

DROP DATABASE IF EXISTS online_retail_db;
CREATE DATABASE online_retail_db;
USE online_retail_db;

-- ---------------------------------------------------------------------
-- TABLE: customers
-- Stores basic profile information for every customer who has
-- registered on the online store.
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id     INT PRIMARY KEY AUTO_INCREMENT,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    city            VARCHAR(50),
    state           VARCHAR(50),
    signup_date     DATE NOT NULL
);

-- ---------------------------------------------------------------------
-- TABLE: products
-- Stores the product catalog: name, category, price and stock level.
-- ---------------------------------------------------------------------
CREATE TABLE products (
    product_id      INT PRIMARY KEY AUTO_INCREMENT,
    product_name    VARCHAR(100) NOT NULL,
    category        VARCHAR(50)  NOT NULL,
    price           DECIMAL(10,2) NOT NULL,
    stock_quantity  INT NOT NULL DEFAULT 0
);

-- ---------------------------------------------------------------------
-- TABLE: orders
-- One row per order placed by a customer (the "order header").
-- ---------------------------------------------------------------------
CREATE TABLE orders (
    order_id        INT PRIMARY KEY AUTO_INCREMENT,
    customer_id     INT NOT NULL,
    order_date      DATE NOT NULL,
    order_status    VARCHAR(20) NOT NULL DEFAULT 'Completed',
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ---------------------------------------------------------------------
-- TABLE: order_items
-- Line-item detail for each order (which products, how many, at what
-- price). An order can contain multiple products -> multiple rows.
-- ---------------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id   INT PRIMARY KEY AUTO_INCREMENT,
    order_id        INT NOT NULL,
    product_id      INT NOT NULL,
    quantity        INT NOT NULL,
    unit_price      DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ---------------------------------------------------------------------
-- Helpful indexes for the queries we will run later
-- (join/filter columns benefit most from indexing)
-- ---------------------------------------------------------------------
CREATE INDEX idx_orders_customer   ON orders(customer_id);
CREATE INDEX idx_orders_date       ON orders(order_date);
CREATE INDEX idx_items_order       ON order_items(order_id);
CREATE INDEX idx_items_product     ON order_items(product_id);
CREATE INDEX idx_products_category ON products(category);
