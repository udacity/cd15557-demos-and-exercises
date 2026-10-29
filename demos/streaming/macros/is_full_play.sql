{# Classifies a stream as a "full play" vs a "skip".

   A play counts as full when the listener heard at least `threshold` of the
   track's length (default 90%). Returns a boolean SQL expression, so it can be
   dropped straight into a SELECT list:

       {{ is_full_play('seconds_played', 'length_seconds') }} as is_full_play

   Writing the rule once as a macro means every model classifies a play the
   same way, and the threshold can change in one place. #}
{% macro is_full_play(seconds_played, length_seconds, threshold=0.9) -%}
    {{ seconds_played }} >= {{ length_seconds }} * {{ threshold }}
{%- endmacro %}
