# Catching Bad Loans with Tests
*Module 8 · Adding Tests*

Tests are how dbt checks that your data is what you expect. The most common ones
are **generic tests** you declare in YAML:

- `unique` — no duplicate values in a column
- `not_null` — no missing values
- `accepted_values` — values come from a known list
- `relationships` — every value exists in another model (a foreign-key check)

## The base (already provided)

Seeds, sources, the staging models, and the intermediate model. A starter
`models/staging/schema.yml` already tests `stg_books.book_id` as an example.

## Your task

Extend **`models/staging/schema.yml`** with three more tests:

1. On `stg_books.genre` — an `accepted_values` test allowing only
   `Mystery`, `Fiction`, `Technical`.
2. On `stg_loans.loan_id` — `unique` and `not_null`.
3. On `stg_loans.book_id` — a `relationships` test pointing at
   `stg_books.book_id`, so every loan refers to a real book.

## How to run

```bash
dbt seed     # first time only
dbt run      # build the models the tests check
dbt test     # run the tests
```

All tests should **pass** against the provided data. To see a test fail on
purpose, temporarily add a value like `'Poetry'` to a book's genre in the seed —
then put it back.
