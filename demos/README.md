# Demos — Data Modeling & Transformation with dbt

Instructor-led **demos** ("I do") that precede the hands-on exercises ("you do").
Each demo is a short, runnable walkthrough on the **music-streaming** dataset.

The whole course uses **three distinct scenarios** so a learner never just copies
an answer from the stage before:

| Stage | Experience | Scenario |
|-------|-----------|----------|
| **Demo** (I do) | watch | **Music streaming** — artists, tracks, streams, users |
| **Exercise** (you do, answer key) | try with help | Library — books, loans, members, genres |
| **Project** (you do, no key) | prove it | Retail — Brightly orders, customers, products |

Everything the demos reference lives in one real, runnable dbt project:
[`streaming/`](streaming). A presenter can run any beat live.

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
**Sets up:** Module 1 exercise. **Covers:** M1–M2 (getting started with dbt).

1. **Tour the project.** Open `models/`, `seeds/`, `dbt_project.yml`.
   *Point:* this is a dbt project's anatomy — everything is just SQL + YAML.
2. **Load a seed.** Show `seeds/raw/raw_streams.csv`, run `dbt seed`.
   *Point:* seeds load raw files into DuckDB as tables.
3. **A staging model.** Open `models/staging/stg_streams.sql`; it reads with
   `source()`.
   *Point:* `source()` points at the raw tables; staging gives each one a clean model.
4. **Run it.** `dbt run --select stg_streams`; show the created view.
5. **Use `ref()`.** Open `models/marts/plays_per_track.sql` — it reads
   `ref('stg_tracks')` and `ref('stg_streams')` to count plays per track; run it.
   *Point:* `ref()` wires models together and lets dbt figure out the build order.
6. **Materializations.** Point at `+materialized: view` / `table` in
   `dbt_project.yml`.

**Hand off:** "Now you'll do the same on the library data — build clean staging
models and a 'times each book was loaned' report."

---

## Demo 2 — Wiring Streams into a Layered Pipeline
**Sets up:** Module 3 exercise. **Covers:** M3 (working with dbt DAGs).

1. **Layers.** Show `staging → intermediate → marts`.
   *Point:* each layer has one job; models only read from the layer below.
2. **See the DAG.** `dbt docs generate`, open the docs site, open the lineage graph.
   *Point:* the graph is the dependency order, drawn for you from `ref()`/`source()`.
3. **Build a slice.** `dbt run --select stg_streams+` (everything downstream).
   *Point:* selectors let you build just the part you're working on.
4. **Break and trace.** Put a typo in a `ref()` (e.g. in `int_streams_enriched.sql`),
   run, read the error, find the broken node in the graph, fix it, re-run clean.

**Hand off:** "Now you'll grow the library project into this DAG and debug a broken
dependency."

---

## Demo 3 — Building a Streams Fact with a Running Play Count
**Sets up:** Module 5 exercise. **Covers:** M4–M5 (building analytical fact models).

1. **Grain.** State it: one row per stream. Show `stg_streams`.
   *Point:* a fact's grain is the single thing one row means.
2. **Keys + measures.** Open `models/marts/fct_streams.sql` — foreign keys
   (`track_id`, `user_id`) and measures (`seconds_played`, the `is_full_play` flag).
3. **Window function.** Point at
   `count(*) over (partition by track_id order by played_at, stream_id) as plays_to_date`.
   *Point:* a window adds a running total **without** collapsing the per-stream grain.
4. **Run and read.** `dbt run --select fct_streams`; query it; show `plays_to_date`
   climbing 1→5 for track 10 (Neon Tide) and restarting for the next track.

**Hand off:** "Now you'll build the loans fact on the library data, with its own
window-function measure."

---

## Demo 4 — Flagging Full Plays & Counting Genres
**Sets up:** Module 6 and Module 7 exercises. **Covers:** M6–M7 (Jinja macros + in-model templating).

1. **A macro.** Open `macros/is_full_play.sql` — it classifies a stream as a full
   play vs a skip (`seconds_played` vs the track's `length_seconds`). Show it called
   from `fct_streams`.
2. **Show the compiled SQL.** Open `target/compiled/.../fct_streams.sql`.
   *Point:* Jinja is a templating layer; dbt compiles it down to plain SQL.
3. **In-model loop.** Open `models/marts/streams_by_genre.sql` — a `{% set %}` +
   `{% for %}` + `{% if not loop.last %}` stamping one play-count column per genre.
4. **Make it configurable.** It uses `var('genres', [...])`; run
   `dbt run --select streams_by_genre --vars 'genres: [Pop, Rock]'` and show the
   column set shrink to two. Finish with `dbt compile` to show the loop expanded.

**Hand off:** "Now you'll write a macro (M6) and a Jinja/`var()` model (M7) on the
library data."

---

## Demo 5 — Catching Bad Streams with Tests
**Sets up:** Module 8 exercise. **Covers:** M8 (adding tests).

1. **Add generic tests.** Open `models/staging/schema.yml`: `unique` + `not_null`
   on `stream_id`, `accepted_values` on `device`, a `relationships` test
   (stream → track).
2. **Green run.** `dbt test`; all 13 pass.
3. **Break it.** Change a `device` value in `raw_streams.csv` to something not in the
   accepted list, `dbt seed`, `dbt test`; read the failure output.
   *Point:* a failing test tells you which rows broke the rule, so you can trust the data.
4. **Fix and re-run.** Restore the value, `dbt seed`, `dbt test` passes.

**Hand off:** "Now you'll add the test suite on the library data, make it fail on
purpose, and fix it."

---

## Demo 6 — Documenting the Streaming Project
**Sets up:** Module 9 exercise. **Covers:** M9 (documenting dbt projects).

1. **Descriptions.** Show model and column descriptions in
   `models/staging/schema.yml`.
2. **Doc block.** Open `models/staging/docs.md` — reusable `{% docs %}` blocks
   referenced from columns with `{{ doc('stream_id') }}`.
   *Point:* write the explanation once, reuse it anywhere.
3. **Generate the site.** `dbt docs generate`, open it, browse the descriptions.
4. **Lineage.** Open the lineage graph; show sources → staging → intermediate → marts.

**Hand off:** "Now you'll document the library project and generate its docs site."

---

### Notes
- **6 demos**, mapped to modules: M1–2 → Demo 1, M3 → Demo 2, M4–5 → Demo 3,
  M6–7 → Demo 4, M8 → Demo 5, M9 → Demo 6.
- These are runnable walkthroughs to present or record from — there are no
  separate narration scripts and no recorded audio.
