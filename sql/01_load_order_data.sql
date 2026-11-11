-- 01_load_order_data.sql
-- Capstone #4 E-Commerce Order Intelligence Bot: demo order data
-- Creates + fills customers / orders / deliveries. Safe to re-run.
-- Order dates converted from DD-MM-YYYY to ISO (YYYY-MM-DD).

DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  customer_id  TEXT PRIMARY KEY,
  name         TEXT NOT NULL,
  email        TEXT,
  phone        TEXT,
  city         TEXT,
  state        TEXT,
  segment      TEXT CHECK (segment IN ('Premium','Regular','New')),
  joined_date  DATE
);

CREATE TABLE orders (
  order_id        TEXT PRIMARY KEY,
  customer_id     TEXT NOT NULL REFERENCES customers(customer_id),
  order_date      DATE NOT NULL,
  product         TEXT NOT NULL,
  category        TEXT NOT NULL,
  quantity        INTEGER NOT NULL CHECK (quantity > 0),
  amount_inr      NUMERIC(10,2) NOT NULL,
  payment_method  TEXT,
  order_status    TEXT CHECK (order_status IN ('Placed','Processing','Shipped','Delivered','Cancelled','Returned'))
);

CREATE TABLE deliveries (
  delivery_id       TEXT PRIMARY KEY,
  order_id          TEXT NOT NULL UNIQUE REFERENCES orders(order_id),
  courier           TEXT,
  tracking_number   TEXT,
  ship_date         DATE,
  expected_date     DATE,
  delivered_date    DATE,
  delivery_status   TEXT,
  current_location  TEXT,
  delay_reason      TEXT
);

INSERT INTO customers VALUES
  ('C001', 'Aarav Mehta', 'aarav.mehta@example.com', '+91-98200-11001', 'Mumbai', 'Maharashtra', 'Premium', '2023-02-14'),
  ('C002', 'Priya Nair', 'priya.nair@example.com', '+91-98450-22002', 'Bengaluru', 'Karnataka', 'Regular', '2023-05-30'),
  ('C003', 'Rohan Gupta', 'rohan.gupta@example.com', '+91-98110-33003', 'New Delhi', 'Delhi', 'Premium', '2022-11-08'),
  ('C004', 'Sneha Iyer', 'sneha.iyer@example.com', '+91-98840-44004', 'Chennai', 'Tamil Nadu', 'Regular', '2024-01-19'),
  ('C005', 'Vikram Singh', 'vikram.singh@example.com', '+91-98290-55005', 'Jaipur', 'Rajasthan', 'New', '2025-08-02'),
  ('C006', 'Ananya Das', 'ananya.das@example.com', '+91-98300-66006', 'Kolkata', 'West Bengal', 'Regular', '2024-03-25'),
  ('C007', 'Karan Malhotra', 'karan.malhotra@example.com', '+91-98760-77007', 'Chandigarh', 'Punjab', 'Premium', '2022-07-12'),
  ('C008', 'Meera Reddy', 'meera.reddy@example.com', '+91-98490-88008', 'Hyderabad', 'Telangana', 'Regular', '2024-09-09'),
  ('C009', 'Imran Sheikh', 'imran.sheikh@example.com', '+91-98920-99009', 'Pune', 'Maharashtra', 'New', '2025-09-21'),
  ('C010', 'Divya Pillai', 'divya.pillai@example.com', '+91-98470-10010', 'Kochi', 'Kerala', 'Premium', '2023-10-03'),
  ('C011', 'Arjun Verma', 'arjun.verma@example.com', '+91-98260-12011', 'Lucknow', 'Uttar Pradesh', 'Regular', '2024-06-17'),
  ('C012', 'Neha Kapoor', 'neha.kapoor@example.com', '+91-98100-13012', 'Gurugram', 'Haryana', 'Regular', '2025-01-28');

