SELECT DISTINCT
    sex,
FROM {{ ref('stg_population_state') }}
