# Demos — Data Modeling & Transformation with dbt

Short, instructor-led **demos** ("I do") on the **music-streaming** dataset. Each
demo is a runnable walkthrough tied to **exactly one module**. Demos are a separate
asset from the scripted code videos — they can sit alongside them on the same module.

Everything the demos reference lives in one real, runnable dbt project:
[`streaming/`](streaming). A presenter can run any beat live.

The whole course uses **three distinct scenarios** so a learner never just copies
an answer from the stage before:

| Stage | Experience | Scenario |
|-------|-----------|----------|
| **Demo** (I do) | watch | **Music streaming** — artists, tracks, streams, users |
| **Exercise** (you do, answer key) | try with help | Library — books, loans, members, genres |
| **Project** (you do, no key) | prove it | Retail — Brightly orders, customers, products |

## Run it

Uses **dbt-duckdb** (the course workspace adapter). From `demos/streaming/`:

```bash
dbt seed      # load the 4 raw CSVs into the 'raw' schema
dbt run       # build staging -> intermediate -> marts
dbt test      # run the test suite
dbt docs generate && dbt docs serve   # build and open the docs site
```

Always `dbt seed` before the first `dbt run`: staging reads the raw tables with
`source()`, so the seeds must exist first.

## Project layout

```
streaming/
  seeds/raw/        raw_artists, raw_tracks, raw_streams, raw_users (CSV seeds)
  models/
    staging/        stg_* (one clean model per raw table) + _sources.yml
                    schema.yml (tests + descriptions), docs.md (doc blocks)
    intermediate/   int_streams_enriched (streams joined to track/artist/genre)
    marts/          plays_per_track, fct_streams, streams_by_genre
  macros/           generate_schema_name, is_full_play
```

The dataset is tiny on purpose (4 artists, 8 tracks, 5 users, 18 streams) so every
result is easy to read on screen.

---

## Demo 1 — Loading Streams & Counting Plays per Track
**Module 3 · Getting Started with dbt**

1. **Tour the project.** Open `models/`, `seeds/`, `dbt_project.yml`.
   *Point:* a dbt project is just SQL + YAML.
2. **Load a seed.** Show `seeds/raw/raw_streams.csv`, run `dbt seed`.
3. **A staging model.** Open `stg_streams.sql`; it reads with `source()`.
4. **Use `ref()`.** Open `plays_per_track.sql` — it reads `ref('stg_tracks')` and
   `ref('stg_streams')` to count plays per track; run it.

---

## Demo 2 — Wiring Streams into a Layered Pipeline
**Module 7 · Working with dbt DAGs**

1. **Layers.** Show `staging → intermediate → marts`; each reads only from the layer
   below.
2. **See the DAG.** `dbt docs generate`, open the lineage graph.
3. **Build a slice.** `dbt build --select stg_streams+` (everything downstream).
4. **Break and trace.** Typo a `ref()`, run, read the error, find the broken node,
   fix it.

---

## Demo 3 — Building a Streams Fact with a Running Play Count
**Module 11 · Building Analytical Fact Models in dbt**

1. **Grain.** One row per stream — show `stg_streams`.
2. **Keys + measures.** `fct_streams` with FKs (`track_id`, `user_id`) and measures
   (`seconds_played`, `is_full_play`).
3. **Window.** `count(*) over (partition by track_id order by played_at)` as
   `plays_to_date` — a running total that keeps the per-stream grain.
4. **Run and read.** Show `plays_to_date` climbing 1→5 for "Neon Tide".

---

## Demo 4 — Flagging Full Plays with a Macro
**Module 12 · Building Dynamic Templates with Jinja**

1. **The repetition.** A "full play vs skip" rule you'd otherwise rewrite in every
   model.
2. **Write the macro.** Open `macros/is_full_play.sql` (seconds heard vs track
   length); call it from `fct_streams`.
3. **Show the compiled SQL.** Open `target/compiled/.../fct_streams.sql`.
   *Point:* Jinja is templating; the warehouse only runs plain SQL.

---

## Demo 5 — Counting Genres with a Jinja Loop
**Module 13 · Using Jinja in dbt Models**

1. **In-model loop.** Open `streams_by_genre.sql` — `{% set %}` + `{% for %}` +
   `{% if not loop.last %}` stamps one play-count column per genre.
2. **Make it configurable.** It uses `var('genres', [...])`; run
   `dbt run --select streams_by_genre --vars 'genres: [Pop, Rock]'` and show the
   columns shrink to two.
3. **Compile.** `dbt compile` to show the loop expanded.

---

## Demo 6 — Catching Bad Streams with Tests
**Module 15 · Adding Tests to dbt Models**

1. **Add generic tests.** In `schema.yml`: `unique` + `not_null` on `stream_id`,
   `accepted_values` on `device`, a `relationships` test (stream → track).
2. **Green run.** `dbt test`; all 13 pass.
3. **Break it.** Set a `device` off-list, `dbt seed`, `dbt test`; read the failure.
4. **Fix and re-run.**

---

## Demo 7 — Documenting the Streaming Project
**Module 17 · Documenting dbt Projects**

1. **Descriptions.** Model/column descriptions in `schema.yml`.
2. **Doc block.** A `{% docs %}` block in `docs.md`, referenced with
   `{{ doc('stream_id') }}`.
3. **Generate the site.** `dbt docs generate`, browse descriptions, open lineage.

---

### Notes
- **7 demos, one module each:** M3, M7, M11, M12, M13, M15, M17. The Jinja topic is
  two modules (M12 macros, M13 in-model), so it is two demos.
- These are runnable walkthroughs to present or record from — no separate narration
  scripts, no recorded audio.
- Modules 5 (Structuring) and 9 (Building Business-Facing Models) don't have a demo
  in this set yet — say the word and I'll add one for each.