INSERT INTO orders VALUES
  ('ORD-1001', 'C001', '2026-09-02', 'Noise-Cancelling Headphones', 'Electronics', 1, 12999, 'Credit Card', 'Delivered'),
  ('ORD-1002', 'C002', '2026-09-04', 'Running Shoes', 'Footwear', 2, 7998, 'UPI', 'Delivered'),
  ('ORD-1003', 'C003', '2026-09-05', 'Smart Watch', 'Electronics', 1, 18499, 'Credit Card', 'Delivered'),
  ('ORD-1004', 'C004', '2026-09-10', 'Cotton Kurta Set', 'Apparel', 3, 4797, 'UPI', 'Delivered'),
  ('ORD-1005', 'C005', '2026-09-12', 'Bluetooth Speaker', 'Electronics', 1, 3499, 'Cash on Delivery', 'Cancelled'),
  ('ORD-1006', 'C006', '2026-09-15', 'Air Fryer', 'Home & Kitchen', 1, 6990, 'Debit Card', 'Delivered'),
  ('ORD-1007', 'C007', '2026-09-18', 'Laptop Backpack', 'Accessories', 2, 3598, 'UPI', 'Delivered'),
  ('ORD-1008', 'C008', '2026-09-20', 'Yoga Mat', 'Fitness', 1, 1299, 'UPI', 'Returned'),
  ('ORD-1009', 'C001', '2026-09-24', 'Mechanical Keyboard', 'Electronics', 1, 5499, 'Credit Card', 'Delivered'),
  ('ORD-1010', 'C009', '2026-09-27', 'Mixer Grinder', 'Home & Kitchen', 1, 4250, 'Cash on Delivery', 'Delivered'),
  ('ORD-1011', 'C010', '2026-09-29', 'Silk Saree', 'Apparel', 1, 9800, 'Credit Card', 'Delivered'),
  ('ORD-1012', 'C003', '2026-10-01', '4K Monitor', 'Electronics', 1, 24999, 'Credit Card', 'Shipped'),
  ('ORD-1013', 'C011', '2026-10-02', 'Water Purifier', 'Home & Kitchen', 1, 14500, 'Debit Card', 'Shipped'),
  ('ORD-1014', 'C002', '2026-10-03', 'Fitness Band', 'Electronics', 1, 2999, 'UPI', 'Shipped'),
  ('ORD-1015', 'C012', '2026-10-04', 'Office Chair', 'Furniture', 1, 11250, 'Credit Card', 'Shipped'),
  ('ORD-1016', 'C007', '2026-10-05', 'Trekking Boots', 'Footwear', 1, 6499, 'UPI', 'Processing'),
  ('ORD-1017', 'C004', '2026-10-06', 'Coffee Maker', 'Home & Kitchen', 1, 8750, 'Credit Card', 'Processing'),
  ('ORD-1018', 'C006', '2026-10-07', 'Wireless Mouse', 'Electronics', 2, 1798, 'UPI', 'Processing'),
  ('ORD-1019', 'C010', '2026-10-08', 'Tablet 10-inch', 'Electronics', 1, 21999, 'Credit Card', 'Processing'),
  ('ORD-1020', 'C008', '2026-10-09', 'Desk Lamp', 'Home & Kitchen', 2, 1998, 'UPI', 'Placed');

