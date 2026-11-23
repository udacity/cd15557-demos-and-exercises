-- Clean staging layer over the raw_streams seed.
select
    stream_id,
    track_id,
    user_id,
    played_at,
    coalesce(seconds_played, 0) as seconds_played,
    device
from {{ source('streaming', 'raw_streams') }}
