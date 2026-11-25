-- Example staging model (provided).
-- Note it reads from a SOURCE now, not a seed ref():
select
    book_id,
    title,
    author,
    genre
from {{ source('library', 'raw_books') }}
