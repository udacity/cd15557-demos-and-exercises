-- One row per track with its total number of streams (plays).
-- The simplest downstream model: it wires two staging models together with
-- ref(), so dbt knows to build the staging layer first.
select
    t.track_id,
    t.title,
    count(s.stream_id) as plays
from {{ ref('stg_tracks') }} as t
left join {{ ref('stg_streams') }} as s
    on t.track_id = s.track_id
group by t.track_id, t.title
