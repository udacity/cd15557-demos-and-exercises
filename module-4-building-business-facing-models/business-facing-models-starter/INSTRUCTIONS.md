# Building a Book Summary Mart
*Module 9 · Building Business-Facing Models in dbt*

Staging and intermediate models are shaped for *engineers*. A **business-facing
model** (a mart) is shaped for *people who read the data* — analysts, librarians,
managers. It has a clear name, only the columns they care about, friendly labels,
and no surprising nulls.

## The base (already provided)

- Seeds, sources, and the staging models (`stg_books`, `stg_loans`,
  `stg_genre_categories`).
- The intermediate model `int_book_loans` (one row per loan, enriched with book
  details).

## Your task

Build one business-facing mart: **`models/marts/book_summary.sql`**.

It should have **one row per book — including books that were never loaned** —
with these columns:

| Column | Meaning |
|---|---|
| `book_id` | Book identifier |
| `title`, `author`, `genre` | Book details |
| `category` | Friendly grouping from `stg_genre_categories` |
| `times_loaned` | How many times the book was loaned (`0` if never) |
| `copies_on_loan` | Loans not yet returned (`return_date` is null) |

Tips:
- Start from `stg_books` so every book shows up, then `LEFT JOIN` the rest.
- Aggregate loans from `int_book_loans` per `book_id`.
- Wrap the counts in `coalesce(..., 0)` so a book with no loans reads `0`.
- Reference every upstream model with `ref()`.

## How to run

```bash
dbt seed     # first time only
dbt run --select book_summary
```

`dbt run --select +book_summary` builds it together with everything upstream.
