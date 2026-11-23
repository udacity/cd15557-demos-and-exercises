# Cleaning Dates and Toggling Grain with Jinja
*Using Jinja in dbt*

Jinja shows up in dbt in two ways, and you'll use both here:

1. a **macro** — reusable logic you call from many places, and
2. **in-model Jinja** — `var()`, expressions, and control structures written
   directly inside a model.

The library's raw loan dates arrive as **text**, and `return_date` is blank for
loans that are still out. You'll write one macro to clean any date column, reuse
it, and then build a report whose time grain you can change at run time.

## The base (already provided)

Seeds, sources, the staging models, and `int_book_loans` (one row per loan, with
the book's `genre` and the loan dates). `dbt_project.yml` loads `loan_date` and
`return_date` as text on purpose, so they genuinely need cleaning.

## Your tasks

**1. Write the macro — `macros/clean_date.sql`.**
`clean_date(column)` turns a text date column into a real `DATE`: a blank string
becomes `NULL`, and an invalid value doesn't crash the run.
(`nullif(trim(...), '')` + `try_cast(... as date)`.)

**2. Reuse it — `models/staging/stg_loans.sql`.**
Call `clean_date()` on **both** `loan_date` and `return_date`. One macro, two
columns — that's the point of a macro.

**3. Toggle the grain — `models/marts/loans_per_period.sql`.**
Count loans per time period, with the period's grain coming from a `var()`:

```sql
date_trunc('{{ var("loan_period", "month") }}', loan_date) as period
```

`var('loan_period', 'month')` defaults to monthly. Override it at run time without
editing the model:

```bash
dbt run --select loans_per_period --vars 'loan_period: week'
```

## How to run

```bash
dbt seed
dbt run
```

With the default grain you'll get **one January row (10 loans)**. Re-run with
`--vars 'loan_period: week'` and it splits into weeks (3, 3, 3, 1). Use
`dbt compile --select loans_per_period` to see the `var()` dropped into real SQL.
