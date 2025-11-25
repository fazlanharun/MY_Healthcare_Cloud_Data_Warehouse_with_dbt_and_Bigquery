
SELECT DISTINCT age
FROM {{ ref('stg_population_state') }}
