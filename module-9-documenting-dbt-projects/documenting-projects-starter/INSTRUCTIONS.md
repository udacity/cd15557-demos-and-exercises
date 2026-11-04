# Documenting the Library Project
*Module 17 · Documenting dbt Projects*

In dbt, you document models and columns right in the YAML, next to the code, and dbt turns those descriptions into a browsable docs site. For text you want to reuse, write a **doc block** once and reference it with `{{ doc('name') }}`.

## The base (already provided)

Seeds, sources, the staging models, and the intermediate model. Two files are started for you:

- `models/staging/schema.yml` has `stg_books` fully documented as an example.
- `models/staging/docs.md` holds a `book_id` doc block that `schema.yml` references with `{{ doc('book_id') }}`.

## Your task

1. In `models/staging/docs.md`, add a doc block named `loan_id` describing the loan identifier.
2. In `models/staging/schema.yml`, add `stg_loans`:
   - a model `description`
   - `loan_id` documented via `"{{ doc('loan_id') }}"`
   - plain-text descriptions for `book_id`, `member_id`, `loan_date`, `return_date`

## How to run

```bash
dbt seed
dbt run
dbt docs generate
```

`dbt docs generate` writes `target/catalog.json` and `target/manifest.json`. In a full dbt setup `dbt docs serve` opens the docs site in a browser. Here, a successful `docs generate` (and your descriptions showing up in the manifest) confirms the documentation is wired up correctly.
