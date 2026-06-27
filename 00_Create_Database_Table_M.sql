-- ========================================================================================
-- DATABASE SETUP & DDL CONFIGURATION
-- ========================================================================================

-- Initialize Target Analytical Database Environment
DROP DATABASE IF EXISTS Project_3;
CREATE DATABASE Project_3;

-- Establish Core Customer Master Table Schema
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male','Female')),
    date_of_birth DATE NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    occupation VARCHAR(50) NOT NULL,
    customer_segment VARCHAR(20) CHECK (customer_segment IN('Retail','Premium','SME','Corporate','Wealth')),
    annual_income NUMERIC(15,2) CHECK (annual_income >= 0),
    join_date DATE NOT NULL
);

-- Establish Core Financial Ledger Transactions Schema
DROP TABLE IF EXISTS finance_transactions;
CREATE TABLE finance_transactions (
    transaction_id VARCHAR(15) PRIMARY KEY,
    transaction_date DATE NOT NULL,
    account_id VARCHAR(15) NOT NULL,
    customer_id VARCHAR(10) NOT NULL,
    transaction_type VARCHAR(30) NOT NULL,
    channel VARCHAR(30) NOT NULL,
    merchant_category VARCHAR(50) NOT NULL,
    amount NUMERIC(15,2) CHECK (amount >= 0),
    fee_amount NUMERIC(12,2) CHECK (fee_amount >= 0),
    tax_amount NUMERIC(12,2) CHECK (tax_amount >= 0),
    currency CHAR(3) NOT NULL,
    transaction_status VARCHAR(20) CHECK (transaction_status IN('Success','Failed','Pending')),
    is_fraud VARCHAR(3) CHECK (is_fraud IN ('Yes','No')),
    risk_score INTEGER CHECK (risk_score BETWEEN 0 AND 100),
    reference_no VARCHAR(25) UNIQUE,
    risk_category VARCHAR(25),
    CONSTRAINT fk_customer FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);


-- ========================================================================================
-- VECTORIZED BULK FILE INGESTION (ETL LOAD)
-- ========================================================================================

-- Note: Adjust local system directory path parameters as necessary during deployment
COPY customers (customer_id, customer_name, gender, date_of_birth, city, state, occupation, customer_segment, annual_income, join_date)
FROM 'E:\All My Study\Data Analytics Projects\All My Projects Inside\01 data\Project_3_Finance_Analysis\customers_clean_csv.csv'
DELIMITER ','
CSV HEADER;

COPY finance_transactions (transaction_id, transaction_date, account_id, customer_id, transaction_type, channel, merchant_category, amount, fee_amount, tax_amount, currency, transaction_status, is_fraud, risk_score, reference_no, risk_category)
FROM 'E:\All My Study\Data Analytics Projects\All My Projects Inside\01 data\Project_3_Finance_Analysis\finance_transactions_clean_csv.csv'
DELIMITER ','
CSV HEADER;


-- ========================================================================================
-- DATA STORAGE & LOAD VERIFICATION AUDITS
-- ========================================================================================

-- AUDIT 1: Total Baseline Customer Profile Records Loaded
-- INSIGHT: System successfully ingested exactly 5,000 master client demographics.
SELECT COUNT(*) AS total_customer_records FROM customers;

-- AUDIT 2: Total Baseline Transaction Ledger Records Loaded
-- INSIGHT: System successfully populated exactly 50,000 processing lines into the ledger.
SELECT COUNT(*) AS total_ledger_transactions FROM finance_transactions;


-- ========================================================================================
-- HIGH-PERFORMANCE TUNING & PORTFOLIO INDEXING
-- ========================================================================================

-- Clear legacy indexing architecture
DROP INDEX IF EXISTS idx_customer_id;
DROP INDEX IF EXISTS idx_transaction_date;
DROP INDEX IF EXISTS idx_state;
DROP INDEX IF EXISTS idx_segment;
DROP INDEX IF EXISTS idx_transaction_type;
DROP INDEX IF EXISTS idx_is_fraud;
DROP INDEX IF EXISTS idx_risk_score;

-- QUESTION: How do we optimize sub-second response times for relational groupings and filters?
-- STRATEGIC ACTION: Deploy B-Tree indexes across frequently targeted join keys, predicates, and partitions.
CREATE INDEX idx_customer_id ON finance_transactions(customer_id);
CREATE INDEX idx_transaction_date ON finance_transactions(transaction_date);
CREATE INDEX idx_state ON customers(state);
CREATE INDEX idx_segment ON customers(customer_segment);
CREATE INDEX idx_transaction_type ON finance_transactions(transaction_type);
CREATE INDEX idx_is_fraud ON finance_transactions(is_fraud);
CREATE INDEX idx_risk_score ON finance_transactions(risk_score);


-- ========================================================================================
-- DATABASE VIEWS ARCHITECTURE & COMPREHENSIVE FLATTENING
-- ========================================================================================

