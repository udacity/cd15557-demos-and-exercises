# Solution — Reusing Loan-Status Logic with a Macro
*Module 12 · Building Dynamic Templates with Jinja*

One macro completes the exercise: `macros/loan_status.sql`.

```sql
{% macro loan_status(return_date_column) %}
    case
        when {{ return_date_column }} is null then 'on loan'
        else 'returned'
    end
{% endmacro %}
```

The provided model `loan_status_report.sql` calls it with
`{{ loan_status('return_date') }}`. When dbt compiles the model, that call is
replaced by the `CASE` expression, with `return_date` dropped into the
`{{ return_date_column }}` slot.

## Expected result

`loan_status_report` has **10 rows** (one per loan):

- 4 loans read `on loan` (no return date): loan_ids 102, 105, 107, 109
- 6 loans read `returned`

| status | count |
|---|---|
| returned | 6 |
| on loan | 4 |

`dbt compile --select loan_status_report` shows the macro expanded into real SQL.
