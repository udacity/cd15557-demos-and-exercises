-- Provided base model (staging layer).
select
    loan_id,
    book_id,
    member_id,
    loan_date,
    return_date
from {{ source('library', 'raw_loans') }}
