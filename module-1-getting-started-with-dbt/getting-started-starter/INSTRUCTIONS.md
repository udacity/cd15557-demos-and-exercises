# Getting Started with dbt

A small public library keeps two raw files: a list of **books** and a log of **loans**. Your job is to turn that raw data into clean dbt models and one simple report — and get comfortable with how a dbt project runs.

## What you'll build

- A **staging model** for loans (a clean layer over the raw data).
- A **mart** that counts how many times each book has been loaned, built from your staging models with `ref()`.

## Getting started

The project is already set up for you. The two raw files are dbt **seeds** (`seeds/raw_books.csv`, `seeds/raw_loans.csv`), and one example staging model, `models/staging/stg_books.sql`, is provided so you can see the pattern. The workspace is already connected to the database — you don't need to configure a connection.

First, load the seeds and run the project as-is to confirm everything works:

```bash
dbt seed
dbt run
```

## Your tasks

1. **Create the loans staging model.** In `models/staging/stg_loans.sql`, select from the `raw_loans` seed with `ref()` and expose: `loan_id`, `book_id`, `member_id`, `loan_date`, `return_date`. Follow the pattern in `stg_books.sql`.

2. **Build the mart.** In `models/marts/book_loan_counts.sql`, use `ref()` to read from `stg_books` and `stg_loans`, and return one row per book with `book_id`, `title`, and `times_loaned`. Keep books that have never been loaned (a `LEFT JOIN` from books to loans).

3. **Set the materialization.** Make `book_loan_counts` a **table** by adding a `config(materialized='table')` block at the top of the model. (Staging models are already views by default.)

4. **Run it.** Build your models and check the results:

```bash
dbt run
```

## What "done" looks like

- `dbt run` completes with no errors and builds three models: `stg_books`, `stg_loans`, and `book_loan_counts`.
- `stg_books` and `stg_loans` are **views**; `book_loan_counts` is a **table**.
- `book_loan_counts` has one row per book, and the loan counts match the raw data (for example, "The Silent Library" was loaned 3 times).
