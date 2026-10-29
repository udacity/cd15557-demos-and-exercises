# Counting Loans by Genre with Jinja
*Module 13 · Using Jinja in dbt Models*

A macro is one way to use Jinja. You can also use Jinja **control structures**
— `{% set %}`, `{% for %}`, `{% if %}` — directly inside a model to *generate*
SQL. This is great for repetitive columns: write the pattern once and let the
loop stamp it out.

## The base (already provided)

Seeds, sources, the staging models, and the intermediate model `int_book_loans`
(one row per loan, with the book's `genre`).

## Your task

Complete **`models/marts/loans_by_genre.sql`** so a Jinja `for`-loop builds one
count column per genre. The genre list comes from a **`var()` with a default**,
so the same model can be re-run for a different set of genres without editing it:

```sql
{% set genres = var('genres', ['Mystery', 'Fiction', 'Technical']) %}
```

`var('genres', [...])` reads a project variable named `genres` and falls back to
the default list when none is supplied. Override it at run time with `--vars`,
e.g. `dbt run --select loans_by_genre --vars 'genres: [Mystery, Fiction]'`.

The result should be a **single row**, one column per genre:

| mystery_loans | fiction_loans | technical_loans |
|---|---|---|

Inside the loop, for each genre `g`:
- count the loans whose `genre` equals `g`
- name the column `{{ g | lower }}_loans`
- put a comma after every column **except the last** — use `{% if not loop.last %},{% endif %}`

DuckDB supports `count(*) filter (where genre = '...')` for a conditional count.

## How to run

```bash
dbt seed     # first time only
dbt run --select loans_by_genre
```

Run `dbt compile --select loans_by_genre` to see the loop expanded into three
real `count(...)` columns.
