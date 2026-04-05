USE customer_behavior;
SELECT COUNT(*) AS total_records FROM customer;

SELECT * FROM customer LIMIT 10;
#Business insight queries 
#1. Revenue By category
SELECT category,
       COUNT(*) AS total_orders,
       ROUND(SUM(purchase_amount_usd), 2) AS total_revenue
FROM customer
GROUP BY category
ORDER BY total_revenue DESC;

#2.Revenue by season 
SELECT season,
       COUNT(*) AS orders,
       ROUND(AVG(purchase_amount_usd), 2) AS avg_order
FROM customer
GROUP BY season
ORDER BY orders DESC;

#3. Subscribers vs non-subscribers
SELECT subscription_status,
       COUNT(*) AS customers,
       ROUND(AVG(purchase_amount_usd), 2) AS avg_purchase
FROM customer
GROUP BY subscription_status;

#1. Rank categories by revenue per season
SELECT season, category,
       ROUND(SUM(purchase_amount_usd), 2) AS revenue,
       RANK() OVER (PARTITION BY season ORDER BY SUM(purchase_amount_usd) DESC) AS rnk
FROM customer
GROUP BY season, category
ORDER BY season, rnk;

#2. High value customers (above average spend)
WITH avg_spend AS (
    SELECT ROUND(AVG(purchase_amount_usd), 2) AS avg_val
    FROM customer
)
SELECT customer_id, age, gender,
       ROUND(AVG(purchase_amount_usd), 2) AS avg_order,
       a.avg_val AS overall_avg
FROM customer, avg_spend a
GROUP BY customer_id, age, gender, a.avg_val
HAVING avg_order > a.avg_val
ORDER BY avg_order DESC
LIMIT 20;
