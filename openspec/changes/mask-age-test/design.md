## Context

`the_mask_age_counts_the_frames_shown_since_its_source_frame` starts a worker
that records a frame, sleeps, then publishes a mask. The test counts
`refresh` calls during that sleep and requires `shown >= 3` and
`age() == shown`. The sleep is not a lower bound the test thread can rely on
when the runner is busy.

## Approach

The test segmenter waits on a permit. The test shows several frames while the
permit is held, then grants one. The worker can finish the first frame and
blocks again on the next, so the following refresh sees one mask and the age
matches the frames shown. A drop guard releases the wait so `MaskSource`'s
join cannot hang if an assertion fails.

No production path changes.

## Out of scope

- Background-blur behaviour, stride selection, or ONNX timing
- Retrying the macOS job without a code change
