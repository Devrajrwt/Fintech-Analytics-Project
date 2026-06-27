-- 09_Business_Questions.sql

/*
====================================================
Project: Fintech Analytics
File: 09_Business_Questions.sql

Objective:
Answer real-world business questions
using SQL analysis.

Author: Devraj Singh
====================================================
*/

-- Which customer segment generates the highest revenue?
-- Retail contributes 54.46% of total revenue.
SELECT
	c.customer_segment,
    SUM(ft.amount) AS revenue,
    ROUND(SUM(ft.amount) * 100.0 / SUM(SUM(ft.amount)) OVER(),2) AS contribution_percent
FROM customers c
JOIN finance_transactions ft
ON c.customer_id = ft.customer_id
GROUP BY c.customer_segment
ORDER BY revenue DESC;

-- Which states contribute the most revenue?
-- Maharashtra is the largest revenue contributor.
SELECT
	c.state,
	ROUND(SUM(ft.amount),2) AS revenue
FROM customers c
INNER JOIN finance_transactions ft
	ON c.customer_id = ft.customer_id
GROUP BY c.state
ORDER BY revenue DESC
LIMIT 10;

-- Who are the Top 10 customers by revenue?
SELECT
	c.customer_id,
	c.customer_name,
	ROUND(SUM(ft.amount),2) AS revenue
FROM customers c
INNER JOIN finance_transactions ft
	ON c.customer_id = ft.customer_id
GROUP BY
	c.customer_id,
	c.customer_name
ORDER BY revenue DESC
LIMIT 10;

-- Which transaction type generates the highest revenue?
-- Loan EMI and Transfer transactions drive most revenue.
SELECT
	transaction_type,
	ROUND(SUM(amount),2) AS revenue
FROM finance_transactions
GROUP BY transaction_type
ORDER BY revenue DESC;

-- Which channel generates the highest revenue?
-- "UPI"	66012714.14
SELECT
	channel,
	ROUND(SUM(amount),2) AS revenue
FROM finance_transactions
GROUP BY channel
ORDER BY revenue DESC;

-- Which occupations generate the highest revenue?
-- "Freelancer"	80669237.67
SELECT
	c.occupation,
	ROUND(SUM(ft.amount),2) AS revenue
FROM customers c
INNER JOIN finance_transactions ft
	ON c.customer_id = ft.customer_id
GROUP BY c.occupation
ORDER BY revenue DESC;

-- Which customer segment has the highest fraud rate?
-- Corporate and Premium customers have the highest fraud rate.
SELECT
	c.customer_segment,
	COUNT(*) AS total_transactions,
	SUM(CASE WHEN ft.is_fraud='Yes' THEN 1 ELSE 0 END) AS fraud_transactions,
	ROUND(SUM(CASE WHEN ft.is_fraud='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS fraud_rate
FROM customers c
JOIN finance_transactions ft
ON c.customer_id = ft.customer_id
GROUP BY c.customer_segment
ORDER BY fraud_rate DESC;

-- Which states have the highest fraud activity?
-- "Maharashtra"	90
SELECT
	c.state,
	COUNT(*) AS fraud_transactions
FROM customers c
JOIN finance_transactions ft
ON c.customer_id = ft.customer_id
WHERE ft.is_fraud='Yes'
GROUP BY c.state
ORDER BY fraud_transactions DESC
LIMIT 10;

-- Which channels are most vulnerable to fraud?
-- ATM and POS channels show the highest fraud activity.
SELECT
	channel,
	COUNT(*) AS fraud_transactions
FROM finance_transactions
WHERE is_fraud='Yes'
GROUP BY channel
ORDER BY fraud_transactions DESC;

-- Are high-risk transactions associated with fraud?
-- Fraud transactions average risk score 82.94 vs 35.49 for non-fraud.
SELECT
	is_fraud,
	ROUND(AVG(risk_score),2) AS avg_risk_score
FROM finance_transactions
GROUP BY is_fraud;

-- What percentage of revenue comes from each segment?
SELECT
	c.customer_segment,
	ROUND(SUM(ft.amount),2) AS revenue,
	ROUND(SUM(ft.amount)*100.0 / SUM(SUM(ft.amount)) OVER(),2) AS revenue_percentage
FROM customers c
JOIN finance_transactions ft
ON c.customer_id = ft.customer_id
GROUP BY c.customer_segment
ORDER BY revenue DESC;

-- Which month generated the highest revenue?
-- July 2025 generated the highest monthly revenue.
SELECT
	DATE_TRUNC('month', transaction_date) AS month,
	ROUND(SUM(amount),2) AS revenue
FROM finance_transactions
GROUP BY month
ORDER BY revenue DESC
LIMIT 10;

-- What is the average transaction value by segment?
SELECT
	c.customer_segment,
	ROUND(AVG(ft.amount),2) AS avg_transaction_value
FROM customers c
JOIN finance_transactions ft
ON c.customer_id = ft.customer_id
GROUP BY c.customer_segment
ORDER BY avg_transaction_value DESC;

-- Which channel has the highest average transaction value?
-- "Mobile App"	9171.75
SELECT
	channel,
	ROUND(AVG(amount),2) AS avg_transaction_value
FROM finance_transactions
GROUP BY channel
ORDER BY avg_transaction_value DESC;

-- Which customers should be targeted for VIP retention?
-- Top 20 revenue-generating customers should be prioritized for loyalty programs, premium services, and retention campaigns.
SELECT
	c.customer_id,
	c.customer_name,
	c.customer_segment,
	ROUND(SUM(ft.amount),2) AS revenue
FROM customers c
JOIN finance_transactions ft
ON c.customer_id = ft.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_segment
ORDER BY revenue DESC
LIMIT 20;

================================================================================================================================

