-- Solution: models/marts/loans_per_period.sql
-- date_trunc's unit comes from a var() with a default, so the SAME model reports
-- at whatever grain you ask for. Default is 'month'; override at run time:
--   dbt run --select loans_per_period --vars 'loan_period: week'
select
    date_trunc('{{ var("loan_period", "month") }}', loan_date) as period,
    count(*) as loans
from {{ ref('int_book_loans') }}
group by 1
order by 1
