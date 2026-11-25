"""Render the library's daily artifacts from Jinja templates.

Jinja is a general-purpose templating engine. dbt uses it to turn SQL templates
into SQL, but Jinja works on any text: HTML, SQL, YAML, anything. This script
renders three templates from one small dataset so you can see the same engine
drive three different file types.

This harness is complete. Your work is in the three files under templates/.

Run it:  python render.py
Output:  the output/ folder
"""

from pathlib import Path
from jinja2 import Environment, FileSystemLoader


# --- A custom filter --------------------------------------------------------
# Filters transform a value inside a template: {{ value | filter }}.
# Jinja ships many (upper, lower, default, ...); you can add your own.
def fine(days_overdue):
    """Overdue fine at 25 cents a day, formatted as dollars."""
    return "${:.2f}".format(days_overdue * 0.25)


# --- The environment --------------------------------------------------------
# trim_blocks / lstrip_blocks are whitespace controls: they stop {% ... %} tags
# from leaving blank lines and stray indentation in the rendered output.
env = Environment(
    loader=FileSystemLoader("templates"),
    trim_blocks=True,
    lstrip_blocks=True,
)
env.filters["fine"] = fine


# --- The data ---------------------------------------------------------------
library_name = "Riverside Library"

loans = [
    {"title": "The Pragmatic Programmer", "borrower": "Member 1042", "days_overdue": 3},
    {"title": "Clean Code", "borrower": "Member 1177", "days_overdue": 0},
    {"title": "Dune", "borrower": "Member 1203", "days_overdue": 12},
    {"title": "SQL for Smarties", "borrower": "Member 1318", "days_overdue": 0},
]

branches = ["Downtown", "Riverside", "Hilltop"]


# --- Render -----------------------------------------------------------------
out = Path("output")
out.mkdir(exist_ok=True)

(out / "overdue_loans.html").write_text(
    env.get_template("report.html").render(library_name=library_name, loans=loans)
)

(out / "loans_query.sql").write_text(
    env.get_template("query.sql").render(genre="Science Fiction")
)

(out / "branches.yml").write_text(
    env.get_template("config.yml").render(library_name=library_name, branches=branches)
)

print("Rendered 3 files to output/: overdue_loans.html, loans_query.sql, branches.yml")
