-- 1. Top 5 most visited doctors
SELECT doctor_id, COUNT(*) AS total_visits
FROM sales_visits
GROUP BY doctor_id
ORDER BY total_visits DESC
LIMIT 5;


-- 2. Conversion rate = #prescriptions ÷ #visits per doctor
WITH visits AS (
    SELECT doctor_id, COUNT(*) AS num_visits
    FROM sales_visits
    GROUP BY doctor_id
),
prescriptions_cte AS (
    SELECT doctor_id, COUNT(*) AS num_prescriptions
    FROM prescriptions
    GROUP BY doctor_id
)
SELECT v.doctor_id, num_visits, COALESCE(num_prescriptions, 0) AS num_prescriptions,
       ROUND(COALESCE(num_prescriptions, 0) * 1.0 / num_visits, 2) AS conversion_rate
FROM visits v
LEFT JOIN prescriptions_cte p ON v.doctor_id = p.doctor_id;


-- 3. Which 3 medicines increased in usage after doctor visits?
WITH presc_before_after AS (
    SELECT p.medicine,
           CASE WHEN p.prescribed_date >= MIN(v.visit_date) THEN 'After' ELSE 'Before' END AS period
    FROM prescriptions p
    JOIN sales_visits v ON p.doctor_id = v.doctor_id
)
SELECT medicine, period, COUNT(*) AS count_usage
FROM presc_before_after
GROUP BY medicine, period
ORDER BY medicine, period;


-- 4. Day-of-week analysis for best prescription response
SELECT TO_CHAR(TO_DATE(prescribed_date, 'YYYY-MM-DD'), 'Day') AS day_of_week,
       COUNT(*) AS total_prescriptions
FROM prescriptions
GROUP BY day_of_week
ORDER BY total_prescriptions DESC;


-- 5. Rep and city combo with best conversion rates
WITH visits AS (
    SELECT d.city, v.rep_id, COUNT(*) AS num_visits
    FROM sales_visits v
    JOIN doctors d ON v.doctor_id = d.doctor_id
    GROUP BY d.city, v.rep_id
),
prescriptions_cte AS (
    SELECT d.city, v.rep_id, COUNT(*) AS num_prescriptions
    FROM prescriptions p
    JOIN doctors d ON p.doctor_id = d.doctor_id
    JOIN sales_visits v ON p.doctor_id = v.doctor_id
    GROUP BY d.city, v.rep_id
)
SELECT v.city, v.rep_id, num_visits, COALESCE(num_prescriptions, 0) AS num_prescriptions,
       ROUND(COALESCE(num_prescriptions, 0) * 1.0 / num_visits, 2) AS conversion_rate
FROM visits v
LEFT JOIN prescriptions_cte p ON v.city = p.city AND v.rep_id = p.rep_id
ORDER BY conversion_rate DESC
LIMIT 10;


-- 6. Pre vs Post visit prescription comparison (using CTEs, joins, and window functions)
WITH first_visit AS (
    SELECT doctor_id, MIN(visit_date) AS first_visit_date
    FROM sales_visits
    GROUP BY doctor_id
),
prescription_periods AS (
    SELECT p.*, fv.first_visit_date,
           CASE WHEN p.prescribed_date < fv.first_visit_date THEN 'Pre' ELSE 'Post' END AS period
    FROM prescriptions p
    JOIN first_visit fv ON p.doctor_id = fv.doctor_id
)
SELECT period, COUNT(*) AS total_prescriptions
FROM prescription_periods
GROUP BY period;


-- 7. Top 3 reps per city by total prescriptions (using RANK)
WITH rep_city_rx AS (
    SELECT d.city, v.rep_id, COUNT(*) AS total_prescriptions
    FROM prescriptions p
    JOIN sales_visits v ON p.doctor_id = v.doctor_id
    JOIN doctors d ON p.doctor_id = d.doctor_id
    GROUP BY d.city, v.rep_id
),
ranked_reps AS (
    SELECT *, RANK() OVER (PARTITION BY city ORDER BY total_prescriptions DESC) AS rep_rank
    FROM rep_city_rx
)
SELECT city, rep_id, total_prescriptions
FROM ranked_reps
WHERE rep_rank <= 3
ORDER BY city, rep_rank;


-- 8. Month-over-month prescription trend
SELECT DATE_TRUNC('month', TO_DATE(prescribed_date, 'YYYY-MM-DD')) AS month,
       COUNT(*) AS total_prescriptions
FROM prescriptions
GROUP BY month
ORDER BY month;


-- 9. Moving average of prescriptions (last 3 weeks)
WITH weekly_data AS (
    SELECT DATE_TRUNC('week', TO_DATE(prescribed_date, 'YYYY-MM-DD')) AS week_start,
           COUNT(*) AS total_prescriptions
    FROM prescriptions
    GROUP BY week_start
),
moving_avg AS (
    SELECT week_start, total_prescriptions,
           ROUND(AVG(total_prescriptions) OVER (ORDER BY week_start ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3week
    FROM weekly_data
)
SELECT * FROM moving_avg;


-- 10. Most effective rep per specialty (highest prescriptions)
WITH rep_specialty_rx AS (
    SELECT d.specialty, v.rep_id, COUNT(*) AS total_prescriptions
    FROM prescriptions p
    JOIN doctors d ON p.doctor_id = d.doctor_id
    JOIN sales_visits v ON p.doctor_id = v.doctor_id
    GROUP BY d.specialty, v.rep_id
),
ranked_reps AS (
    SELECT *, RANK() OVER (PARTITION BY specialty ORDER BY total_prescriptions DESC) AS rank
    FROM rep_specialty_rx
)
SELECT specialty, rep_id, total_prescriptions
FROM ranked_reps
WHERE rank = 1
ORDER BY specialty;


-- 11. Average time (days) between visit and prescription
WITH visit_presc_lag AS (
    SELECT p.doctor_id, v.rep_id, MIN(v.visit_date) AS visit_date, MIN(p.prescribed_date) AS prescribed_date
    FROM prescriptions p
    JOIN sales_visits v ON p.doctor_id = v.doctor_id
    WHERE TO_DATE(p.prescribed_date, 'YYYY-MM-DD') >= TO_DATE(v.visit_date, 'YYYY-MM-DD')
    GROUP BY p.doctor_id, v.rep_id
)
SELECT AVG(TO_DATE(prescribed_date, 'YYYY-MM-DD') - TO_DATE(visit_date, 'YYYY-MM-DD')) AS avg_lag_days
FROM visit_presc_lag;
