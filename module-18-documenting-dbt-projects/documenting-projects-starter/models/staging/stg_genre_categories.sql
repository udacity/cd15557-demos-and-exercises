-- Provided base model (staging layer).
select
    genre,
    category
from {{ ref('genre_categories') }}
