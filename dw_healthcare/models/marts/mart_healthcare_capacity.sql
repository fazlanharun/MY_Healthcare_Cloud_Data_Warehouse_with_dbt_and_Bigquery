{{ config(materialized='table', schema='mart') }}

WITH population AS (
    SELECT
        state_id,
        EXTRACT(YEAR FROM date) AS year,
        SUM(population) AS total_population
    FROM {{ ref('fact_population') }}
    GROUP BY state_id, year
),

beds AS (
    SELECT
        state_id,
        year,
        SUM(total_beds) AS total_beds
    FROM {{ ref('fact_hospital_beds') }}
    GROUP BY state_id, year
),

workers AS (
    SELECT
        state_id,
        year,
        SUM(doctor_count) AS doctor_count,
        SUM(nurse_count) AS nurse_count
    FROM {{ ref('fact_healthcare_staff') }}
    GROUP BY state_id, year
)

SELECT
    ds.state_name,
    p.year,
    p.total_population,
    b.total_beds,
    w.doctor_count,
    w.nurse_count,
    SAFE_DIVIDE(w.doctor_count + w.nurse_count, p.total_population) * 1000 AS health_worker_per_1000,
    SAFE_DIVIDE(b.total_beds, p.total_population) * 10000 AS beds_per_10k
FROM population p
LEFT JOIN beds b
  ON p.state_id = b.state_id AND p.year = b.year
LEFT JOIN workers w
  ON p.state_id = w.state_id AND p.year = w.year
JOIN {{ ref('dim_state') }} ds
  ON p.state_id = ds.state_id
