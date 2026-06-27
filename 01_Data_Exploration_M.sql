-- 01_Data_Exploration.sql

/*
====================================================
Project: Fintech Analytics
File: 01_Data_Exploration.sql

Objective:
Explore the structure, quality, and composition
of transaction and customer data before analysis.

Author: Devraj Singh
====================================================
*/

-- QUESTION 1: What is the total volume of transaction records processed in the log table?
-- INSIGHT: System populated exactly 50,000 transactional lines, establishing a solid, 
-- high-volume ledger baseline for downstream data audits.
SELECT COUNT(*) AS total_transactions
FROM finance_transactions;


-- QUESTION 2: What is the absolute unique customer account footprint currently tracked?
-- INSIGHT: Verifies an active base of exactly 5,000 unique customer profiles, acting 
-- as the primary master key for relational table joins.
SELECT COUNT(*) AS total_customers
FROM customers;


-- QUESTION 3: What exact calendar timeline and historical range does this dataset cover?
-- INSIGHT: Data encompasses a complete 3-year performance window spanning from 
-- January 1, 2023, to December 31, 2025, capturing long-term financial behaviors.
SELECT 
    MIN(transaction_date) AS start_date,
    MAX(transaction_date) AS end_date
FROM finance_transactions;


-- QUESTION 4: What distinct financial transaction types exist across the platform ledger?
-- INSIGHT: Identifies 10 distinct operational classifications (including Bill Payment, 
-- Card Payment, Deposit, Loan EMI, and Transfer), showing full banking capability.
SELECT DISTINCT transaction_type
FROM finance_transactions
ORDER BY transaction_type;


-- QUESTION 5: Through which unique routing channels or digital interfaces are transactions completed?
-- INSIGHT: Reveals 7 distinct payment channels (ATM, Auto Debit, Branch, Mobile App, 
-- Net Banking, POS, and UPI), reflecting a diversified omni-channel ecosystem.
SELECT DISTINCT channel
FROM finance_transactions
ORDER BY channel;


-- QUESTION 6: What is the breadth of merchant categories participating in commercial clearing?
-- INSIGHT: Maps out 14 distinct commercial merchant sectors (such as Shopping, Utilities, 
-- Mutual Funds, Rent, and Healthcare), showing consumer spending distribution.
SELECT DISTINCT merchant_category
FROM finance_transactions
ORDER BY merchant_category;


-- QUESTION 7: What distinct classifications of customer segments are captured by the CRM database?
-- INSIGHT: Isolates 5 distinct tier categories (Corporate, Premium, Retail, SME, and Wealth) 
-- to drive customer-centric revenue analysis and personalized portfolio marketing.
SELECT DISTINCT customer_segment
FROM customers
ORDER BY customer_segment;


-- QUESTION 8: What is the explicit geographic state footprint covered within the customer master?
-- INSIGHT: Captures 13 unique states across India, providing a distinct geographic layout 
-- to analyze regional penetration and localization strategies.
SELECT DISTINCT state
FROM customers
ORDER BY state;


-- QUESTION 9: What is the volume and percentage breakout across individual transaction statuses?
-- INSIGHT: Out of 50,000 logs, 42,869 are 'Success', 5,096 are 'Failed', and 2,035 are 'Pending'. 
-- This signals a baseline operational transaction success rate of 85.74%.
SELECT
    transaction_status,
    COUNT(*) AS transaction_count
FROM finance_transactions
GROUP BY transaction_status
ORDER BY transaction_count DESC;


-- QUESTION 10: How common is fraudulent activity, and what is its absolute volume distribution?
-- INSIGHT: Identifies 630 fraudulent transactions out of 50,000 lines, representing a tight 
-- 1.26% historical fraud incidence rate across the entire portfolio.
SELECT
    is_fraud,
    COUNT(*) AS transaction_count
FROM finance_transactions
GROUP BY is_fraud;


-- QUESTION 11: What are the minimum, maximum, and average risk score metrics for the ledger?
-- INSIGHT: Risk indexes span from a low of 1 to a high of 100, maintaining a controlled, 
-- moderate portfolio average risk score profile of 36.08.
SELECT
    MIN(risk_score) AS min_risk_score,
    MAX(risk_score) AS max_risk_score,
    ROUND(AVG(risk_score),2) AS avg_risk_score
FROM finance_transactions;


-- QUESTION 12: Which customer profile segments yield the largest share of the platform's user base?
-- INSIGHT: Retail accounts for the vast majority with 2,703 users, followed by Premium (895) 
-- and SME (780), showing high reliance on standard individual retail banking.
SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM customers
GROUP BY customer_segment
ORDER BY customer_count DESC;


-- QUESTION 13: What is the numerical distribution of the customer base across genders?
-- INSIGHT: Shows an exceptionally balanced demographic footprint consisting of 2,544 
-- Female consumers and 2,456 Male consumers, allowing unbiased profile indexing.
SELECT
    gender,
    COUNT(*) AS customer_count
FROM customers
GROUP BY gender;


-- QUESTION 14: What are the primary occupations of your users, and how are they distributed?
-- INSIGHT: Shows a remarkably uniform distribution across 6 professions—led by Retired (855), 
-- Student (846), and Salaried (836)—ensuring diverse market sector coverage.
SELECT
    occupation,
    COUNT(*) AS customer_count
FROM customers
GROUP BY occupation
ORDER BY customer_count DESC;


-- QUESTION 15: Which top 10 regional states house the highest concentrations of customers?
-- INSIGHT: Isolates Maharashtra (747), Gujarat (541), and Karnataka (534) as the top 3 primary 
-- market pillars, indicating where infrastructure expansion and regional campaigns excel.
SELECT
    state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC
LIMIT 10;


================================================================================================================================

