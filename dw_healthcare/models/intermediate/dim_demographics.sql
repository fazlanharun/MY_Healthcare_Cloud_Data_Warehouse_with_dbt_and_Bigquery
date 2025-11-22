
WITH source AS (
    SELECT DISTINCT
        sex,
        age
    FROM {{ ref('stg_population_state') }}
)

SELECT
    sex,
    age,
    SAFE_CAST(FARM_FINGERPRINT(CONCAT(sex, age)) AS INT64) AS demographic_id
FROM source
