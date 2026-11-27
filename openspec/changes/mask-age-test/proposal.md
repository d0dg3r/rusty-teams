## Why

The macOS CI job fails on
`blur::tests::the_mask_age_counts_the_frames_shown_since_its_source_frame`.
The test sleeps 60 ms and expects at least three frames before the mask
returns. On `forgejo-runner-mac-01`, under the full suite, the test thread
is scheduled again only after that sleep has already finished. The mask is
then already there, `shown` stays below 3, and the assertion fails. A longer
sleep (the earlier 200 ms attempt) has the same race.

## What Changes

- Hold the test segmenter until the test has shown several frames, then
  release one result. The age assertion no longer depends on wall-clock sleep.

## Capabilities

- **New Capabilities:** none (`skip_specs: true`)
- **Modified Capabilities:** none

## Impact

- `crates/calling/src/blur.rs` test only
- Forgejo Test macOS job
