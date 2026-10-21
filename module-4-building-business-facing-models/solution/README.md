# Solution — Building Business-Facing Models

One mart completes the exercise: `models/marts/book_summary.sql`.

Key ideas:
- Start from `stg_books` and `LEFT JOIN` so **every** book appears, even one
  never loaned.
- Aggregate loans from `int_book_loans` in a CTE, then join per `book_id`.
- `coalesce(..., 0)` turns "no loans" into `0` instead of `null`.

## Expected result

`book_summary` has **6 rows** (one per book), materialized as a table:

| title | genre | category | times_loaned | copies_on_loan |
|---|---|---|---|---|
| The Silent Library | Mystery | Fiction | 3 | 1 |
| Data Modeling 101 | Technical | Non-Fiction | 3 | 2 |
| The Analytics Handbook | Technical | Non-Fiction | 2 | 0 |
| Garden of Forks | Fiction | Fiction | 1 | 0 |
| Rivers of Code | Technical | Non-Fiction | 1 | 1 |
| Midnight Trains | Mystery | Fiction | 0 | 0 |

Note the last row: book 5 was never loaned, yet it still appears with `0`s —
that's the point of a business-facing model.
