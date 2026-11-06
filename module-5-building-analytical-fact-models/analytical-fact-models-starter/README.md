# Building a Loans Fact with a Running Count
*Module 5 · Building Analytical Fact Models*

A **fact model** records business *events* at a single, well-defined **grain** —
one row per event — and carries two kinds of columns:

- **Foreign keys**: what the event points at (which book, which member).
- **Measures**: numbers and flags you can later aggregate (durations, counts,
  yes/no flags).

Here the event is a **loan**, so the grain is *one row per loan*.

## The base (already provided)

Seeds, sources, the staging models, and the intermediate model
`int_book_loans`.

## Your task

Build **`models/marts/fct_loans.sql`** from `stg_loans`, one row per loan:

| Column | Kind | Notes |
|---|---|---|
| `loan_id` | grain | one row per loan |
| `book_id`, `member_id` | foreign keys | what the loan points at |
| `loan_date`, `return_date` | event dates | |
| `loan_duration_days` | measure | `return_date - loan_date` (null if not returned) |
| `is_returned` | measure (flag) | `true` when `return_date` is not null |
| `book_loans_to_date` | measure (window) | running count of loans for this book, in date order |

Reference the upstream model with `ref()`.

### The window-function measure

`book_loans_to_date` is a **window function** — it adds an analytical measure
*without* collapsing the one-row-per-loan grain:

```sql
count(*) over (partition by book_id order by loan_date, loan_id) as book_loans_to_date
```

`partition by book_id` restarts the count for each book, and `order by loan_date`
makes it a *running* count — for each loan, how many times that book had been
loaned up to and including this one. (This is the same running-total pattern the
course project uses for running revenue.)

## How to run

```bash
dbt seed     # first time only
dbt run --select fct_loans
```

Because it's a fact table at loan grain, a later analysis can simply
`group by book_id` (or `member_id`) and sum the measures — no reshaping needed.
