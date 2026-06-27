-- 06_Risk_Analysis.sql

/*
====================================================
Project: Fintech Analytics
File: 06_Risk_Analysis.sql

Objective:
Analyze transaction risk scores,
risk categories, fraud-risk relationships,
and high-risk transaction behavior.

Author: Devraj Singh
====================================================
*/

-- QUESTION 1: What are the minimum, maximum, and average risk score metrics across the entire portfolio?
-- INSIGHT: System parameters span a complete 1 to 100 spectrum, keeping a highly stable, 
-- moderate overall ledger average risk profile of 36.08.
SELECT
    MIN(risk_score) AS min_risk,
    MAX(risk_score) AS max_risk,
    ROUND(AVG(risk_score),2) AS avg_risk
FROM finance_transactions;


-- QUESTION 2: How are transaction volumes distributed across different classified risk buckets?
-- INSIGHT: 'High Risk' accounts for the largest share with 21,166 transactions, followed by 
-- Medium Risk (14,261) and Low Risk (14,056), highlighting a high-density cluster requiring steady rule updates.
SELECT
    CASE
        WHEN risk_score <= 20 THEN 'Low Risk'
        WHEN risk_score <= 40 THEN 'Medium Risk'
        WHEN risk_score <= 70 THEN 'High Risk'
        ELSE 'Very High Risk'
    END AS risk_bucket,
    COUNT(*) AS transactions
FROM finance_transactions
GROUP BY risk_bucket
ORDER BY transactions DESC;


-- QUESTION 3: What is the total gross dollar volume processed within each individual risk bucket?
-- INSIGHT: High Risk segments carry the highest absolute volume exposure at ₹194,793,584.24, 
-- proving that the majority of processed financial value is concentrated in higher-scrutiny profiles[cite: 11].
SELECT
    CASE
        WHEN risk_score <= 20 THEN 'Low Risk'
        WHEN risk_score <= 40 THEN 'Medium Risk'
        WHEN risk_score <= 70 THEN 'High Risk'
        ELSE 'Very High Risk'
    END AS risk_bucket,
    ROUND(SUM(amount),2) AS revenue
FROM finance_transactions
GROUP BY risk_bucket
ORDER BY revenue DESC;


-- QUESTION 4: How many total separate transaction instances breached the critical risk boundary (>70)?
-- INSIGHT: Exactly 517 transactions breached critical boundaries, giving risk analysts a highly refined list 
-- for real-time compliance holds or enhanced multi-factor checks[cite: 11].
SELECT
    COUNT(*) AS high_risk_transactions
FROM finance_transactions
WHERE risk_score > 70;


-- QUESTION 5: What is the gross monetary volume exposed within severe high-risk transaction thresholds (>70)?
-- INSIGHT: Extreme risk exposure balances to ₹4,915,406.47, establishing the key volume boundary 
-- to set up real-time clearing security blocks[cite: 11].
SELECT
    ROUND(SUM(amount),2) AS high_risk_revenue
FROM finance_transactions
WHERE risk_score > 70;


-- QUESTION 6: What is the average risk score index when evaluated across different transaction product types?
-- INSIGHT: 'Transfer' holds the highest average risk velocity at 36.58, with 'Loan EMI' (36.09) and 
-- 'Withdrawal' (36.09) close behind, marking liquidity movement as the most vulnerable operation[cite: 11].
SELECT
    transaction_type,
    ROUND(AVG(risk_score),2) AS avg_risk_score
FROM finance_transactions
GROUP BY transaction_type
ORDER BY avg_risk_score DESC;


-- QUESTION 7: Which active transaction access channels generate the highest average risk index ratings?
-- INSIGHT: Physical and digital self-service channels—specifically ATMs (36.45) and UPI (36.38)—exhibit 
-- the highest average risk velocity, indicating where strict automated validation controls should be prioritized[cite: 11].
SELECT
    channel,
    ROUND(AVG(risk_score),2) AS avg_risk_score
FROM finance_transactions
GROUP BY channel
ORDER BY avg_risk_score DESC;


-- QUESTION 8: How does the average risk score index map out when directly comparing fraudulent vs non-fraudulent activities?
-- INSIGHT: Verified fraudulent transactions maintain a severe, massive average risk score index of 82.94, 
-- compared to normal activities at 35.49. This strongly validates the predictive accuracy of the current backend risk scoring models[cite: 11].
SELECT
    is_fraud,
    ROUND(AVG(risk_score),2) AS avg_risk_score
FROM finance_transactions
GROUP BY is_fraud
ORDER BY is_fraud DESC;


-- QUESTION 9: What is the true mathematical fraud conversion rate across each defined operational risk bucket?
-- INSIGHT: The 'Very High Risk' bucket converts to fraud at a clean, absolute 100.00% rate (517 out of 517), 
-- proving that setting automated payment rejections for any transaction clearing with a risk score over 70 is highly justified[cite: 11].
SELECT
    CASE
        WHEN risk_score <= 20 THEN 'Low Risk'
        WHEN risk_score <= 40 THEN 'Medium Risk'
        WHEN risk_score <= 70 THEN 'High Risk'
        ELSE 'Very High Risk'
    END AS risk_bucket,
    COUNT(*) AS transactions,
    SUM(CASE WHEN is_fraud = 'Yes' THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(SUM(CASE WHEN is_fraud = 'Yes' THEN 1.0 ELSE 0.0 END) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM finance_transactions
GROUP BY risk_bucket
ORDER BY fraud_rate DESC;

================================================================================================================================

