{# Provided setup — you don't need to edit this.
   Makes a custom +schema (like the raw seeds' 'raw') resolve to that exact
   schema name, so the raw tables land in a dedicated 'raw' schema that the
   sources point at. #}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
