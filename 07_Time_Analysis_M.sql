-- 07_Time_Analysis.sql

/*
====================================================
Project: Fintech Analytics
File: 07_Time_Analysis.sql

Objective:
Analyze revenue trends over time,
monthly performance,
growth rates,
running totals,
and ranking analysis.

Author: Devraj Singh
====================================================
*/

SQL
/*
========================================================================================
Project   : Fintech Analytics
File      : 07_Time_Analysis_M.sql
Objective : Time-Series Metrics: Trends, Running Totals, Window Rankings & YoY Growth
Author    : Devraj Singh
Database  : PostgreSQL
Footprint : 50,000 Transaction Records | Evaluation Window: 2023 - 2025
========================================================================================
*/

-- QUESTION 1: What is the monthly gross revenue trajectory handled across the business cycle?
-- INSIGHT: Establishes the core chronological time-series timeline, tracking monthly financial volume velocity.
SELECT
    DATE_TRUNC('month', transaction_date) AS months,
    ROUND(SUM(amount), 2) AS revenue
FROM finance_transactions
GROUP BY months
ORDER BY months;


-- QUESTION 2: What is the transaction frequency trend on a month-over-month baseline?
-- INSIGHT: Monitors transaction count volume over time to ensure active platform utilization scales alongside processed values.
SELECT
    DATE_TRUNC('month', transaction_date) AS months,
    COUNT(*) AS transactions
FROM finance_transactions
GROUP BY months
ORDER BY months;


-- QUESTION 3: How do the chronological months rank against each other when evaluating total net revenue?
-- INSIGHT: Leverages the analytical window function `RANK()` to dynamically list the highest performing financial billing cycles across history.
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS months,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY months
)
SELECT
    months,
    ROUND(revenue, 2) AS revenue,
    RANK() OVER(ORDER BY revenue DESC) AS revenue_rank
FROM monthly_revenue;


-- QUESTION 4: Which specific 10 billing months generated the absolute highest gross revenue yields in platform history?
-- INSIGHT: Isolates elite performance peaks; data confirms July 2025 (₹12.51M) and May 2023 (₹12.35M) hold top portfolio slots.
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS months,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY months
)
SELECT 
    months,
    ROUND(revenue, 2) AS revenue
FROM monthly_revenue
ORDER BY revenue DESC
LIMIT 10;


-- QUESTION 5: What is the cumulative running total of processed revenue generated month-over-month throughout the platform lifecycle?
-- INSIGHT: Computes inline running totals using `SUM() OVER()`, tracking continuous financial growth and aggregate value velocity over the years.
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS months,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY months
)
SELECT
    months,
    ROUND(revenue, 2) AS revenue,
    ROUND(SUM(revenue) OVER(ORDER BY months), 2) AS running_revenue
FROM monthly_revenue
ORDER BY months;


-- QUESTION 6: What is the rolling cumulative revenue summary for the latest 10 billing cycles in reverse chronological order?
-- INSIGHT: Couples nested Common Table Expressions (CTEs) with analytical partitioning to provide immediate visibility into recent growth totals.
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS months,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY months
),
running_total AS (
    SELECT
        months,
        revenue,
        SUM(revenue) OVER(ORDER BY months) AS running_revenue
    FROM monthly_revenue
)
SELECT 
    months,
    ROUND(revenue, 2) AS revenue,
    ROUND(running_revenue, 2) AS running_revenue
FROM running_total
ORDER BY months DESC
LIMIT 10;


-- QUESTION 7: What is the cumulative running total of all processed transaction entries logged month-over-month?
-- INSIGHT: Tracks user engagement velocity across time, confirming the structural scalability of the clearing ledger.
WITH monthly_transactions AS (
     SELECT
        DATE_TRUNC('month', transaction_date) AS months,
        COUNT(*) AS transactions
     FROM finance_transactions
     GROUP BY months
)
SELECT
    months,
    transactions,
    SUM(transactions) OVER(ORDER BY months) AS running_transactions
FROM monthly_transactions
ORDER BY months;


