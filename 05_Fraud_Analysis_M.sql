-- 05_Fraud_Analysis.sql

/*
====================================================
Project: Fintech Analytics
File: 05_Fraud_Analysis.sql

Objective:
Investigate fraud patterns,
fraud distribution, fraud amount,
fraud rates, and fraud drivers
across channels, segments, and states.

Author: Devraj Singh
====================================================
*/

-- QUESTION 1: What is the absolute volume of verified fraudulent transactions across the platform?
-- INSIGHT: Relational audit isolates exactly 630 explicitly fraudulent actions within the global ledger.
SELECT
    COUNT(*) AS fraud_transactions
FROM finance_transactions
WHERE is_fraud = 'Yes';


-- QUESTION 2: What is the precise percentage rate of fraud penetration across all portfolio logs?
-- INSIGHT: The overall portfolio fraud level is tightly controlled, tracking at exactly 1.26%.
-- TECHNICAL NOTE: Implements a optimized single-scan conditional aggregation filter, bypassing expensive table subqueries.
SELECT 
    ROUND(SUM(CASE WHEN is_fraud = 'Yes' THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*), 2) AS fraud_percentage
FROM finance_transactions;


-- QUESTION 3: What is the gross monetary value of capital leaking through fraud events?
-- INSIGHT: Cumulative capital exposure from fraud reaches ₹5,969,443.52, setting the baseline for provisioning funds.
SELECT
    SUM(amount) AS fraud_amount
FROM finance_transactions
WHERE is_fraud = 'Yes';


-- QUESTION 4: What is the average financial value processed per individual fraudulent transaction?
-- INSIGHT: Normalized fraudulent ticket sizes average ₹9,475.31, proving bad actors aggressively target mid-to-high value clearings.
SELECT
    ROUND(AVG(amount),2) AS avg_fraud_amount
FROM finance_transactions
WHERE is_fraud = 'Yes';


