=== index recommendation based on the shown schemas ==


--- filter by most customer , customer and date ---
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);


---  product & order details for bbetter performance analysis    ---
CREATE INDEX idx_order_items_product_order ON order_items(product_id, order_id);


----  partial index for specific order (mostly completed)   ----

CREATE INDEX idx_orders_status_date ON orders(status, order_date) WHERE status = 'completed';

----   customer country analysis   -----

CREATE INDEX idx_customers_country ON customers(country);

----   category based reporting & analysis ----
CREATE INDEX idx_products_category ON products(category);





======= Schema improvement =========

--- consider partitioning orders by order_date for >10M ROWS

----  add ENUM for order status  CREATE TYPE order_status AS ENUM ('pending','completed','canceled')

