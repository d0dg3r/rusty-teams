## 1. Record

- [x] 1.1 Sample a captured desktop frame and log its size and blank percent on the first frame and whenever that blank state changes.
- [x] 1.2 When the share sender is switched off because the capture ended, record the reason on the call timeline (`quiet` when there is no notice).

## 2. Verify

- [x] 2.1 A unit test covers an all-zero buffer as blank and a buffer with a non-zero sample as not blank.
- [x] 2.2 `cargo test -p calling --lib screen::tests` passes.
