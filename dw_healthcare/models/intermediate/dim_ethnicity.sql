
SELECT DISTINCT ethnicity
FROM {{ ref('stg_population_state') }}
