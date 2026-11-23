-- Solution: models/marts/book_summary.sql
with loan_stats as (
    select
        book_id,
        count(*) as times_loaned,
        count(*) filter (where return_date is null) as copies_on_loan
    from {{ ref('int_book_loans') }}
    group by book_id
)

select
    b.book_id,
    b.title,
    b.author,
    b.genre,
    g.category,
    coalesce(ls.times_loaned, 0) as times_loaned,
    coalesce(ls.copies_on_loan, 0) as copies_on_loan
from {{ ref('stg_books') }} as b
left join {{ ref('stg_genre_categories') }} as g
    on b.genre = g.genre
left join loan_stats as ls
    on b.book_id = ls.book_id
order by times_loaned desc, b.book_id
