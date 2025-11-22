{{ config(
    materialized='table',
    cluster_by=['state']
) }}


with source as (
    select * from {{ source('raw_api_dump', 'population_state') }}
),

filtered as (
    select
    extract(year from date) AS year,
    state,
    sex,
    age,
    ethnicity,
    population
    from source
    where 1=1
    and state not in ('Malaysia')
    and sex not in ('both')
    and ethnicity not in ('overall')
    and age not in ('overall')
)

select * from filtered

