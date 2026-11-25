-- models/staging/stg_loans.sql
-- The raw loan dates arrive as text, and return_date is blank for loans that are
-- still out. Someone cleaned both columns by pasting the same expression twice.
{# TODO 2 — Once clean_date() is written, replace BOTH copies of the expression
   below with a call to your macro:
       {{ clean_date('loan_date') }} as loan_date,
       {{ clean_date('return_date') }} as return_date
   Run dbt again: the results should not change. #}
select
    loan_id,
    book_id,
    member_id,
    try_cast(nullif(trim(loan_date), '') as date) as loan_date,
    try_cast(nullif(trim(return_date), '') as date) as return_date
from {{ source('library', 'raw_loans') }}
