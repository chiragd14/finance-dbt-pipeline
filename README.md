# Personal Finance Analytics Pipeline

**Stack:** dbt Core · DuckDB · Power BI · GitHub Actions (planned)

---

## Project Summary

An end-to-end analytics engineering project that models personal finance transaction data using dbt best practices: layered modeling (staging → intermediate → marts), schema tests, column-level documentation, and a Power BI reporting layer.

Built to demonstrate dbt + modern data stack proficiency outside of a manufacturing BI context.

---

## Architecture

```
seeds/
  raw_transactions.csv          ← 500-row synthetic transaction ledger (2023–2024)
        │
        ▼
models/staging/
  stg_transactions              ← Clean types, signed amounts, date-part columns
        │
        ▼
models/intermediate/
  int_transactions_enriched     ← Business logic: spend_bucket, is_income flag
        │
        ▼
models/marts/
  fct_monthly_spend             ← Grain: 1 row per category per month  → Power BI
  fct_cashflow                  ← Grain: 1 row per month               → Power BI
```

---

## Quick Start

### Prerequisites

```bash
pip install dbt-duckdb
```

### Clone and run

```bash
git clone https://github.com/<your-handle>/finance-dbt-pipeline.git
cd finance-dbt-pipeline

# Copy profiles.yml to ~/.dbt/ or keep it local with --profiles-dir flag
cp profiles.yml ~/.dbt/profiles.yml

# Load seed data
dbt seed

# Run all models
dbt run

# Run all tests
dbt test

# Generate and serve documentation
dbt docs generate
dbt docs serve
```

---

## dbt Test Coverage

| Model | Tests |
|---|---|
| `raw_transactions` (source) | not_null, unique (transaction_id), accepted_values (transaction_type) |
| `stg_transactions` | not_null, unique (transaction_id), accepted_values (category, month, quarter, transaction_type) |
| `fct_monthly_spend` | not_null, unique (year_month + category), relationships |
| `fct_cashflow` | not_null, unique (year_month) |

---

## Power BI Dashboard *(Week 5–6)*

Three-visual single-page report connecting to DuckDB mart output:
- **Monthly Spend by Category** — stacked bar chart
- **Cashflow Trend** — line chart with income vs expense
- **Top Merchants** — ranked table by total spend

Screenshot and `.pbix` file to be added in Week 6.

---

## Dataset

Synthetic 500-row personal finance transaction ledger covering Jan 2023 – Dec 2024. Generated with Python using realistic merchant names, amounts, and categories representative of a mid-30s professional in the US Midwest. No real financial data used.

---

## Author

**Chirag Dave** — BI Analyst | Power BI · dbt · Snowflake · SQL  
[LinkedIn](https://www.linkedin.com/in/davechiragk) · [GitHub](https://github.com/<your-handle>)