-- QUESTION 5: What is the breakdown of transaction types ranked by their structural fraud incidence rate?
-- INSIGHT: 'Card Payment' (1.47%), 'Transfer' (1.33%), and 'Deposit' (1.29%) exhibit the highest structural vulnerability, 
-- indicating clear target sectors where secondary multi-factor verification rules must be deployed.
SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN is_fraud = 'Yes' THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(SUM(CASE WHEN is_fraud = 'Yes' THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM finance_transactions
GROUP BY transaction_type
ORDER BY fraud_rate DESC;


-- QUESTION 6: Which explicit transaction types generate the largest net monetary fraud losses?
-- INSIGHT: 'Loan EMIs' (₹1,569,634.39) and 'Transfers' (₹1,547,159.08) represent the highest cumulative leakages, 
-- marking them as the primary products requiring enhanced anti-fraud rule models.
SELECT
    transaction_type,
    ROUND(SUM(amount),2) AS fraud_amount
FROM finance_transactions
WHERE is_fraud = 'Yes'
GROUP BY transaction_type
ORDER BY fraud_amount DESC;


-- QUESTION 7: Which geographic states experience the highest frequency of successful fraud incidents?
-- INSIGHT: Regional volume distribution places Maharashtra (102 incidents) and Karnataka (76 incidents) as the 
-- highest fraud volume areas, tracking closely with their positions as the highest-density overall market regions.
SELECT
    c.state,
    COUNT(*) AS fraud_transactions
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
WHERE ft.is_fraud = 'Yes'
GROUP BY c.state
ORDER BY fraud_transactions DESC;


-- QUESTION 8: Which geographic states bear the heaviest total monetary losses due to fraud?
-- INSIGHT: Maharashtra leads absolute loss impact at ₹987,143.91, followed closely by Karnataka at ₹874,213.25, 
-- indicating that high-volume regional markets incur deeper financial losses.
SELECT
    c.state,
    ROUND(SUM(ft.amount),2) AS fraud_amount
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
WHERE ft.is_fraud = 'Yes'
GROUP BY c.state
ORDER BY fraud_amount DESC;


-- QUESTION 9: How does fraud frequency split when analyzed across various CRM customer segment tiers?
-- INSIGHT: Core 'Retail' accounts experience the highest absolute volume of fraud with 332 incidents, moving ahead 
-- of other cohorts due to the massive sheer scale of standard retail account signups.
SELECT
    c.customer_segment,
    COUNT(*) AS fraud_transactions
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
WHERE ft.is_fraud = 'Yes'
GROUP BY c.customer_segment
ORDER BY fraud_transactions DESC;


-- QUESTION 10: What is the true fraud risk percentage rate when normalized against each customer segment's overall volume?
-- INSIGHT: When calculated as a rate, the corporate tier (SME at 1.41%, Corporate at 1.40%) actually holds a higher risk profile 
-- than retail users (1.23%). This calls for tighter real-time monitoring on corporate business profiles.
SELECT
    c.customer_segment,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN ft.is_fraud = 'Yes' THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(SUM(CASE WHEN ft.is_fraud = 'Yes' THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
GROUP BY c.customer_segment
ORDER BY fraud_rate DESC;


-- QUESTION 11: Which transactional access channels encounter the highest frequency of fraud incidents?
-- INSIGHT: Physical interfaces—specifically ATMs (101) and POS terminals (97)—lead the transaction counter for fraud occurrences.
SELECT
    channel,
    COUNT(*) AS fraud_transactions
FROM finance_transactions
WHERE is_fraud = 'Yes'
GROUP BY channel
ORDER BY fraud_transactions DESC;


-- QUESTION 12: What is the explicit fraud percentage rate when evaluated against individual channel usage totals?
-- INSIGHT: ATMs exhibit the highest relative breach vulnerability rate at 1.41%, with POS clearings following closely behind 
-- at 1.36%, highlighting the physical card-present layer as a primary risk area.
SELECT
    channel,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN ft.is_fraud = 'Yes' THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(SUM(CASE WHEN ft.is_fraud = 'Yes' THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM customers c
JOIN finance_transactions ft
    ON c.customer_id = ft.customer_id
GROUP BY channel
ORDER BY fraud_rate DESC;


-- QUESTION 13: Which specific technical channels sustain the highest gross monetary losses from fraud?
-- INSIGHT: ATMs lead total channel financial leakage at ₹1,168,054.24, making the automated cash withdrawal network 
-- the most costly infrastructure layer for fraud losses.
SELECT
    channel,
    ROUND(SUM(amount),2) AS fraud_amount
FROM finance_transactions
WHERE is_fraud = 'Yes'
GROUP BY channel
ORDER BY fraud_amount DESC;


-- QUESTION 14: What is the monthly volume velocity trend of fraud occurrences across the billing lifecycle?
-- INSIGHT: Isolates month-over-month chronological trajectory patterns, allowing risk managers to map out 
-- specific fraud trends alongside peak promotional calendars or security rollouts.
SELECT
    DATE_TRUNC('month', transaction_date) AS months,
    COUNT(*) AS fraud_transactions
FROM finance_transactions
WHERE is_fraud = 'Yes'
GROUP BY months
ORDER BY months;


-- QUESTION 15: How does overall transaction value compare between fraud and non-fraud lines using simultaneous aggregation?
-- INSIGHT: Simultaneously analyzes ledger splits to reveal that out of all processed volume, safe transactions capture 
-- ₹449,564,806.10, while fraudulent leaks account for ₹5,969,443.52.
SELECT 
    ROUND(SUM(CASE WHEN is_fraud = 'Yes' THEN amount ELSE 0 END), 2) AS fraud_amount,
    ROUND(SUM(CASE WHEN is_fraud = 'No'  THEN amount ELSE 0 END), 2) AS non_fraud_amount
FROM finance_transactions;


-- QUESTION 16: Which top 20 high-value, high-risk transactions represent critical risk vulnerabilities?
-- INSIGHT: Targets individual critical exposures (where risk_score > 70) for fraud analysts to examine, 
-- streamlining the process for rapid chargeback recovery or manual security holds.
SELECT
    transaction_id,
    customer_id,
    transaction_date,
    amount,
    risk_score,
    transaction_type
FROM finance_transactions
WHERE is_fraud = 'Yes' AND risk_score > 70
ORDER BY amount DESC
LIMIT 20;


-- QUESTION 17: Which top 10 individual customer accounts contain the highest concentration of fraud value?
-- INSIGHT: Uses a clean Common Table Expression (CTE) to pinpoint the top victimized or compromised accounts, 
-- allowing the system to flag these specific user profiles for automated risk-remediation steps.
WITH fraud_summary AS (
    SELECT
        customer_id,
        ROUND(SUM(amount), 2) AS fraud_amount
    FROM finance_transactions
    WHERE is_fraud = 'Yes'
    GROUP BY customer_id
)
SELECT 
    customer_id,
    fraud_amount
FROM fraud_summary
ORDER BY fraud_amount DESC
LIMIT 10;

================================================================================================================================

