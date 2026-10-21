-- Provided model. It CALLS the macro you will build (see the status column).
-- Once loan_status is written, dbt compiles the macro's CASE expression in place.
select
    loan_id,
    book_id,
    member_id,
    {{ loan_status('return_date') }} as status
from {{ ref('stg_loans') }}
