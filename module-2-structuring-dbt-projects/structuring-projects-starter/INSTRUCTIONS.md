# Structuring the Library's Staging Layer
*Module 5 · Structuring dbt Projects*

Now that the library's raw data arrives as proper raw tables, you'll structure the project the way a real dbt project is organized: read raw data through **sources**, bring in a small **static reference file** as a seed, and keep models tidy with **tags** and consistent **naming**.

## What's provided

- The raw tables (`raw_books`, `raw_loans`) load into a dedicated **`raw` schema** and are meant to be read as **sources**. (The small `macros/generate_schema_name.sql` that makes this work is set up for you — you don't need to touch it.)
- A source file `models/staging/_sources.yml` with `raw_books` already declared as an example.
- An example staging model `stg_books.sql` that reads from the source.
- A static reference file `seeds/genre_categories.csv` (maps each genre to a broader category).

Load everything and run the example first:

```bash
dbt seed
dbt run
```

## Your tasks

1. **Finish the source and use it.** In `_sources.yml`, add `raw_loans` under the `library` source (next to `raw_books`). Then complete `models/staging/stg_loans.sql` to read from `source('library', 'raw_loans')`, exposing `loan_id`, `book_id`, `member_id`, `loan_date`, `return_date`.

2. **Add the reference seed as a model.** Complete `models/staging/stg_genre_categories.sql` to select from the `genre_categories` seed with `ref()`, exposing `genre` and `category`. (Seeds are referenced with `ref()`, just like models.)

3. **Tag the staging models.** In `dbt_project.yml`, add `+tags: ['staging']` to the `staging` folder config so the whole layer can be selected as a group.

## What "done" looks like

- `dbt run` builds `stg_books`, `stg_loans`, and `stg_genre_categories` with no errors.
- The staging models read raw data via `source(...)`, not directly from seeds.
- `dbt ls --select tag:staging` lists your three staging models.
