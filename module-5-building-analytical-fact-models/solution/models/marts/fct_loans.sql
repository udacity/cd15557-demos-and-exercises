-- Solution: models/marts/fct_loans.sql
select
    loan_id,
    book_id,
    member_id,
    loan_date,
    return_date,
    (return_date - loan_date) as loan_duration_days,
    (return_date is not null) as is_returned,
    -- Window function: running count of loans for this book, in date order.
    count(*) over (
        partition by book_id
        order by loan_date, loan_id
    ) as book_loans_to_date
from {{ ref('stg_loans') }}
