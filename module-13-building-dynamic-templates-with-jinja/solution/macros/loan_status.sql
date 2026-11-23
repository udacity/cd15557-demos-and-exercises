-- Solution: macros/loan_status.sql
{% macro loan_status(return_date_column) %}
    case
        when {{ return_date_column }} is null then 'on loan'
        else 'returned'
    end
{% endmacro %}