INSERT INTO deliveries VALUES
  ('DLV-5001', 'ORD-1001', 'BlueDart', 'BD7781001', '2026-09-03', '2026-09-06', '2026-09-05', 'Delivered', 'Mumbai', NULL),
  ('DLV-5002', 'ORD-1002', 'Delhivery', 'DL4402002', '2026-09-05', '2026-09-09', '2026-09-09', 'Delivered', 'Bengaluru', NULL),
  ('DLV-5003', 'ORD-1003', 'BlueDart', 'BD7781003', '2026-09-06', '2026-09-09', '2026-09-11', 'Delivered', 'New Delhi', 'Heavy rain disrupted hub operations'),
  ('DLV-5004', 'ORD-1004', 'Ecom Express', 'EE9904004', '2026-09-11', '2026-09-16', '2026-09-15', 'Delivered', 'Chennai', NULL),
  ('DLV-5005', 'ORD-1005', 'Delhivery', 'DL4402005', NULL, NULL, NULL, 'Cancelled', NULL, 'Order cancelled before dispatch'),
  ('DLV-5006', 'ORD-1006', 'India Post', 'IP1106006', '2026-09-16', '2026-09-22', '2026-09-24', 'Delivered', 'Kolkata', 'Recipient unavailable on first attempt'),
  ('DLV-5007', 'ORD-1007', 'Delhivery', 'DL4402007', '2026-09-19', '2026-09-23', '2026-09-22', 'Delivered', 'Chandigarh', NULL),
  ('DLV-5008', 'ORD-1008', 'Ecom Express', 'EE9904008', '2026-09-21', '2026-09-25', '2026-09-25', 'Returned', 'Hyderabad Warehouse', 'Customer return - wrong size'),
  ('DLV-5009', 'ORD-1009', 'BlueDart', 'BD7781009', '2026-09-25', '2026-09-28', '2026-09-27', 'Delivered', 'Mumbai', NULL),
  ('DLV-5010', 'ORD-1010', 'Delhivery', 'DL4402010', '2026-09-28', '2026-10-02', '2026-10-02', 'Delivered', 'Pune', NULL),
  ('DLV-5011', 'ORD-1011', 'India Post', 'IP1106011', '2026-09-30', '2026-10-05', '2026-10-04', 'Delivered', 'Kochi', NULL),
  ('DLV-5012', 'ORD-1012', 'BlueDart', 'BD7781012', '2026-10-02', '2026-10-06', NULL, 'Delayed', 'Nagpur Hub', 'Courier hub backlog during festive season'),
  ('DLV-5013', 'ORD-1013', 'Delhivery', 'DL4402013', '2026-10-03', '2026-10-09', NULL, 'Out for Delivery', 'Lucknow', NULL),
  ('DLV-5014', 'ORD-1014', 'Ecom Express', 'EE9904014', '2026-10-04', '2026-10-10', NULL, 'In Transit', 'Bengaluru Hub', NULL),
  ('DLV-5015', 'ORD-1015', 'Delhivery', 'DL4402015', '2026-10-05', '2026-10-11', NULL, 'In Transit', 'Delhi Hub', NULL),
  ('DLV-5016', 'ORD-1016', 'BlueDart', 'BD7781016', NULL, '2026-10-12', NULL, 'Pending Dispatch', 'Seller Warehouse', NULL),
  ('DLV-5017', 'ORD-1017', 'Delhivery', 'DL4402017', NULL, '2026-10-13', NULL, 'Pending Dispatch', 'Seller Warehouse', NULL),
  ('DLV-5018', 'ORD-1018', 'Ecom Express', 'EE9904018', NULL, '2026-10-13', NULL, 'Pending Dispatch', 'Seller Warehouse', NULL),
  ('DLV-5019', 'ORD-1019', 'BlueDart', 'BD7781019', NULL, '2026-10-14', NULL, 'Pending Dispatch', 'Seller Warehouse', NULL);

-- Lock tables from the public API (n8n will connect directly, not via the API)
ALTER TABLE customers  ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders     ENABLE ROW LEVEL SECURITY;
ALTER TABLE deliveries ENABLE ROW LEVEL SECURITY;

-- Checkpoint: expect 12 | 20 | 19 | 169222.00
SELECT
  (SELECT COUNT(*) FROM customers)  AS customers,
  (SELECT COUNT(*) FROM orders)     AS orders,
  (SELECT COUNT(*) FROM deliveries) AS deliveries,
  (SELECT SUM(amount_inr) FROM orders
     WHERE order_status NOT IN ('Cancelled','Returned')) AS net_revenue_inr;
