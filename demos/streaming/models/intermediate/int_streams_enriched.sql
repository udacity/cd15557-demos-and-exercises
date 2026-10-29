-- One row per stream, enriched with its track, genre, and artist attributes.
-- This is the join layer the fact and genre marts build on, so neither has to
-- repeat the same joins.
select
    s.stream_id,
    s.track_id,
    s.user_id,
    s.played_at,
    s.seconds_played,
    s.device,
    t.title,
    t.genre,
    t.length_seconds,
    a.artist_name
from {{ ref('stg_streams') }} as s
join {{ ref('stg_tracks') }} as t
    on s.track_id = t.track_id
join {{ ref('stg_artists') }} as a
    on t.artist_id = a.artist_id
