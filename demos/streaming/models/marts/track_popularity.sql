-- One row per track, labeled by how many times it was played.
-- Uses bucket() on an aggregate (count of streams). Same macro, a completely
-- different input from stream_listen_bands.
select
    t.track_id,
    t.title,
    count(s.stream_id) as plays,
    {{ bucket('count(s.stream_id)', [2, 4], ['niche', 'steady', 'hit']) }} as popularity_tier
from {{ ref('stg_tracks') }} as t
left join {{ ref('stg_streams') }} as s
    on t.track_id = s.track_id
group by t.track_id, t.title
