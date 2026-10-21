-- Solution: models/staging/stg_loans.sql
-- Clean staging layer over the raw_loans seed.

select
    loan_id,
    book_id,
    member_id,
    loan_date,
    return_date
from {{ ref('raw_loans') }}
