-- Clean staging layer over the raw_artists seed.
select
    artist_id,
    name as artist_name
from {{ source('streaming', 'raw_artists') }}
