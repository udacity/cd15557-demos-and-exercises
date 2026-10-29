# Ranking Popular Books through a DAG
*Module 3 · Working with dbt DAGs*

Every time one model references another with `ref()`, dbt records a dependency
and draws an edge in the project's **DAG** (directed acyclic graph). dbt then
uses that graph to build models in the right order — upstream before downstream.

In this exercise you'll grow the library project from a flat staging layer into
a small three-layer DAG:

```
staging  ->  intermediate  ->  mart
```

## The base (already provided)

- **Seeds** load the raw library tables into a `raw` schema.
- **Sources** in `models/staging/_sources.yml` point at those raw tables.
- **Staging models** are built for you: `stg_books`, `stg_loans`,
  `stg_genre_categories`.

You'll add the layers on top.

## Your tasks

1. **Build the intermediate model** — `models/intermediate/int_book_loans.sql`
   Join `stg_loans` to `stg_books` using `ref()` for each one, so there's one
   row per loan enriched with the book's `title` and `genre`.

2. **Build the mart model** — `models/marts/popular_books.sql`
   Reference `int_book_loans` with `ref()` and count the loans per book to get
   `loan_count`. Order by `loan_count`, highest first.

3. **Run the DAG and inspect it.**
   - `dbt run` builds everything in dependency order.
   - `dbt run --select +popular_books` builds `popular_books` **and everything
     upstream of it** — the `+` prefix selects the whole chain that feeds it.
   - `dbt ls --select +popular_books` prints that lineage without building.

## How to run

```bash
dbt seed     # load the raw tables (first time only)
dbt run      # build staging -> intermediate -> mart
```

Watch the run order in the output: dbt builds the staging views, then the
intermediate view, then the `popular_books` table — because that's the order
the `ref()` edges require.
