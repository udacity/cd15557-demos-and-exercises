-- Solution: models/intermediate/int_book_loans.sql
select
    l.loan_id,
    l.book_id,
    b.title,
    b.genre,
    l.loan_date,
    l.return_date
from {{ ref('stg_loans') }} as l
join {{ ref('stg_books') }} as b
    on l.book_id = b.book_id
