{# TODO 1 — Write a macro clean_date(column) that converts a TEXT date column into
   a real DATE:
     - a blank string ('') should become NULL (loans still out have no return_date)
     - a value that isn't a valid date should not crash the run
   You'll then call it on loan_date AND return_date in stg_loans.sql.

   Hint: nullif(trim({{ column }}), '') turns a blank into NULL, and
   try_cast(... as date) returns NULL instead of erroring. #}
{% macro clean_date(column) %}
    {# your expression here, using {{ column }} #}
{% endmacro %}
