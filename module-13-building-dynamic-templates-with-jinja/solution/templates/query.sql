select title, borrower, days_overdue
from loans
{% if genre %}
where genre = '{{ genre }}'
{% endif %}
order by days_overdue desc
