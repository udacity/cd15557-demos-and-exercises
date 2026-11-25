{# Buckets a numeric expression into labeled bands.

   Give it N upper bounds and N+1 labels. A row gets the label of the first bound
   it falls under; anything larger gets the last label. Drop it into a SELECT:

       {{ bucket('seconds_played', [60, 180], ['short', 'medium', 'long']) }} as listen_band

   Write the banding rule once and reuse it on any number -- a raw column, an
   aggregate, anything -- instead of hand-writing the same CASE ladder each time. #}
{% macro bucket(column_name, upper_bounds, labels) -%}
    case
    {%- for bound in upper_bounds %}
        when {{ column_name }} < {{ bound }} then '{{ labels[loop.index0] }}'
    {%- endfor %}
        else '{{ labels[upper_bounds | length] }}'
    end
{%- endmacro %}
