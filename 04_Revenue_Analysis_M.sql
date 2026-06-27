-- 04_Revenue_Analysis.sql

/*
====================================================
Project: Fintech Analytics
File: 04_Revenue_Analysis.sql

Objective:
Analyze revenue performance across
years, quarters, transaction types,
channels, customer segments, and states.

Author: Devraj Singh
====================================================
*/

-- QUESTION 1: What is the total gross volume of capital processed by the enterprise platform?
-- INSIGHT: Reconciled global gross transaction volume across all processing historical lines totals ₹455,534,249.62.
SELECT
    SUM(amount) AS total_revenue
FROM finance_transactions;


-- QUESTION 2: What is the annual financial transaction velocity across each separate processing year?
-- INSIGHT: Volume holds incredibly stable year-over-year, tracking at roughly ₹135M to ₹137M annually 
-- from 2023 through 2025, demonstrating predictable and consistent platform liquidity.
SELECT
    EXTRACT(YEAR FROM transaction_date) AS years,
    SUM(amount) AS revenue
FROM finance_transactions
GROUP BY years
ORDER BY years;


-- QUESTION 3: What are the historical seasonal spending peaks when grouping values by calendar month?
-- INSIGHT: Stripping the year away via macro month extraction allows financial risk and planning teams 
-- to analyze overall consumer purchase seasonality trends independent of chronological growth.
SELECT
    TO_CHAR(transaction_date,'Mon') AS month_name,
    EXTRACT(MONTH FROM transaction_date) AS month_number,
    SUM(amount) AS revenue
FROM finance_transactions
GROUP BY month_name, month_number
ORDER BY month_number;


-- QUESTION 4: What is the true chronological month-over-month revenue growth timeline across all billing cycles?
-- INSIGHT: Utilizing DATE_TRUNC ensures separate historical months (e.g., January 2024 vs January 2025) 
-- remain isolated, providing a precise timeline to map long-term chronological trajectory.
SELECT
    TO_CHAR(transaction_date,'Month') AS month_name,
    DATE_TRUNC('month', transaction_date) AS month_number,
    SUM(amount) AS revenue
FROM finance_transactions
GROUP BY month_name, month_number
ORDER BY month_number;


-- QUESTION 5: Which specific fiscal quarter profiles yield the highest absolute transaction volume?
-- INSIGHT: Slices platform performance into standard 3-month corporate cycles, immediately highlighting 
-- seasonal financial quarters that benefit from peak commercial demand.
SELECT
    EXTRACT(YEAR FROM transaction_date) AS years,
    EXTRACT(QUARTER FROM transaction_date) AS quarter,
    SUM(amount) AS revenue
FROM finance_transactions
GROUP BY years, quarter
ORDER BY years, quarter;


-- QUESTION 6: Which top 10 geographic state environments generate the greatest volume of gross revenue?
-- INSIGHT: Highlights primary regional economic hubs, providing valuable location data to align marketing 
-- budgets and core cash management servers.
SELECT
    c.state,
    SUM(ft.amount) AS revenue
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
GROUP BY c.state
ORDER BY revenue DESC
LIMIT 10;


-- QUESTION 7: What is the gross transaction volume generated across individual customer segment tiers?
-- INSIGHT: Connects user status levels with absolute spend volumes to see which profiles are driving value.
SELECT
    c.customer_segment,
    SUM(ft.amount) AS revenue
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
GROUP BY c.customer_segment
ORDER BY revenue DESC;


-- QUESTION 8: What is the exact percentage contribution share of each customer segment relative to total revenue?
-- INSIGHT: The 'Retail' user base acts as the core revenue anchor, contributing a dominant 54.46% of total volume, 
-- followed by Premium at 18.51% and SME at 15.77%.
-- TECHNICAL NOTE: Employs inline window aggregation (`SUM(SUM(...)) OVER()`) to eliminate the need for nested subqueries.
SELECT
    c.customer_segment,
    SUM(ft.amount) AS revenue,
    ROUND(SUM(ft.amount) * 100.0 / (SUM(SUM(ft.amount)) OVER()),2) AS contribution_percent
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
GROUP BY c.customer_segment
ORDER BY revenue DESC;


-- QUESTION 9: How does corporate transaction revenue volume split when analyzed by customer gender?
-- INSIGHT: Demonstrates balanced transaction distribution, indicating that user acquisition and engagement 
-- strategies are succeeding across both demographic groups.
SELECT
    c.gender,
    SUM(ft.amount) AS revenue
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
GROUP BY c.gender;


