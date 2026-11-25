{# Turns a text date column into a real DATE.
   The raw loan dates arrive as text, and return_date is blank for loans that are
   still out. nullif(trim(...), '') makes those blanks NULL, and try_cast returns
   NULL instead of erroring if a value isn't a valid date. Write the rule once
   here, then call it on every date column that needs it. #}
{% macro clean_date(column) %}
    try_cast(nullif(trim({{ column }}), '') as date)
{% endmacro %}
