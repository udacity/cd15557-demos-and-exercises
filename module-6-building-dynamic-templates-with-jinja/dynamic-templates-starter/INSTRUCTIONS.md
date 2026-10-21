# Building Dynamic Templates with Jinja

dbt models are **Jinja templates** that compile to SQL. A **macro** is a named,
reusable piece of that template — write the logic once, call it from many models.

In this exercise you'll write a macro that turns a return date into a readable
status, then watch a model call it.

## The base (already provided)

Seeds, sources, the staging models, and the intermediate model. A model,
`models/marts/loan_status_report.sql`, is already written and **calls the macro
you're about to build**:

```sql
{{ loan_status('return_date') }} as status
```

## Your task

Write the macro **`macros/loan_status.sql`**. It takes the name of a
return-date column and returns a `CASE` expression:

- when that column **is null** → `'on loan'`
- otherwise → `'returned'`

Skeleton:

```sql
{% macro loan_status(return_date_column) %}
    case
        when {{ return_date_column }} is null then 'on loan'
        else 'returned'
    end
{% endmacro %}
```

The `{{ return_date_column }}` is where the caller's column name gets dropped in
when the template compiles — that's what makes the macro *dynamic*.

## How to run

```bash
dbt seed     # first time only
dbt run --select loan_status_report
```

Want to see the compiled SQL? Run `dbt compile --select loan_status_report` and
open the compiled file — the macro call is replaced by the real `CASE` block.
