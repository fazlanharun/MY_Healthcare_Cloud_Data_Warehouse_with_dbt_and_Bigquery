WITH population AS (
    SELECT
        state_id,
        year,
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
    p.year,
    sum(p.total_population) total_population,
    sum(b.total_beds) bed,
    sum(w.doctor_count) dr,
    sum(w.nurse_count) nurse,
    sum(w.doctor_count) * 10000.0 / sum(p.total_population) AS doctor_per_10k_population,
    sum(w.nurse_count) * 10000 / sum(p.total_population) AS nurse_per_10k_population,
    sum(b.total_beds) * 10000 / sum(p.total_population) AS beds_per_10k,
	case 
		when sum(w.doctor_count) * 10000.0 / sum(p.total_population) > 20.7 then 'ok'
		else 'no'
	end WHO_Indicator_DR_GT_20_7,
	case 
		when sum(w.nurse_count) * 10000 / sum(p.total_population) > 70.6 then 'ok'
		else 'no'
	end AS WHO_Indicator_Nurse_GT_70_6
FROM population p
LEFT JOIN beds b
  ON p.state_id = b.state_id AND p.year = b.year
LEFT JOIN workers w
  ON p.state_id = w.state_id AND p.year = w.year
JOIN {{ ref('dim_state') }} ds
  ON p.state_id = ds.state_id
 where p.year between 2014 and 2022
 group by  p.year
 order by year desc