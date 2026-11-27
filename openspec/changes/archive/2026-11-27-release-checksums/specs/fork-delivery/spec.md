# Spec Delta

## ADDED Requirements

### Requirement: Each release package has a SHA-256 sidecar

Every package file uploaded to a Forgejo release SHALL be accompanied by a sibling file named `<package>.sha256`. That file SHALL contain one line: the lowercase hex SHA-256 of the package, two spaces, and the package base name, so `sha256sum -c <package>.sha256` succeeds when the package is in the same directory. The GitHub mirror SHALL receive the same sidecar. A file whose name already ends in `.sha256` MUST NOT receive a further sidecar.

#### Scenario: Package and checksum are both on the release

- **WHEN** a release job publishes a package
- **THEN** the release also contains `<package>.sha256`
- **AND** checking that file with `sha256sum -c` succeeds for the package
- **AND** the GitHub mirror has the same sidecar

#### Scenario: A checksum is not checksummed again

- **WHEN** the publish list already contains a `.sha256` file
- **THEN** no `<name>.sha256.sha256` file is created
