{% docs artist_id %}
The unique identifier for an artist. Tracks reference this key to say who
recorded them.
{% enddocs %}

{% docs track_id %}
The unique identifier for a track in the catalog. Streams reference this key to
say which track was played.
{% enddocs %}

{% docs stream_id %}
The unique identifier for a stream (a single play of a track by a user). This
is the grain of the streams data: one row per stream.
{% enddocs %}

{% docs user_id %}
The unique identifier for a listener. Streams reference this key to say who
listened.
{% enddocs %}
