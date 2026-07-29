-- =====================================================================
-- PROJECT   : Online Retail Sales Analysis
-- FILE      : 02_seed_data.sql
-- PURPOSE   : Populates the tables with realistic sample data so the
--             analysis queries in 03_queries.sql return real results.
-- DIALECT   : MySQL 8.0+
-- =====================================================================

USE online_retail_db;

-- ---------------------------------------------------------------------
-- CUSTOMERS (20 customers across different Indian cities)
-- ---------------------------------------------------------------------
INSERT INTO customers (first_name, last_name, email, city, state, signup_date) VALUES
('Aarav',   'Sharma',   'aarav.sharma@mail.com',   'Delhi',      'Delhi',       '2023-01-12'),
('Vivaan',  'Verma',    'vivaan.verma@mail.com',   'Mumbai',     'Maharashtra', '2023-01-20'),
('Aditi',   'Iyer',     'aditi.iyer@mail.com',     'Bengaluru',  'Karnataka',   '2023-02-02'),
('Diya',    'Nair',     'diya.nair@mail.com',      'Kochi',      'Kerala',      '2023-02-15'),
('Kabir',   'Khan',     'kabir.khan@mail.com',     'Hyderabad',  'Telangana',   '2023-03-01'),
('Anaya',   'Gupta',    'anaya.gupta@mail.com',    'Delhi',      'Delhi',       '2023-03-10'),
('Reyansh', 'Patel',    'reyansh.patel@mail.com',  'Ahmedabad',  'Gujarat',     '2023-03-22'),
('Myra',    'Reddy',    'myra.reddy@mail.com',     'Hyderabad',  'Telangana',   '2023-04-05'),
('Vihaan',  'Joshi',    'vihaan.joshi@mail.com',   'Pune',       'Maharashtra', '2023-04-18'),
('Saanvi',  'Chawla',   'saanvi.chawla@mail.com',  'Chandigarh', 'Punjab',      '2023-05-02'),
('Arjun',   'Mehta',    'arjun.mehta@mail.com',    'Mumbai',     'Maharashtra', '2023-05-14'),
('Ishita',  'Rao',      'ishita.rao@mail.com',     'Bengaluru',  'Karnataka',   '2023-06-01'),
('Kian',    'Malhotra', 'kian.malhotra@mail.com',  'Delhi',      'Delhi',       '2023-06-19'),
('Navya',   'Kapoor',   'navya.kapoor@mail.com',   'Jaipur',     'Rajasthan',   '2023-07-03'),
('Aryan',   'Bose',     'aryan.bose@mail.com',     'Kolkata',    'West Bengal', '2023-07-21'),
('Riya',    'Menon',    'riya.menon@mail.com',     'Kochi',      'Kerala',      '2023-08-09'),
('Dev',     'Saxena',   'dev.saxena@mail.com',     'Lucknow',    'Uttar Pradesh','2023-08-27'),
('Prisha',  'Agarwal',  'prisha.agarwal@mail.com', 'Pune',       'Maharashtra', '2023-09-11'),
('Yuvraj',  'Singh',    'yuvraj.singh@mail.com',   'Chandigarh', 'Punjab',      '2023-09-30'),
('Kiara',   'Desai',    'kiara.desai@mail.com',    'Ahmedabad',  'Gujarat',     '2023-10-15'),
('Ananya',  'Pillai',   'ananya.pillai@mail.com',  'Chennai',    'Tamil Nadu',  '2023-11-01');
-- NOTE: Ananya Pillai (customer_id 21) intentionally has ZERO orders below.
-- This lets us practice identifying "registered but never purchased"
-- customers with a LEFT JOIN later in 03_queries.sql.

-- ---------------------------------------------------------------------
-- PRODUCTS (20 products across 6 categories)
-- ---------------------------------------------------------------------
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
('Wireless Earbuds Pro',        'Electronics',      2999.00, 150),
('Smartwatch Series 5',         'Electronics',      6499.00, 90),
('Bluetooth Speaker Mini',      'Electronics',      1799.00, 200),
('4K Action Camera',            'Electronics',      8999.00, 40),
('Laptop Backpack',             'Fashion',          1499.00, 180),
('Men Running Shoes',           'Fashion',          2599.00, 130),
('Women Handbag Classic',       'Fashion',          2199.00, 100),
('Cotton T-Shirt Pack (3)',     'Fashion',           899.00, 300),
('Non-Stick Cookware Set',      'Home & Kitchen',   3499.00,  75),
('Electric Kettle 1.5L',        'Home & Kitchen',   1299.00, 160),
('LED Desk Lamp',               'Home & Kitchen',    899.00, 220),
('Memory Foam Pillow',          'Home & Kitchen',   1099.00, 140),
('Herbal Face Wash',            'Beauty',            349.00, 400),
('Matte Lipstick Combo',        'Beauty',            599.00, 250),
('Hair Dryer 1200W',            'Beauty',           1599.00, 110),
('Yoga Mat Anti-Slip',          'Sports',            799.00, 210),
('Adjustable Dumbbell Set',     'Sports',           4499.00,  60),
('Cricket Bat Kashmir Willow',  'Sports',           1899.00,  85),
('Self-Help Bestseller Book',   'Books',             399.00, 260),
('Data Analytics Handbook',     'Books',             699.00, 175),
('Wireless Charging Pad',       'Electronics',       1299.00, 130);
-- NOTE: Wireless Charging Pad (product_id 21) intentionally has ZERO
-- sales below. This lets us practice identifying "dead stock" /
-- never-sold products with a LEFT JOIN later in 03_queries.sql.

