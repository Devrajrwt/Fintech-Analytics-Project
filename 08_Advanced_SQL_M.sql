-- 08_Advanced_SQL.sql

/*
====================================================
Project: Fintech Analytics
File: 08_Advanced_SQL.sql

Objective:
Advanced SQL Analysis using:
NTILE
Percent Contribution
Pareto Analysis
Customer Segmentation
Revenue Concentration
Advanced Window Functions

Author: Devraj Singh
====================================================
*/

-- QUESTION 1: How do all individual customer accounts rank across the portfolio based on aggregate top-line revenue?
-- INSIGHT: Uses the `RANK()` window function to sort the entire customer base sequentially. This avoids duplicate rankings on equal totals, providing a clear map of user value tiers.
SELECT
    c.customer_id,
    c.customer_name,
    SUM(ft.amount) AS total_revenue,
    RANK() OVER(ORDER BY SUM(ft.amount) DESC) AS revenue_rank
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
GROUP BY c.customer_id, c.customer_name;


-- QUESTION 2: Who are the top 20 highest-value customer profiles based on total transaction volume?
-- INSIGHT: The platform's top customer generated ₹601,098.49 in transaction value. The top three accounts each contributed nearly ₹587K+, showing a healthy, balanced customer distribution rather than an over-dependence on a single client account[cite: 13].
SELECT
    c.customer_id,
    c.customer_name,
    SUM(ft.amount) AS total_revenue
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC
LIMIT 20;


-- QUESTION 3: How does our transacting customer base split into 4 equal segments based on spending power?
-- INSIGHT: Implements `NTILE(4)` to divide customer accounts into four equal quartiles. This helps product teams easily identify premium versus low-tier spenders[cite: 13].
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(ft.amount) AS revenue
    FROM customers c
    JOIN finance_transactions ft
        ON c.customer_id = ft.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    revenue,
    NTILE(4) OVER(ORDER BY revenue DESC) AS revenue_quartile
FROM customer_revenue;


-- QUESTION 4: What is the exact individual percentage contribution of each customer account relative to the platform's total processed volume?
-- INSIGHT: Measures concentration by dividing individual values by the global running total (`SUM(revenue) OVER()`)[cite: 13]. This helps identify accounts with significant system impact.
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY customer_id
)
SELECT
    customer_id,
    revenue,
    ROUND(revenue * 100.0 / SUM(revenue) OVER(), 4) AS revenue_percent
FROM customer_revenue
ORDER BY revenue DESC;


-- QUESTION 5: How do customer accounts group into financial spending tiers when sorted from lowest to highest spend?
-- INSIGHT: Assigns spending tiers from 1 (lowest spenders) to 4 (highest spenders) via ascending `NTILE(4)` sorting[cite: 13]. This allows marketing teams to isolate and nurture low-activity users.
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY customer_id
)
SELECT
    customer_id,
    revenue,
    ROUND(revenue * 100.0 / SUM(revenue) OVER(), 4) AS revenue_percent,
    NTILE(4) OVER (ORDER BY revenue ASC) AS spending_tier
FROM customer_revenue
ORDER BY revenue DESC;


-- QUESTION 6: What is the combined financial contribution percentage of our top 10 highest-spending customers?
-- INSIGHT: Isolates the top 10 core users to track premium user dependency and assess platform vulnerability to churn in high-value accounts[cite: 13].
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY customer_id
)
SELECT
    customer_id,
    revenue,
    ROUND(revenue * 100.0 / SUM(revenue) OVER(), 4) AS contribution_percent
FROM customer_revenue
ORDER BY revenue DESC
LIMIT 10;


-- QUESTION 7: What is the cumulative running total of revenue accumulated across customers, ordered from largest to smallest spend?
-- INSIGHT: Computes a rolling summation of individual customer revenues[cite: 13]. This highlights how quickly total volume builds up across your customer base.
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY customer_id
)
SELECT
    customer_id,
    revenue,
    SUM(revenue) OVER(ORDER BY revenue DESC) AS cumulative_revenue
FROM customer_revenue
ORDER BY revenue DESC;


-- QUESTION 8: What is the running cumulative percentage of revenue generated across the customer base?
-- INSIGHT: Serves as the base for Pareto Principle (80/20 rule) diagnostics[cite: 13], mapping out how much of the portfolio's wealth is driven by top-tier users.
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY customer_id
)
SELECT
    customer_id,
    revenue,
    ROUND(SUM(revenue) OVER(ORDER BY revenue DESC) * 100.0 / SUM(revenue) OVER(), 2) AS cumulative_percent
FROM customer_revenue
ORDER BY revenue DESC;


-- QUESTION 9: What is the revenue share percentage contribution across different corporate customer segments?
-- INSIGHT: Uses window analytics (`SUM(SUM(...)) OVER()`) to show that Retail users drive over half of all value, while Premium and SME tiers maintain strong secondary positions[cite: 13].
SELECT
    c.customer_segment,
    SUM(ft.amount) AS revenue,
    ROUND(SUM(ft.amount) * 100.0 / SUM(SUM(ft.amount)) OVER(), 2) AS contribution_percent
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
GROUP BY c.customer_segment
ORDER BY revenue DESC;


-- QUESTION 10: What is the geographic revenue contribution breakout for individual states?
-- INSIGHT: Out of 13 active states, Maharashtra leads value contribution at 14.99%, followed closely by Karnataka (11.60%) and Gujarat (10.99%)[cite: 13].
SELECT
    c.state,
    SUM(ft.amount) AS revenue,
    ROUND(SUM(ft.amount) * 100.0 / SUM(SUM(ft.amount)) OVER(), 2) AS contribution_percent
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
GROUP BY c.state
ORDER BY revenue DESC;


-- QUESTION 11: Who is the absolute highest grossing customer within each separate customer segment?
-- INSIGHT: Combines common table expressions with `ROW_NUMBER() PARTITION BY` to isolate top spenders in each tier[cite: 13]. This allows the business to deliver hyper-targeted rewards to high-value users.
WITH customer_revenue AS (
    SELECT
        c.customer_segment,
        c.customer_id,
        c.customer_name,
        SUM(ft.amount) AS revenue
    FROM customers c
    JOIN finance_transactions ft
        ON c.customer_id = ft.customer_id
    GROUP BY c.customer_segment, c.customer_id, c.customer_name
)
SELECT *
FROM (
     SELECT
        customer_segment, 
        customer_id,
        customer_name,
        revenue,
        ROW_NUMBER() OVER(PARTITION BY customer_segment ORDER BY revenue DESC) AS rn
     FROM customer_revenue
    ) x
WHERE rn = 1;


-- QUESTION 12: What is the true mathematical average transaction volume handled across each revenue quartile?
-- INSIGHT: Shows the deep gap in value across tiers[cite: 13]: Quartile 1 averages an impressive ₹229,039.56 per user, while Quartile 4 averages just ₹31,629.12. This underscores the importance of focusing retention efforts on top-tier users.
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY customer_id
),
quartiles AS (
    SELECT
        customer_id,
        revenue,
        NTILE(4) OVER(ORDER BY revenue DESC) AS quartile
    FROM customer_revenue
)
SELECT
    quartile,
    ROUND(AVG(revenue), 2) AS avg_revenue
FROM quartiles
GROUP BY quartile
ORDER BY quartile;

================================================================================================================================

