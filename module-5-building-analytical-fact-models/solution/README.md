# Solution — Building Analytical Fact Models

One model completes the exercise: `models/marts/fct_loans.sql`.

Key ideas:
- The grain is **one row per loan** (`loan_id`).
- Foreign keys (`book_id`, `member_id`) stay as-is.
- Measures are derived: `loan_duration_days` uses date subtraction (DuckDB
  returns whole days), and `is_returned` is a boolean flag.
- `book_loans_to_date` is a **window function** —
  `count(*) over (partition by book_id order by loan_date, loan_id)` — a running
  count of loans per book that keeps the one-row-per-loan grain. It is the same
  running-total pattern the course project uses for running revenue.

## Expected result

`fct_loans` has **10 rows** (one per loan), materialized as a table.

- `loan_duration_days` is filled for the 6 returned loans (values 10–14) and
  `null` for the 4 still out.
- `is_returned` is `true` for 6 loans, `false` for 4.
- `book_loans_to_date` climbs 1, 2, 3… within each `book_id` as loans accumulate
  in date order, and restarts at 1 for the next book.

Example rows:

| loan_id | book_id | loan_duration_days | is_returned | book_loans_to_date |
|---|---|---|---|---|
| 101 | 1 | 14 | true | 1 |
| 103 | 1 | 10 | true | 2 |
| 102 | 2 | (null) | false | 1 |
| 110 | 2 | 13 | true | 3 |

Because it's a fact at loan grain, an analyst can now
`select book_id, avg(loan_duration_days) from fct_loans group by book_id`
without reshaping anything.