-- ---------------------------------------------------------------------
-- ORDERS (35 orders spread across 2023-11-01 to 2024-02-20)
-- Status values used: 'Completed', 'Cancelled', 'Pending'
-- ---------------------------------------------------------------------
INSERT INTO orders (customer_id, order_date, order_status) VALUES
(1,  '2023-11-02', 'Completed'),
(2,  '2023-11-03', 'Completed'),
(3,  '2023-11-05', 'Completed'),
(1,  '2023-11-09', 'Completed'),
(4,  '2023-11-12', 'Cancelled'),
(5,  '2023-11-14', 'Completed'),
(6,  '2023-11-18', 'Completed'),
(2,  '2023-11-20', 'Completed'),
(7,  '2023-11-22', 'Completed'),
(8,  '2023-11-25', 'Pending'),
(9,  '2023-11-27', 'Completed'),
(3,  '2023-11-29', 'Completed'),
(10, '2023-12-01', 'Completed'),
(11, '2023-12-03', 'Completed'),
(1,  '2023-12-05', 'Completed'),
(12, '2023-12-08', 'Completed'),
(13, '2023-12-10', 'Cancelled'),
(6,  '2023-12-12', 'Completed'),
(14, '2023-12-15', 'Completed'),
(2,  '2023-12-18', 'Completed'),
(15, '2023-12-20', 'Completed'),
(16, '2023-12-22', 'Completed'),
(9,  '2023-12-24', 'Pending'),
(17, '2023-12-27', 'Completed'),
(5,  '2023-12-29', 'Completed'),
(18, '2024-01-03', 'Completed'),
(3,  '2024-01-06', 'Completed'),
(19, '2024-01-09', 'Completed'),
(8,  '2024-01-12', 'Completed'),
(20, '2024-01-15', 'Completed'),
(11, '2024-01-19', 'Completed'),
(1,  '2024-01-22', 'Completed'),
(7,  '2024-01-27', 'Cancelled'),
(14, '2024-02-05', 'Completed'),
(2,  '2024-02-20', 'Completed');

-- ---------------------------------------------------------------------
-- ORDER_ITEMS (line items for each order above)
-- unit_price is captured at the time of sale, so it can differ slightly
-- from the current catalog price in `products` (this mirrors real life).
-- ---------------------------------------------------------------------
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
-- Order 1
(1, 1, 1, 2999.00), (1, 13, 2, 349.00),
-- Order 2
(2, 6, 1, 2599.00),
-- Order 3
(3, 9, 1, 3499.00), (3, 10, 1, 1299.00),
-- Order 4
(4, 3, 2, 1799.00),
-- Order 5 (cancelled)
(5, 2, 1, 6499.00),
-- Order 6
(6, 16, 1, 799.00), (6, 17, 1, 4499.00),
-- Order 7
(7, 19, 3, 399.00),
-- Order 8
(8, 1, 1, 2999.00), (8, 5, 1, 1499.00),
-- Order 9
(9, 7, 1, 2199.00),
-- Order 10 (pending)
(10, 4, 1, 8999.00),
-- Order 11
(11, 14, 2, 599.00), (11, 15, 1, 1599.00),
-- Order 12
(12, 20, 1, 699.00), (12, 19, 1, 399.00),
-- Order 13
(13, 8, 4, 899.00),
-- Order 14
(14, 2, 1, 6499.00),
-- Order 15
(15, 11, 2, 899.00),
-- Order 16
(16, 6, 1, 2599.00), (16, 16, 1, 799.00),
-- Order 17 (cancelled)
(17, 4, 1, 8999.00),
-- Order 18
(18, 12, 1, 1099.00), (18, 10, 1, 1299.00),
-- Order 19
(19, 1, 2, 2999.00),
-- Order 20
(20, 18, 1, 1899.00),
-- Order 21
(21, 9, 1, 3499.00),
-- Order 22
(22, 3, 1, 1799.00), (22, 13, 1, 349.00),
-- Order 23 (pending)
(23, 7, 1, 2199.00),
-- Order 24
(24, 17, 1, 4499.00),
-- Order 25
(25, 5, 2, 1499.00),
-- Order 26
(26, 1, 1, 2999.00), (26, 14, 1, 599.00),
-- Order 27
(27, 9, 1, 3499.00), (27, 11, 1, 899.00),
-- Order 28
(28, 20, 2, 699.00),
-- Order 29
(29, 2, 1, 6499.00),
-- Order 30
(30, 6, 2, 2599.00),
-- Order 31
(31, 15, 1, 1599.00), (31, 13, 3, 349.00),
-- Order 32
(32, 1, 1, 2999.00),
-- Order 33 (cancelled)
(33, 4, 1, 8999.00),
-- Order 34
(34, 19, 2, 399.00), (34, 20, 1, 699.00),
-- Order 35
(35, 3, 1, 1799.00), (35, 16, 1, 799.00);
