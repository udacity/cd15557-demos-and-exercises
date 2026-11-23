-- Solution: models/staging/stg_loans.sql
-- clean_date() is called on both date columns: one macro, reused.
select
    loan_id,
    book_id,
    member_id,
    {{ clean_date('loan_date') }} as loan_date,
    {{ clean_date('return_date') }} as return_date
from {{ source('library', 'raw_loans') }}
