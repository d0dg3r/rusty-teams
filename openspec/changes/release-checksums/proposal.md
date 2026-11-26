# Proposal

## Why

Release packages are uploaded with no checksum. A truncated download looks like a valid installer until it fails later, and there is nothing on the release to compare against.

## What Changes

- Each published package gets a sibling `<name>.sha256` file with one SHA-256 line in `sha256sum -c` form.
- The same sibling is mirrored to GitHub with the package.
- A checksum file does not get a checksum of its own.

## Capabilities

### New Capabilities

### Modified Capabilities

- `fork-delivery`: a Forgejo release asset is published together with its SHA-256 sidecar, and the GitHub mirror receives that sidecar too.

## Impact

- `scripts/ci_forgejo_publish_release.sh` and the release notes in `GITHUB_RELEASE.md`.
- No change to package contents. The tag that is already building does not gain these files.
