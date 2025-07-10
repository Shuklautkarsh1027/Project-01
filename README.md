# Doctor Visit & Prescription Behavior Analysis — Pharma SQL Case Study

## Overview  
This project simulates a real-world scenario in the pharma analytics domain, aimed at analyzing how doctor visits by sales reps influence prescription behavior. Inspired by analytics firms like ProcDNA, ZS Associates, and IQVIA, this case is designed for roles in pharma sales force effectiveness (SFE) and marketing analytics.

## Datasets  
- doctors.csv – Contains doctor details like city and specialty  
- reps.csv – Medical reps with territories  
- sales_visits.csv – Records of rep visits to doctors with dates  
- prescriptions.csv – Medicines prescribed by doctors to patients  

## Business Questions Answered  
1. Top 5 most visited doctors  
2. Doctor-wise conversion rate (#prescriptions ÷ #visits)  
3. Medicines that increased in usage after visits  
4. Best days of the week for prescriptions  
5. Top rep + city combinations by conversion rate  
6. Pre vs Post visit prescription comparison  
7. Top 3 reps per city by total prescriptions (using window functions)  
8. Month-over-month prescription trend (time-series analysis)  
9. 3-week moving average of prescriptions  
10. Most effective rep per specialty  
11. Average lag (in days) between rep visit and prescription date  



## SQL Concepts Used  
- CTEs (Common Table Expressions)  
- Aggregations (COUNT, AVG)  
- Joins (INNER, LEFT)  
- Group By & Order By  
- Window Functions  
- Date Functions  

## Folder Structure  
doctor_visit_sql_case/
├── doctors.csv  
├── reps.csv  
├── sales_visits.csv  
├── prescriptions.csv  
├── SQL_queries.sql  
└── README.md  
