# Music Streaming Demo Project

The runnable dbt project behind the course demos. It models a tiny
music-streaming service (4 artists, 8 tracks, 5 users, 18 streams) so every
result is easy to read on screen.

## Run it

From this folder:

```bash
dbt seed      # load the 4 raw CSVs into the 'raw' schema
dbt run       # build staging -> intermediate -> marts
dbt test      # run the test suite
dbt docs generate && dbt docs serve --host 0.0.0.0 --port 8580   # build and serve the docs site
```

Always `dbt seed` before the first `dbt run`: staging reads the raw tables with
`source()`, so the seeds must exist first.

## Project layout

```
seeds/raw/        raw_artists, raw_tracks, raw_streams, raw_users (CSV seeds)
models/
  staging/        stg_* (one clean model per raw table) + _sources.yml
                  schema.yml (tests + descriptions), docs.md (doc blocks)
  intermediate/   int_streams_enriched (streams joined to track/artist/genre)
  marts/          plays_per_track, fct_streams, streams_by_genre
macros/           generate_schema_name, is_full_play
```
