

---- analyze product sales over the last 90dys
--- classified stock condition


SELECT
    p.name,
    p.category,
    p.stock_quantity,
    COALESCE(SUM(oi.quantity), 0) AS units_sold_90d,     ---- unitt sold last 90d (0 if no sales)
    ROUND(COALESCE(SUM(oi.quantity), 0) / 90.0, 2) AS avg_daily_sales, ---- avg daily sales rate

    
    CASE
        WHEN COALESCE(SUM(oi.quantity), 0) = 0 AND p.stock_quantity > 0      --- stock status based on the slaes & remaining stock
            THEN 'Dead Stock'
        WHEN p.stock_quantity = 0
            THEN 'Out of Stock'
        WHEN p.stock_quantity / NULLIF(SUM(oi.quantity) / 90.0, 0) < 7
            THEN 'Critical'
        WHEN p.stock_quantity / NULLIF(SUM(oi.quantity) / 90.0, 0) < 30
            THEN 'Low'
        ELSE 'Adequate'
    END AS stock_status
FROM products p
LEFT JOIN order_items oi
       ON p.id = oi.product_id
LEFT JOIN orders o
       ON oi.order_id = o.id
      AND o.status = 'completed'    ---- filter join preserve & left join behavor
      AND o.order_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY
    p.name,
    p.category,
    p.stock_quantity
ORDER BY
    stock_status;
