-- Solution: models/marts/popular_books.sql
select
    book_id,
    title,
    genre,
    count(*) as loan_count
from {{ ref('int_book_loans') }}
group by book_id, title, genre
order by loan_count desc
