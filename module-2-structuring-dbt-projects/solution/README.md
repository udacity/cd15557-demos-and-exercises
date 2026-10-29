# Solution — Structuring the Library's Staging Layer
*Module 2 · Structuring dbt Projects*

Three edits complete the exercise.

| Change | Where |
|---|---|
| Add `raw_loans` to the `library` source | `models/staging/_sources.yml` (see `_sources.yml` here) |
| Build `stg_loans` from the source | `models/staging/stg_loans.sql` |
| Build `stg_genre_categories` from the seed | `models/staging/stg_genre_categories.sql` |

Plus one line in `dbt_project.yml` for Task 3:

```yaml
models:
  library:
    staging:
      +materialized: view
      +tags: ['staging']
```

## Expected result

- `dbt seed` loads `raw_books`, `raw_loans` (into the `raw` schema) and `genre_categories` (into the default schema).
- `dbt run` builds three staging views: `stg_books`, `stg_loans`, `stg_genre_categories`.
- `dbt ls --select tag:staging` lists exactly those three models.
