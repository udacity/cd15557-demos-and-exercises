-- models/marts/loans_per_period.sql
{# TODO 3 — Report the number of loans per time period, with the grain set by a
   var() default of 'month'. The SAME model should re-run at a different grain
   with no edits:
       dbt run --select loans_per_period --vars 'loan_period: week'
   Replace the placeholder below with:
       date_trunc('{{ var("loan_period", "month") }}', loan_date) as period,
       count(*) as loans
   grouped by the period. (loan_date must be a real date first - see TODO 1 & 2.) #}
select
    count(*) as loans   -- placeholder so the starter runs before you begin
from {{ ref('int_book_loans') }}
