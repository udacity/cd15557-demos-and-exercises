# Solution — Ranking Popular Books through a DAG
*Module 3 · Working with dbt DAGs*

Two new models complete the DAG.

| File | Layer | What it does |
|---|---|---|
| `models/intermediate/int_book_loans.sql` | intermediate | One row per loan, joined to its book via `ref()` |
| `models/marts/popular_books.sql` | mart | Loans counted per book via `ref()` on the intermediate |

The `ref()` calls create the dependency chain:

```
stg_books  ┐
           ├─> int_book_loans ─> popular_books
stg_loans  ┘
```

## Expected result

- `dbt run` builds the models in dependency order: the staging views first,
  then `int_book_loans`, then the `popular_books` table.
- `int_book_loans` has **10 rows** (one per loan).
- `popular_books` has **5 rows** — book 5 never appears because it has no loans
  and the intermediate model uses an inner join:

| title | genre | loan_count |
|---|---|---|
| The Silent Library | Mystery | 3 |
| Data Modeling 101 | Technical | 3 |
| The Analytics Handbook | Technical | 2 |
| Garden of Forks | Fiction | 1 |
| Rivers of Code | Technical | 1 |

- `dbt ls --select +popular_books` lists the full upstream lineage:
  `stg_books`, `stg_loans`, `int_book_loans`, `popular_books`.
