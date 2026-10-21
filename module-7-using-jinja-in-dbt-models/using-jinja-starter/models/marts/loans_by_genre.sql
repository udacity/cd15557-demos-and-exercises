-- TODO: Use a Jinja for-loop to build one count column per genre.
--
-- The genre list comes from a var() with a default (already set for you below),
-- so the same model can be re-run for a different set of genres, e.g.:
--   dbt run --select loans_by_genre --vars 'genres: [Mystery, Fiction]'
--
-- Complete the SELECT so it produces a single row with one column per genre:
--   mystery_loans | fiction_loans | technical_loans
--
-- Inside the loop, count the loans whose genre matches, and name the column
-- "<genre>_loans" in lowercase. Add a comma after every column except the
-- last one (use loop.last).

{% set genres = var('genres', ['Mystery', 'Fiction', 'Technical']) %}

select
    {% for g in genres %}
    -- TODO: count(*) filter (where genre = '...') as ..._loans   (+ comma unless loop.last)
    {% endfor %}
from {{ ref('int_book_loans') }}
