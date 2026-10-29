-- Example staging model (provided).
-- Reads the raw_books seed with ref() and exposes clean columns.
-- Follow this same pattern when you build stg_loans.

select
    book_id,
    title,
    author,
    genre
from {{ ref('raw_books') }}
