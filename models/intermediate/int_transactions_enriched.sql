-- models/intermediate/int_transactions_enriched.sql
-- ============================================================
-- Intermediate model: enriched transactions
-- Grain  : 1 row per transaction (same as staging)
-- Depends: stg_transactions
-- Purpose: Add business classification logic — expense grouping,
--          income vs expense flag, and spend bucket labelling.
--          Week 3 deliverable.
-- ============================================================

-- TODO (Week 3):
--   1. Add is_income / is_expense boolean columns
--   2. Add spend_bucket (Essential / Discretionary / Transfer / Income)
--   3. Add month_rank window column (row_number over year_month)
--   4. Join to dim_categories when available

with base as (

    select * from {{ ref('stg_transactions') }}

),

enriched as (

    select
        *,

        -- income vs expense flag
        case
            when transaction_type = 'CREDIT' then true
            else false
        end as is_income,

        -- high-level spend bucket
        case
            when category in ('Income')                                   then 'Income'
            when category in ('Transfer')                                 then 'Transfer'
            when category in ('Rent','Utilities','Insurance','Healthcare') then 'Essential'
            else                                                               'Discretionary'
        end as spend_bucket

    from base

)

select * from enriched
