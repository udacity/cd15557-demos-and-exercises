{% docs book_id %}
The unique identifier for a book in the catalog. Loans reference this key to
say which book was borrowed.
{% enddocs %}

{% docs loan_id %}
The unique identifier for a loan (a single checkout of a book). This is the
grain of the loans data: one row per loan.
{% enddocs %}
