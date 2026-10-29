-- Clean staging layer over the raw_users seed.
select
    user_id,
    country,
    plan
from {{ source('streaming', 'raw_users') }}
