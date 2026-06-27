# Fintech-Analytics-Project
End-to-end Data Analytics project using Excel, PostgreSQL, Python, and Power BI to analyze 50,000 fintech transactions, detect fraud patterns, evaluate transaction risk, and generate business insights.

# 💳 Fintech Analytics Project

End-to-end Data Analytics project using **Excel (Power Query), PostgreSQL, Python, and Power BI** to analyze 50,000 financial transactions, detect fraud patterns, evaluate transaction risk, and generate actionable business insights.

---

# 📌 Project Overview

Financial institutions process millions of transactions daily, making it essential to monitor revenue, customer behavior, fraud, and transaction risk.

This project analyzes a fintech transaction dataset containing **5,000 customers** and **50,000 financial transactions**. The objective is to uncover meaningful business insights through data cleaning, SQL analysis, Python exploratory data analysis (EDA), and interactive Power BI dashboards.

The project follows the complete Data Analytics workflow:

- Data Cleaning
- Database Design
- SQL Analysis
- Python EDA
- Interactive Dashboard Development
- Business Insights
- Strategic Recommendations

---

# 🛠️ Tools & Technologies

- Microsoft Excel (Power Query)
- PostgreSQL
- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Power BI
- DAX
- Git & GitHub

---

# 📂 Dataset Information

## Customers Table

| Attribute | Value |
|-----------|-------|
| Rows | 5,000 |
| Columns | 10 |

Contains customer demographic information including:

- Customer ID
- Customer Name
- Gender
- Date of Birth
- City
- State
- Occupation
- Customer Segment
- Annual Income
- Join Date

---

## Finance Transactions Table

| Attribute | Value |
|-----------|-------|
| Rows | 50,000 |
| Columns | 16 |

Contains transaction details including:

- Transaction ID
- Customer ID
- Transaction Date
- Transaction Type
- Channel
- Amount
- Fee Amount
- Tax Amount
- Payment Method
- Risk Score
- Risk Category
- Fraud Status

---

# 🗂️ Project Structure

```text
Fintech-Analytics-Project
│
├── Data
│   ├── customers_raw_csv
│   ├── customers_clean_csv
│   ├── finance_transactions_raw_csv
│   ├── finance_transactions_clean_csv
│
├── Excel
│   ├── customers_raw_excel_clean
│   ├── finance_transactions_raw_excel_clean
│
├── SQL
│   ├── 00_Database_Setup.sql
│   ├── 01_Data_Exploration.sql
│   ├── 02_KPI_Analysis.sql
│   ├── 03_Customer_Analysis.sql
│   ├── 04_Revenue_Analysis.sql
│   ├── 05_Fraud_Analysis.sql
│   ├── 06_Risk_Analysis.sql
│   ├── 07_Time_Analysis.sql
│   ├── 08_Advanced_SQL.sql
│   └── 09_Business_Questions.sql
│
├── Python
│   └── Finance_Analytics_EDA.ipynb
│
├── Power BI
│   └── Fintech Analytics Dashboard.pbix
│
├── Images
│
└── README.md
```

---

# 📊 Key Performance Indicators (KPIs)

| KPI | Value |
|------|-------:|
| Total Transactions | 50,000 |
| Total Customers | 5,000 |
| Total Transaction Amount | ₹455,534,249.62 |
| Total Fees | ₹726,242.20 |
| Total Tax | ₹130,736.35 |
| Average Transaction Value | ₹9,110.68 |
| Fraud Transactions | 630 |
| Fraud Rate | 1.26% |
| Fraud Amount | ₹5,969,443.52 |
| High Risk Transactions | 517 |
| High Risk Percentage | 1.03% |

---

# 🗄️ Database Design

The project database was designed in PostgreSQL using a relational schema.

### Tables Created

- Customers
- Finance_Transactions

### Features

- Primary Keys
- Foreign Keys
- Constraints
- Indexes
- Data Validation

---

# 📈 SQL Analysis

The project contains **10 SQL scripts** covering:

- Database Setup
- Data Exploration
- KPI Analysis
- Customer Analysis
- Revenue Analysis
- Fraud Analysis
- Risk Analysis
- Time-Based Analysis
- Advanced SQL Queries
- Business Questions

---

# 🐍 Python Exploratory Data Analysis

The Python notebook includes:

- Data Loading
- Data Inspection
- Data Validation
- Exploratory Data Analysis
- Revenue Analysis
- Customer Analysis
- Fraud Analysis
- Risk Analysis
- Time Trend Analysis
- Correlation Analysis
- Outlier Detection
- Business Insights
- Business Recommendations

Libraries Used:

- Pandas
- NumPy
- Matplotlib
- Seaborn

---

# 📊 Power BI Dashboard

The interactive dashboard consists of three pages:

### Page 1 — Executive Overview

- KPI Cards
- Revenue Trends
- Customer Overview
- Transaction Analysis

### Page 2 — Fraud Analysis

- Fraud KPIs
- Fraud by Channel
- Fraud by Transaction Type
- Fraud Distribution

### Page 3 — Risk Monitoring

- Risk Score Analysis
- Risk Category Distribution
- High Risk Transactions
- Risk Trends

---

# 💡 Key Business Insights

### Revenue

- Processed over **₹455 million** in transaction value.
- Digital transaction channels generated the highest revenue.
- Revenue was concentrated among high-value customers.

### Customers

- Premium customer segments generated higher transaction values.
- Customer acquisition remained stable throughout the analysis period.
- Customer demographics influenced transaction behavior.

### Fraud

- Fraud rate remained low at **1.26%**.
- Fraud exposure exceeded **₹5.9 million**.
- Fraud activity varied across channels and transaction types.

### Risk

- Most transactions were classified as low or medium risk.
- Fraud rates increased with higher risk categories.
- The risk scoring model effectively identified suspicious transactions.

---

# 📌 Business Recommendations

- Increase monitoring of high-risk transactions.
- Implement additional verification for critical-risk transactions.
- Focus retention strategies on premium customers.
- Strengthen fraud detection for high-risk channels.
- Continuously improve the transaction risk scoring model.
- Develop machine learning models for fraud prediction.

---

# 🚀 Skills Demonstrated

- Data Cleaning
- Data Transformation
- Relational Database Design
- SQL Query Writing
- Exploratory Data Analysis (EDA)
- Data Visualization
- Power BI Dashboard Development
- DAX Measures
- Business Intelligence
- Fraud Analytics
- Risk Analytics
- Business Storytelling

---

# 📚 Learning Outcomes

Through this project, I strengthened my practical skills in:

- SQL
- Python for Data Analysis
- Power BI
- Data Cleaning
- Financial Data Analytics
- Fraud Detection
- Risk Analysis
- Business Decision Support

---

# 👨‍💻 Author

Devraj Singh

Aspiring Data Analyst

GitHub:

LinkedIn:


