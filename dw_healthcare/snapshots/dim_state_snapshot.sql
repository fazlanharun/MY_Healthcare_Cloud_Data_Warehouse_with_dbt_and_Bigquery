{% snapshot dim_state_snapshot %}
{{ config(
    target_schema='snapshots',
    unique_key='state_id',
    strategy='check',
    check_cols=['state_name']
) }}

SELECT
    SAFE_CAST(FARM_FINGERPRINT(state) AS INT64) AS state_id,
    state AS state_name
FROM {{ ref('stg_population_state') }}

{% endsnapshot %}
