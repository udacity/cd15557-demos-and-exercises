# Solution — Counting Loans by Genre with Jinja
*Module 7 · Using Jinja in dbt Models*

One model completes the exercise: `models/marts/loans_by_genre.sql`.

```sql
{% set genres = var('genres', ['Mystery', 'Fiction', 'Technical']) %}

select
    {% for g in genres %}
    count(*) filter (where genre = '{{ g }}') as {{ g | lower }}_loans
    {%- if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref('int_book_loans') }}
```

`var('genres', [...])` reads a project variable and falls back to the default
list, so the model is configurable: `dbt run --select loans_by_genre --vars
'genres: [Mystery, Fiction]'` rebuilds it with just those two columns. The
`for`-loop stamps out one `count(...)` column per genre, and
`{% if not loop.last %},{% endif %}` places commas between them but not after the
last one.

## Expected result

A single row:

| mystery_loans | fiction_loans | technical_loans |
|---|---|---|
| 3 | 1 | 6 |

(Mystery: 3 loans of book 1. Fiction: 1 loan of book 3. Technical: 3 + 2 + 1 = 6
across books 2, 4, and 6. Total 10 loans.)

`dbt compile --select loans_by_genre` shows the loop expanded into three explicit
`count(...)` columns.
