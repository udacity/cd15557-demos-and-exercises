-- Provided base model (staging layer).
select
    book_id,
    title,
    author,
    genre
from {{ source('library', 'raw_books') }}
