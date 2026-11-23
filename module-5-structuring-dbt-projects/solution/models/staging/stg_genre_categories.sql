-- Solution: models/staging/stg_genre_categories.sql
select
    genre,
    category
from {{ ref('genre_categories') }}
