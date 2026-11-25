# Solution: Templating HTML, YAML, and SQL with Jinja
*Building Dynamic Templates with Jinja*

Jinja is a general-purpose templating engine. dbt uses it on SQL, but it works on
any text. This solution renders three file types (HTML, SQL, YAML) from one small
dataset, using the four core ideas from this module: **template inheritance**,
**conditionals**, **filters**, and **whitespace control**.

Run it:

```bash
python render.py
```

It writes three files to `output/`.

## Where each concept lives

| Concept | Where |
|---|---|
| Template inheritance | `templates/report.html` extends `templates/base.html` (`{% extends %}` + `{% block %}`) |
| Conditionals | `{% if loan.days_overdue > 0 %}` in `report.html`; `{% if genre %}` in `query.sql` |
| Filters | built-in `upper`/`lower`, plus the custom `fine` filter registered in `render.py` |
| Whitespace control | `trim_blocks` + `lstrip_blocks` in `render.py`, so `{% %}` tags don't leave blank lines or stray indentation |

## Completed templates

**`templates/report.html`** — extends the base, overrides its blocks, loops the
loans, branches on overdue vs. on time, and formats the fine with the custom filter:

```html
{% extends "base.html" %}

{% block title %}Overdue Loans — {{ library_name }}{% endblock %}
{% block heading %}Overdue Loans{% endblock %}

{% block content %}
    <ul>
    {% for loan in loans %}
      <li>
        {{ loan.title | upper }} — {{ loan.borrower }}:
        {% if loan.days_overdue > 0 %}
          {{ loan.days_overdue }} days overdue, fine {{ loan.days_overdue | fine }}
        {% else %}
          on time
        {% endif %}
      </li>
    {% endfor %}
    </ul>
{% endblock %}
```

**`templates/query.sql`** — the `where` clause only appears when a genre is passed:

```sql
select title, borrower, days_overdue
from loans
{% if genre %}
where genre = '{{ genre }}'
{% endif %}
order by days_overdue desc
```

**`templates/config.yml`** — one entry per branch, slug lower-cased with a filter:

```yaml
library: {{ library_name }}
branches:
{% for branch in branches %}
  - name: {{ branch }}
    slug: {{ branch | lower }}
{% endfor %}
```

## Expected output

- `output/overdue_loans.html` — 4 loans; "Dune" (12 days) and "The Pragmatic
  Programmer" (3 days) show a fine, the other two read "on time".
- `output/loans_query.sql` — includes `where genre = 'Science Fiction'`. Pass
  `genre=None` in `render.py` and the `where` line disappears, with no blank line
  left behind (that is `trim_blocks`/`lstrip_blocks` at work).
- `output/branches.yml` — three branches with lower-cased slugs.

## The takeaway

Jinja doesn't care what kind of text it renders. A dbt model, for example, is a
Jinja template whose output happens to be SQL, so the same `{% if %}`,
`{% for %}`, filters, and whitespace rules you used here work there unchanged.