-- QUESTION 8: What was the absolute revenue volume pulled in during the immediate previous month relative to the current cycle?
-- INSIGHT: Employs the `LAG()` analytical window function to dynamically reference the prior month's transaction amount without self-joins.
WITH monthly_revenue AS (
     SELECT
        DATE_TRUNC('month', transaction_date) AS months,
        SUM(amount) AS revenue
     FROM finance_transactions
     GROUP BY months
)
SELECT
    months,
    ROUND(revenue, 2) AS revenue,
    ROUND(LAG(revenue) OVER(ORDER BY months), 2) AS previous_month_revenue
FROM monthly_revenue
ORDER BY months;


-- QUESTION 9: What is the absolute numerical change in dollar growth volume recorded month-over-month?
-- INSIGHT: Directly subtracts the lagged monthly volume from the current cycle, providing risk and finance groups a clear metric for short-term revenue change.
WITH monthly_revenue AS (
     SELECT
        DATE_TRUNC('month', transaction_date) AS months,
        SUM(amount) AS revenue
     FROM finance_transactions
     GROUP BY months
)
SELECT
    months,
    ROUND(revenue, 2) AS revenue,
    ROUND(LAG(revenue) OVER(ORDER BY months), 2) AS previous_month_revenue,
    ROUND(revenue - LAG(revenue) OVER(ORDER BY months), 2) AS revenue_change
FROM monthly_revenue
ORDER BY months;


-- QUESTION 10: What is the exact percentage Month-over-Month (MoM) revenue growth velocity across billing cycles?
-- INSIGHT: Delivers core short-term business performance tracking, allowing executive teams to monitor immediate volatility shifts and seasonal trends.
WITH monthly_revenue AS (
     SELECT
        DATE_TRUNC('month', transaction_date) AS months,
        SUM(amount) AS revenue
     FROM finance_transactions
     GROUP BY months
)
SELECT
    months,
    ROUND(revenue, 2) AS revenue,
    ROUND((revenue - LAG(revenue) OVER(ORDER BY months)) * 100.0 / LAG(revenue) OVER(ORDER BY months), 2) AS growth_percent
FROM monthly_revenue
ORDER BY months;


-- QUESTION 11: Which specific day of the week generates the highest volume of platform transactional revenue?
-- INSIGHT: Slices volume by weekday; results show Sunday leads platform clearings at ₹66.56M, followed closely by Wednesday at ₹66.11M.
SELECT
    TO_CHAR(transaction_date, 'Day') AS day_name,
    ROUND(SUM(amount), 2) AS revenue
FROM finance_transactions
GROUP BY day_name
ORDER BY revenue DESC;


-- QUESTION 12: How does gross transaction revenue accumulate when aggregated by calendar month name across all years?
-- INSIGHT: Uncovers high-level seasonal peaks independent of the year; January leads at ₹47.26M, with March following closely at ₹46.19M.
SELECT
    TO_CHAR(transaction_date, 'Mon') AS month_name,
    ROUND(SUM(amount), 2) AS revenue
FROM finance_transactions
GROUP BY month_name
ORDER BY revenue DESC;


-- QUESTION 13: What is the sequential chronological row numbering index across all tracked operational billing months?
-- INSIGHT: Implements `ROW_NUMBER()` to enforce a unique, sequential transaction index across all available time-series points.
WITH monthly_revenue AS (
     SELECT
        DATE_TRUNC('month', transaction_date) AS months,
        SUM(amount) AS revenue
     FROM finance_transactions
     GROUP BY months
)
SELECT
    months,
    ROUND(revenue, 2) AS revenue,
    ROW_NUMBER() OVER(ORDER BY months) AS row_num
FROM monthly_revenue
ORDER BY months;


-- QUESTION 14: How do the available historical billing cycles group and rank when utilizing non-skipping dense rankings?
-- INSIGHT: Implements advanced `DENSE_RANK()` window partitioning to order monthly performance volumes without gaps, providing a clean comparison of revenue heights.
WITH monthly_revenue AS (
     SELECT
        DATE_TRUNC('month', transaction_date) AS months,
        SUM(amount) AS revenue
     FROM finance_transactions
     GROUP BY months
)
SELECT
    months,
    ROUND(revenue, 2) AS revenue,
    DENSE_RANK() OVER(ORDER BY revenue DESC) AS revenue_rank
FROM monthly_revenue;

================================================================================================================================

