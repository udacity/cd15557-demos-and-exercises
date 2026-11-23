# Solution: Cleaning Dates and Toggling Grain with Jinja
*Using Jinja in dbt*

Two uses of Jinja in dbt: a **macro** (reusable logic) and **in-model Jinja**
(`var()` driving the SQL at run time).

## 1. The macro — `macros/clean_date.sql`

```sql
{% macro clean_date(column) %}
    try_cast(nullif(trim({{ column }}), '') as date)
{% endmacro %}
```

`nullif(trim(...), '')` turns a blank string into `NULL` (loans still out have no
return date), and `try_cast(... as date)` returns `NULL` instead of erroring on a
bad value. Written once, used anywhere a text date needs cleaning.

## 2. Reusing it — `models/staging/stg_loans.sql`

```sql
select
    loan_id,
    book_id,
    member_id,
    {{ clean_date('loan_date') }} as loan_date,
    {{ clean_date('return_date') }} as return_date
from {{ source('library', 'raw_loans') }}
```

One macro, called on two columns. `return_date` comes back `NULL` for the four
loans that are still out (loan_ids 102, 105, 107, 109).

## 3. The grain toggle — `models/marts/loans_per_period.sql`

```sql
select
    date_trunc('{{ var("loan_period", "month") }}', loan_date) as period,
    count(*) as loans
from {{ ref('int_book_loans') }}
group by 1
order by 1
```

`var('loan_period', 'month')` defaults to monthly. The same model reports at any
grain with no edits:

```bash
dbt run --select loans_per_period                          # month
dbt run --select loans_per_period --vars 'loan_period: week'   # week
```

## Expected result

| grain | rows |
|---|---|
| `month` (default) | 1 row — `2026-01-01`, 10 loans |
| `week` | 4 rows — 3, 3, 3, 1 |

`dbt compile --select loans_per_period` shows `var()` replaced by the literal
grain, e.g. `date_trunc('week', loan_date)`.

## The takeaway

A macro centralizes a rule you reuse (`clean_date`); `var()` lets one model serve
several needs without edits (`loan_period`). Neither requires touching the model's
SQL by hand once it's written.
