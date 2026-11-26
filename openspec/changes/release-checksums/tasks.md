# Tasks

- [x] 1. Write a `<package>.sha256` sidecar in `scripts/ci_forgejo_publish_release.sh` and upload it with the package, including the GitHub mirror.
- [x] 2. Note the sidecar in `GITHUB_RELEASE.md`.
- [x] 3. Check a fixture: the line matches `sha256sum -c`, and a `.sha256` input does not grow another suffix.
