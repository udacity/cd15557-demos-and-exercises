# Solution — Counting Loans per Book
*Module 1 · Getting Started with dbt*

Two files complete the exercise. Drop them into the starter project at the paths below and run `dbt run`.

| Solution file | Goes in the project at |
|---|---|
| `stg_loans.sql` | `models/staging/stg_loans.sql` |
| `book_loan_counts.sql` | `models/marts/book_loan_counts.sql` |

## Expected result

`dbt run` builds three models — `stg_books` and `stg_loans` as **views**, `book_loan_counts` as a **table**. `book_loan_counts` returns one row per book:

| book_id | title | times_loaned |
|---|---|---|
| 1 | The Silent Library | 3 |
| 2 | Data Modeling 101 | 3 |
| 3 | Garden of Forks | 1 |
| 4 | The Analytics Handbook | 2 |
| 5 | Midnight Trains | 0 |
| 6 | Rivers of Code | 1 |

Book 5 has zero loans, confirming the `LEFT JOIN` keeps never-loaned books.
