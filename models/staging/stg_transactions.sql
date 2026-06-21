-- models/staging/stg_transactions.sql
-- ============================================================
-- Staging model: raw_transactions
-- Grain  : 1 row per transaction (transaction_id is PK)
-- Source : seeds.raw_transactions (CSV loaded via dbt seed)
-- Purpose: Standardise column names, types, and null handling.
--          No business logic lives here — that belongs in
--          intermediate models.
-- ============================================================

with source as (

    select * from {{ ref('raw_transactions') }}

),

renamed as (

    select

        -- keys
        transaction_id,

        -- dates
        cast(transaction_date as date)                          as transaction_date,
        date_part('year',  cast(transaction_date as date))::int as transaction_year,
        date_part('month', cast(transaction_date as date))::int as transaction_month,
        date_part('quarter', cast(transaction_date as date))::int as transaction_quarter,
        strftime(cast(transaction_date as date), '%Y-%m')       as year_month,

        -- merchant & classification
        trim(merchant_name)                                     as merchant_name,
        trim(category)                                          as category,

        -- amounts
        -- credits (income) stored as positive; debits stored as negative
        -- so net cashflow = sum(amount_signed) is always correct
        case
            when upper(trim(transaction_type)) = 'CREDIT'
                then  abs(amount)
            else     -abs(amount)
        end                                                     as amount_signed,
        abs(amount)                                             as amount_abs,
        upper(trim(transaction_type))                           as transaction_type,

        -- payment & account
        trim(payment_method)                                    as payment_method,
        trim(account_name)                                      as account_name,

        -- optional metadata
        nullif(trim(notes), '')                                 as notes,

        -- audit helper: flag rows where category is null or unrecognised
        case
            when trim(category) is null or trim(category) = ''
                then true
            else false
        end                                                     as is_uncategorised

    from source

)

select * from renamed
