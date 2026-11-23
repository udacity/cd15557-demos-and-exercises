# Building Dynamic Templates with Jinja
*Building Dynamic Templates with Jinja*

Jinja is a general-purpose templating engine. In the next module you'll use it
inside dbt, but Jinja isn't tied to dbt or to SQL: it turns *any* text template
plus some data into a finished file. Getting comfortable with plain Jinja now
makes the dbt version obvious later.

You'll generate three of the library's daily artifacts from one small dataset:

- an **HTML** overdue-loans report,
- a **SQL** query,
- a **YAML** config file.

## What's provided

- `render.py` — the harness. It loads the data, sets up Jinja, and renders each
  template to `output/`. It also registers a custom `fine` filter and turns on
  `trim_blocks`/`lstrip_blocks` (whitespace control). **You don't edit this.**
- `templates/base.html` — a finished base page with `title`, `heading`, and
  `content` blocks for your report to inherit.
- `templates/report.html`, `templates/query.sql`, `templates/config.yml` —
  skeletons with `TODO` comments. **This is your work.**

## Setup

```bash
pip install -r requirements.txt
```

## Your tasks

Each task is one Jinja concept. Edit the file named, then re-run `python render.py`.

1. **Template inheritance** — in `templates/report.html`, make the template
   `{% extends "base.html" %}` and fill its `title`, `heading`, and `content` blocks.
2. **A loop, a conditional, and filters** — in the `content` block, loop over
   `loans`. Show each title in UPPERCASE (the `upper` filter) with the borrower,
   then branch with `{% if %}`/`{% else %}`: overdue loans show the days and the
   fine (`{{ loan.days_overdue | fine }}`); the rest show "on time".
3. **A conditional in SQL** — in `templates/query.sql`, wrap the `where` line in
   `{% if genre %} ... {% endif %}` so it only appears when a genre is passed.
4. **A loop in YAML** — in `templates/config.yml`, loop over `branches` to emit a
   `name`/`slug` pair per branch, lower-casing the slug with the `lower` filter.

## Run it

```bash
python render.py
```

Open the three files in `output/` and check them. See the solution's README for
the expected result.

## Why this matters for dbt

A dbt model is just a Jinja template whose output is SQL. Every tag you use here —
`{% if %}`, `{% for %}`, filters, whitespace control — is the same tag you'll use
inside a model in the next module.
