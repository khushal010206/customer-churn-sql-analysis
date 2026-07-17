# 📊 Customer Churn Analysis Using SQL

## 📌 Overview

This project analyzes the IBM Telco Customer Churn dataset using PostgreSQL to understand customer behavior and identify factors that contribute to churn. It demonstrates SQL skills through data validation, exploratory data analysis, business analysis, customer segmentation, and advanced SQL techniques.

---

## 🎯 Objectives

- Validate data quality before analysis.
- Explore customer demographics and services.
- Analyze churn patterns.
- Identify high-risk and loyal customers.
- Demonstrate advanced SQL concepts.

---

## 🛠️ Tools

- PostgreSQL
- SQL

---

## 📂 Dataset

**Dataset:** IBM Telco Customer Churn Dataset

Key columns include:

- CustomerID
- Gender
- Tenure
- Contract
- InternetService
- PaymentMethod
- MonthlyCharges
- TotalCharges
- Churn

---

## 📋 Project Sections

### ✅ Data Validation
- Duplicate records
- NULL value checks
- Empty string validation
- Numeric range checks
- Category validation
- Customer ID uniqueness

### 📊 Exploratory Data Analysis (EDA)
- Total customers
- Churn rate
- Average tenure
- Monthly charges
- Customer distribution by gender, contract, payment method, and internet service

### 📈 Business Analysis
- Churn by contract
- Churn by payment method
- Churn by internet service
- Tenure vs churn
- Monthly charges vs churn
- Churn by gender, partner, dependents, and senior citizen status
- Service combination analysis

### ⚡ Advanced SQL
- CTEs
- CASE statements
- Aggregate Functions
- Window Functions
- DENSE_RANK()
- Subqueries

### 👥 Customer Segmentation
- High, Medium, and Low value customers
- High-risk customers
- Loyal customers

---

## 💡 Key Insights

- Month-to-Month contracts have the highest churn.
- Customers with shorter tenure churn more frequently.
- Higher monthly charges are associated with increased churn.
- Customers without Online Security or Tech Support have higher churn rates.
- Two-Year contract customers show the highest retention.

---

## 📚 SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- CASE
- CTEs
- Window Functions
- DENSE_RANK()
- Subqueries
- Aggregate Functions

---

## 📁 Repository Structure

```
customer-churn-sql-analysis/
│
├── Customer_Churn_SQL_Project.sql
├── README.md
└── dataset/
    └── customer_churn.csv
```

---

## 👨‍💻 Author

**Khushal Suthar**

