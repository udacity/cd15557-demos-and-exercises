-- Clean staging layer over the raw_tracks seed.
select
    track_id,
    artist_id,
    title,
    genre,
    length_seconds
from {{ source('streaming', 'raw_tracks') }}