-- QUESTION 10: Which specific customer occupation classifications drive the highest revenue velocity?
-- INSIGHT: Freelancers (₹80.66M) and Retired users (₹78.53M) generate the highest processing volume, 
-- marking them as prime targets for high-yield savings or premium portfolio offerings.
SELECT
    c.occupation,
    SUM(ft.amount) AS revenue
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
GROUP BY c.occupation
ORDER BY revenue DESC;


-- QUESTION 11: Which transaction product types process the highest total value across the financial platform?
-- INSIGHT: 'Loan EMI' and 'Transfer' serve as the platform's heavy lifters, driving ₹130.93M and ₹120.63M 
-- respectively, and proving that debt servicing and liquidity movement are the primary user activities.
SELECT
    transaction_type,
    SUM(amount) AS revenue
FROM finance_transactions
GROUP BY transaction_type
ORDER BY revenue DESC;


-- QUESTION 12: Which individual digital or physical payment routing channel captures the largest revenue volume?
-- INSIGHT: Core processing channels remain remarkably balanced; UPI leads marginally at ₹66.01M, 
-- with physical Branch clearings close behind at ₹65.62M and ATMs following at ₹65.19M.
SELECT
    channel,
    SUM(amount) AS revenue
FROM finance_transactions
GROUP BY channel
ORDER BY revenue DESC;


-- QUESTION 13: What are the primary merchant categories driving transaction volume across the ecosystem?
-- INSIGHT: Ranks user capital placement across external business sectors, highlighting dominant merchant categories 
-- to support strategic corporate loyalty partnerships.
SELECT
    merchant_category,
    SUM(amount) AS revenue
FROM finance_transactions
GROUP BY merchant_category
ORDER BY revenue DESC;


-- QUESTION 14: What is the normalized average daily revenue run-rate managed by the clearing infrastructure?
-- INSIGHT: Establishes a solid baseline daily platform revenue average, giving risk teams a clear benchmark 
-- to detect unusual transaction spikes or clearing network drops.
SELECT
    ROUND(SUM(amount) / COUNT(DISTINCT transaction_date),2) AS avg_daily_revenue
FROM finance_transactions;


-- QUESTION 15: What were the top 10 highest earning business days recorded in the corporate history?
-- INSIGHT: Pinpoints precise days of maximum financial throughput, enabling system administrators to trace 
-- high-volume events back to specific promotional campaigns or peak market cycles.
SELECT
    transaction_date,
    SUM(amount) AS revenue
FROM finance_transactions
GROUP BY transaction_date
ORDER BY revenue DESC
LIMIT 10;


-- QUESTION 16: Who are the top 10 highest grossing client accounts by cumulative transaction value?
-- INSIGHT: Isolates high-value individual consumer accounts, providing clear candidates for exclusive, 
-- automated premium membership tiers or targeted retention efforts.
SELECT
    c.customer_id,
    c.customer_name,
    SUM(ft.amount) AS revenue
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY revenue DESC
LIMIT 10;


-- QUESTION 17: Which top 5 customer accounts hold the absolute highest concentration of processing volume?
-- INSIGHT: Leverages a clean Common Table Expression (CTE) structure to dynamically isolate elite customer groups 
-- without risking row duplication.
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY customer_id
)
SELECT
    customer_id,
    ROUND(revenue, 2) AS revenue
FROM customer_revenue
ORDER BY revenue DESC
LIMIT 5;


-- QUESTION 18: What is the absolute dollar change in gross revenue generated year-over-year?
-- INSIGHT: Uses the advanced window function `LAG()` to calculate annual revenue shifts, showing a slight drop 
-- in 2024 followed by a strong recovery in 2025.
WITH yearly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM transaction_date) AS years,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY years
)
SELECT
    years,
    ROUND(revenue, 2) AS current_year_revenue,
    ROUND(LAG(revenue) OVER(ORDER BY years), 2) AS previous_year_revenue,
    ROUND(revenue - LAG(revenue) OVER(ORDER BY years), 2) AS revenue_variance
FROM yearly_revenue
ORDER BY years;


-- QUESTION 19: What is the exact percentage Year-over-Year (YoY) revenue growth rate across the business lifecycle?
-- INSIGHT: Quantifies precise corporate performance velocity, showing a minor dip of -1.06% in 2024, which was 
-- quickly turned around by a positive YoY growth rate of +1.41% in 2025.
WITH yearly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM transaction_date) AS years,
        SUM(amount) AS revenue
    FROM finance_transactions
    GROUP BY years
)
SELECT
    years,
    ROUND(revenue, 2) AS revenue,
    ROUND((revenue - LAG(revenue) OVER(ORDER BY years)) * 100.0 / LAG(revenue) OVER(ORDER BY years), 2) AS yoy_growth_percent
FROM yearly_revenue
ORDER BY years;

================================================================================================================================

