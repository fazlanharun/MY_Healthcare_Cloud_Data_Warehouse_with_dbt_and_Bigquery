
WITH source as (
    select distinct state 
    from {{ ref('stg_population_state') }}
    where state IS NOT NULL
),

--incase state name change such as in kedah to kedah darul aman. johor to johor darul takzim.
scd AS (
    SELECT
    SAFE_CAST(farm_fingerprint(state) AS INT64) AS state_id,
    state as state_name
FROM source
)


select *
from scd