-- VIEW 1: INNER JOIN Relation Virtual Layer
-- OBJECTIVE: Serves as the primary operational matrix for perfectly reconciled transactional activities.
DROP VIEW IF EXISTS vw_inner_details;
CREATE VIEW vw_inner_details AS
SELECT
    c.customer_id,
    c.customer_name,
    c.gender,
    c.date_of_birth,
    c.city,
    c.state,
    c.occupation,
    c.customer_segment,
    c.annual_income,
    c.join_date,
    ft.transaction_id,
    ft.transaction_date,
    ft.account_id,
    ft.customer_id AS customer_profile_id, -- Aliased to resolve lookup column namespace conflicts
    ft.transaction_type,
    ft.channel,
    ft.merchant_category,
    ft.amount,
    ft.fee_amount,
    ft.tax_amount,
    ft.currency,
    ft.transaction_status,
    ft.is_fraud,
    ft.risk_score,
    ft.reference_no,
    ft.risk_category
FROM customers c
JOIN finance_transactions ft ON c.customer_id = ft.customer_id;


-- VIEW 2: LEFT JOIN Relation Virtual Layer
-- OBJECTIVE: Identifies full customer demographics, highlighting cold accounts with zero transactional history.
DROP VIEW IF EXISTS vw_left_details;
CREATE VIEW vw_left_details AS
SELECT
    c.customer_id,
    c.customer_name,
    c.gender,
    c.date_of_birth,
    c.city,
    c.state,
    c.occupation,
    c.customer_segment,
    c.annual_income,
    c.join_date,
    ft.transaction_id,
    ft.transaction_date,
    ft.account_id,
    ft.customer_id AS customer_profile_id,
    ft.transaction_type,
    ft.channel,
    ft.merchant_category,
    ft.amount,
    ft.fee_amount,
    ft.tax_amount,
    ft.currency,
    ft.transaction_status,
    ft.is_fraud,
    ft.risk_score,
    ft.reference_no,
    ft.risk_category
FROM customers c
LEFT JOIN finance_transactions ft ON c.customer_id = ft.customer_id;


-- VIEW 3: RIGHT JOIN Relation Virtual Layer
-- OBJECTIVE: Formulates full transaction validation, capturing ledger lines independent of customer profiles.
DROP VIEW IF EXISTS vw_right_details;
CREATE VIEW vw_right_details AS
SELECT
    c.customer_id,
    c.customer_name,
    c.gender,
    c.date_of_birth,
    c.city,
    c.state,
    c.occupation,
    c.customer_segment,
    c.annual_income,
    c.join_date,
    ft.transaction_id,
    ft.transaction_date,
    ft.account_id,
    ft.customer_id AS customer_profile_id,
    ft.transaction_type,
    ft.channel,
    ft.merchant_category,
    ft.amount,
    ft.fee_amount,
    ft.tax_amount,
    ft.currency,
    ft.transaction_status,
    ft.is_fraud,
    ft.risk_score,
    ft.reference_no,
    ft.risk_category
FROM customers c
RIGHT JOIN finance_transactions ft ON c.customer_id = ft.customer_id;


-- VIEW 4: FULL OUTER JOIN Relation Virtual Layer
-- OBJECTIVE: Provides full diagnostic coverage across all entity rows, regardless of key matching.
DROP VIEW IF EXISTS vw_full_details;
CREATE VIEW vw_full_details AS
SELECT
    c.customer_id,
    c.customer_name,
    c.gender,
    c.date_of_birth,
    c.city,
    c.state,
    c.occupation,
    c.customer_segment,
    c.annual_income,
    c.join_date,
    ft.transaction_id,
    ft.transaction_date,
    ft.account_id,
    ft.customer_id AS customer_profile_id,
    ft.transaction_type,
    ft.channel,
    ft.merchant_category,
    ft.amount,
    ft.fee_amount,
    ft.tax_amount,
    ft.currency,
    ft.transaction_status,
    ft.is_fraud,
    ft.risk_score,
    ft.reference_no,
    ft.risk_category
FROM customers c
FULL JOIN finance_transactions ft ON c.customer_id = ft.customer_id;


-- ========================================================================================
-- REFACTORING EXAMPLES (PRODUCTION PERFORMANCE CONFIRMATION)
-- ========================================================================================

-- QUESTION: How do view structures optimize pipeline query performance and maintainability?
-- INSIGHT: Pre-compiled view schemas eliminate the need for redundant multi-table joins, reducing query complexity.

-- Traditional Multi-Table Joins Model:
SELECT
    c.customer_name,
    c.customer_segment,
    ft.amount
FROM finance_transactions ft
JOIN customers c ON ft.customer_id = c.customer_id
ORDER BY ft.amount DESC
LIMIT 5;

-- Refactored Pre-Compiled View Model (Production Best Practice):
SELECT
    customer_name,
    customer_segment,
    amount
FROM vw_inner_details
ORDER BY amount DESC
LIMIT 5;

================================================================================================================================

