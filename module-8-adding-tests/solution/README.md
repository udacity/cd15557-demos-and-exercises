# Solution — Adding Tests

The completed `models/staging/schema.yml` adds four tests to the example one:

| Model.column | Test |
|---|---|
| `stg_books.genre` | `accepted_values` (Mystery, Fiction, Technical) |
| `stg_loans.loan_id` | `unique`, `not_null` |
| `stg_loans.book_id` | `relationships` → `stg_books.book_id` |

## Expected result

After `dbt run`, running `dbt test` passes every test:

```
Done. PASS=6 WARN=0 ERROR=0 SKIP=0 TOTAL=6
```

(6 = book_id unique + book_id not_null + genre accepted_values + loan_id unique +
loan_id not_null + book_id relationships.)

To watch a test *fail*, change a genre in `seeds/raw/raw_books.csv` to something
like `Poetry`, re-run `dbt seed` and `dbt test`, then change it back.
