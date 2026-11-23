-- models/staging/stg_loans.sql
{# TODO 2 — Once clean_date() is written, wrap both date columns with it:
       {{ clean_date('loan_date') }} as loan_date,
       {{ clean_date('return_date') }} as return_date
   One macro, called on two columns. #}
select
    loan_id,
    book_id,
    member_id,
    loan_date,
    return_date
from {{ source('library', 'raw_loans') }}
