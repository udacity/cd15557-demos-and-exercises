select title, borrower, days_overdue
from loans
{# TODO 3 — Add a WHERE clause that only appears when `genre` is set.
   Wrap this line in {% if genre %} ... {% endif %}:
       where genre = '{{ genre }}'
   Because render.py sets trim_blocks/lstrip_blocks, the tags leave no blank
   line behind when genre is empty. #}
order by days_overdue desc
