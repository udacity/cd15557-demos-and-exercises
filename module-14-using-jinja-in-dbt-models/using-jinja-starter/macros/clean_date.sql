{# TODO 1 — stg_loans.sql repeats the same date-cleaning expression for two
   columns. Move that expression into this macro so it's written once:
     - a blank string ('') becomes NULL (loans still out have no return_date)
     - a value that isn't a valid date becomes NULL instead of crashing the run
   Use {{ column }} where the column name goes. #}
{% macro clean_date(column) %}
    {# your expression here, using {{ column }} #}
{% endmacro %}
