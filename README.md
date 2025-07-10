# Doctor Visit & Prescription Behavior Analysis — Pharma SQL Case Study

## 📌 Overview
This project simulates a real-world scenario in the **pharma analytics domain**, aimed at analyzing how doctor visits by sales reps influence prescription behavior. Inspired by analytics firms like **ProcDNA, ZS Associates, and IQVIA**, this case is designed for roles in pharma sales force effectiveness (SFE) and marketing analytics.

## 📂 Datasets
- `doctors.csv` – Contains doctor details like city and specialty
- `reps.csv` – Medical reps with territories
- `sales_visits.csv` – Records of rep visits to doctors with dates
- `prescriptions.csv` – Medicines prescribed by doctors to patients

## 🧠 Business Questions Answered
- Top 5 most visited doctors
- Doctor-wise conversion rate (#prescriptions / #visits)
- Medicines that increased in usage after visits
- Best days of the week for prescriptions
- Top rep+city combinations by conversion rate
- Pre vs Post visit prescription comparison

## 🛠 SQL Concepts Used
- CTEs (Common Table Expressions)
- Aggregations (`COUNT`, `AVG`)
- Joins (INNER, LEFT)
- Group By & Order By
- Window Functions
- Date Functions

## 📁 Folder Structure
```
doctor_visit_sql_case/
├── doctors.csv
├── reps.csv
├── sales_visits.csv
├── prescriptions.csv
├── SQL_queries.sql
└── README.md
```

## ▶️ How to Run
1. Load the CSV files into a SQL environment (e.g., PostgreSQL, MySQL, SQLite).
2. Run the queries from `SQL_queries.sql` to perform the analysis.

---
**Built for: Analytics Portfolio | Domain: Pharma | Target: ProcDNA, ZS, IQVIA**