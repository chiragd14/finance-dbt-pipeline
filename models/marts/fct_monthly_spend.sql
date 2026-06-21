-- models/marts/fct_monthly_spend.sql
-- ============================================================
-- Fact table: monthly spend by category
-- Grain  : 1 row per category per year_month
-- Depends: int_transactions_enriched
-- Purpose: Primary Power BI data source for spend trend visuals.
--          Week 4 deliverable.
-- ============================================================

-- TODO (Week 4): uncomment and complete after int model is done

-- with base as (
--     select * from {{ ref('int_transactions_enriched') }}
--     where not is_income
--       and spend_bucket != 'Transfer'
-- ),
-- aggregated as (
--     select
--         year_month,
--         transaction_year,
--         transaction_month,
--         category,
--         spend_bucket,
--         count(*)                          as transaction_count,
--         sum(amount_abs)                   as total_spend,
--         avg(amount_abs)                   as avg_transaction_amount,
--         min(amount_abs)                   as min_transaction_amount,
--         max(amount_abs)                   as max_transaction_amount
--     from base
--     group by 1,2,3,4,5
-- )
-- select * from aggregated

select 1 as placeholder  -- remove when Week 4 work begins
