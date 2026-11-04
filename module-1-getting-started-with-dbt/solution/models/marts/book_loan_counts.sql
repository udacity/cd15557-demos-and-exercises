-- Solution: models/marts/book_loan_counts.sql
-- One row per book with its total number of loans.
-- Materialized as a table (overrides the folder default just to show config()).

{{ config(materialized='table') }}

select
    b.book_id,
    b.title,
    count(l.loan_id) as times_loaned
from {{ ref('stg_books') }} as b
left join {{ ref('stg_loans') }} as l
    on b.book_id = l.book_id
group by b.book_id, b.title
