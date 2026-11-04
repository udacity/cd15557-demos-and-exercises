-- Solution: models/marts/loans_by_genre.sql
-- The genre list comes from a var() with a default, so it can be overridden at
-- run time, e.g. dbt run --select loans_by_genre --vars 'genres: [Mystery, Fiction]'
{% set genres = var('genres', ['Mystery', 'Fiction', 'Technical']) %}

select
    {% for g in genres %}
    count(*) filter (where genre = '{{ g }}') as {{ g | lower }}_loans
    {%- if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref('int_book_loans') }}
