


--- cumulative customer growth overtime
--- count new customer per moth by their first order



SELECT 
    cohort_month,
    COUNT(DISTINCT customer_id) AS new_customers,



    SUM(COUNT(DISTINCT customer_id))      --- running total customer by cohort month
        OVER (ORDER BY cohort_month) AS running_total_customers
FROM (

    SELECT       --- speecify eacch customer first purchase
        customer_id
        DATE_TRUNC('month', MIN(order_date)) AS cohort_month
    FROM orders 
    WHERE status = 'completed'
      AND order_date >= DATE '2024-01-01' -- Date range is index-friendly
      AND order_date <  DATE '2025-01-01'
    GROUP BY customer_id


) first_orders
GROUP BY cohort_month
ORDER BY cohort_month;