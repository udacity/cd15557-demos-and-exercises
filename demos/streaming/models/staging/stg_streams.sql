-- Clean staging layer over the raw_streams seed.
select
    stream_id,
    track_id,
    user_id,
    played_at,
    seconds_played,
    device
from {{ source('streaming', 'raw_streams') }}
