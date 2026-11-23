-- One row per stream, labeled by how long the listener stayed.
-- Uses bucket() on a raw column (seconds_played). A NEW model, so fct_streams
-- stays simple.
select
    stream_id,
    track_id,
    seconds_played,
    {{ bucket('seconds_played', [60, 180], ['short', 'medium', 'long']) }} as listen_band
from {{ ref('stg_streams') }}
