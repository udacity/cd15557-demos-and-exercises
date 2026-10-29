-- One row of per-genre play counts, one column per genre.
-- The genre list comes from a var() with a default, so it can be overridden at
-- run time, e.g.
--   dbt run --select streams_by_genre --vars 'genres: [Pop, Rock]'
-- The for-loop below stamps one count column per genre, and the loop.last
-- check adds the commas between them.
{% set genres = var('genres', ['Pop', 'Rock', 'Electronic', 'Jazz']) %}

select
    {% for g in genres %}
    count(*) filter (where genre = '{{ g }}') as {{ g | lower }}_plays
    {%- if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref('int_streams_enriched') }}
