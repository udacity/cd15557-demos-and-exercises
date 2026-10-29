# Demos — Data Modeling & Transformation with dbt

Short, instructor-led **concept demos** on the **music-streaming** dataset. Each
demo supports **one conceptual module** — it makes the idea tangible with real
models, so the learner sees the concept before the hands-on implementation module.

- **Conceptual modules** → these demos (the "why", shown on the streaming data).
- **Implementation modules** → scripted code videos + the library **exercises**
  (the "how" and the "you do"); they do not use demos.

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

## Demo 1 — From One Query to Layered Models
**Supports:** Module 4 · Modular Analytics Design. **Leads into:** Module 5 (Structuring dbt Projects) + its exercise.

1. **Start with the tangle.** Answer "plays per track, with genre and artist" as one
   giant query — joins, filters, and counts all in one place. It works, but it's hard
   to read and impossible to reuse.
2. **Break it into layers.** Walk `stg_streams` (clean one source) →
   `int_streams_enriched` (do the joins once) → `plays_per_track` / `fct_streams`
   (answer questions).
   *Point:* one job per model; each layer reads only from the layer below.
3. **Show the reuse.** Both `fct_streams` and `streams_by_genre` read the same
   `int_streams_enriched`, so the join is written once and fixed in one place.

*Concept takeaway:* modular design turns one unreadable query into small,
reusable, testable models.

---

## Demo 2 — Letting ref() Draw the DAG
**Supports:** Module 6 · Dependency Graphs and Data Lineage. **Leads into:** Module 7 (Working with dbt DAGs) + its exercise.

1. **Show the wiring.** Open `int_streams_enriched` reading `ref('stg_streams')`,
   `ref('stg_tracks')`, `ref('stg_artists')`.
   *Point:* `ref()` isn't just a name — it's how dbt learns the dependency.
2. **See the graph.** `dbt docs generate`, open the lineage graph: sources → staging
   → intermediate → marts, drawn automatically.
3. **Blast radius.** Hover a node to see what's upstream/downstream; run
   `dbt build --select int_streams_enriched+` to rebuild just the affected slice.

*Concept takeaway:* you never order models by hand — the DAG is derived from
`ref()`/`source()`, and lineage is a debugging and impact tool.

---

## Demo 3 — Designing a Mart Stakeholders Trust
**Supports:** Module 8 · Designing Business-Facing Analytics Models. **Leads into:** Module 9 (Building Business-Facing Models in dbt) + its exercise.

1. **Start from the question.** "Which tracks get played the most?"
2. **Show the mart.** Open `plays_per_track` — business-named columns (`title`,
   `plays`), one row per track, nothing a stakeholder has to decode.
3. **Contrast with raw.** Query `stg_streams` — event-level rows that don't answer
   the question at a glance.

*Concept takeaway:* a mart is a product for a business question — design it around
the audience and a clear grain, not around the raw data's shape.

---

## Demo 4 — Grain & the Running-Count Window
**Supports:** Module 10 · Granularity and Aggregation. **Leads into:** Module 11 (Building Analytical Fact Models in dbt) + its exercise.

1. **State the grain.** `fct_streams` is one row per stream — say it out loud before
   any SQL.
2. **Measures at that grain.** `seconds_played`, and the `is_full_play` flag.
3. **Window, not collapse.** `plays_to_date` (running count per track) climbs 1→5 for
   "Neon Tide" **without** collapsing the per-stream rows.
4. **Aggregate on demand.** `select track_id, count(*) ... group by track_id` — the
   fact answers many questions precisely because it kept the fine grain.

*Concept takeaway:* pick the finest grain and roll up later; a window adds rollups
without throwing the grain away.

---

## Demo 5 — Turning Assumptions into Tests
**Supports:** Module 14 · Testing Assumptions in Analytics. **Leads into:** Module 15 (Adding Tests to dbt Models) + its exercise.

1. **Name an assumption.** "Every stream has a unique id and points at a real track,
   and `device` is one of a known set."
2. **Show it as tests.** In `schema.yml`: `unique` + `not_null` on `stream_id`, a
   `relationships` test (stream → track), `accepted_values` on `device`.
3. **Break one.** Change a `device` value to something off-list, `dbt seed`,
   `dbt test`; read which rows failed.

*Concept takeaway:* tests encode the assumptions consumers rely on — they point at
the broken rows; they don't prove the data is "correct", so test what matters.

---

## Demo 6 — Documenting Streams for Reuse
**Supports:** Module 16 · Documenting Analytics for Reuse. **Leads into:** Module 17 (Documenting dbt Projects) + its exercise.

1. **Descriptions with the code.** Show model/column descriptions in `schema.yml`.
2. **Write once, reuse.** A `{% docs %}` block in `docs.md`, referenced from a column
   with `{{ doc('stream_id') }}`.
3. **Generate the site.** `dbt docs generate`, browse the descriptions, search a
   column, open the lineage graph.

*Concept takeaway:* documentation lives next to the model and is generated into a
browsable site + lineage, so a teammate can self-serve instead of asking you.

---

### Notes
- **6 demos, one per conceptual module:** M4, M6, M8, M10, M14, M16. Each leads into
  its paired implementation module (M5, M7, M9, M11, M15, M17) and that module's
  exercise.
- Module 2 (Analytics Engineering and the Modern Data Stack) is a landscape concept
  with no code to demo, so it has no demo here.
- These are runnable walkthroughs to present or record from — there are no separate
  narration scripts and no recorded audio.
