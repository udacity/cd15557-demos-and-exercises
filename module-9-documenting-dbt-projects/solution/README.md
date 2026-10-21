# Solution — Documenting dbt Projects

Two files complete the exercise:

- `models/staging/docs.md` — adds a `loan_id` doc block next to the provided
  `book_id` one.
- `models/staging/schema.yml` — documents `stg_loans` (model + all columns),
  with `loan_id` pulling from the doc block via `{{ doc('loan_id') }}`.

## Expected result

```bash
dbt run
dbt docs generate
```

`dbt docs generate` completes successfully and writes `target/catalog.json` and
`target/manifest.json`. The manifest now carries descriptions for both
`stg_books` and `stg_loans` and every column — with `book_id` and `loan_id`
resolved from the shared doc blocks.

`dbt docs serve` would render all of this as a searchable documentation site with
a lineage graph.
