-- Fact model at the grain of ONE ROW PER STREAM.
--
-- It keeps the foreign keys (what the stream points at) and adds measures
-- (numbers/flags you can aggregate later):
--   is_full_play   -- from the is_full_play() macro: did the listener hear
--                   --   at least 90% of the track?
--   plays_to_date  -- WINDOW FUNCTION: running count of plays for this track,
--                   --   in play order, WITHOUT collapsing the per-stream grain.
select
    stream_id,                                   -- grain: one row per stream
    track_id,                                    -- foreign key -> stg_tracks
    user_id,                                     -- foreign key -> stg_users
    played_at,
    seconds_played,
    {{ is_full_play('seconds_played', 'length_seconds') }} as is_full_play,
    count(*) over (
        partition by track_id
        order by played_at, stream_id
    ) as plays_to_date
from {{ ref('int_streams_enriched') }}
