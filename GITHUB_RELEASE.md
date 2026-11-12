---
title: Releases (Forgejo + GitHub)
---

# Releases (Forgejo + GitHub)

**SoT für Code und Release-Binaries ist Forgejo** (`devops-geek/rusty-teams`). GitHub (`d0dg3r/rusty-teams`) bekommt denselben CHANGELOG-Body und dieselben Assets per API-Spiegel — kein zweiter Compile auf GitHub-hosted Runners.

## Remotes

| Remote | URL | Rolle |
|--------|-----|--------|
| `origin` | `https://forgejo.lan/devops-geek/rusty-teams` | SoT |
| `github` | `https://github.com/d0dg3r/rusty-teams` | Offsite-Spiegel |
| `upstream` | `https://github.com/danieldaeschle/rusty-teams` | Upstream-PRs |

## Was ein Tag `v*` baut

Workflow: [`.forgejo/workflows/release.yaml`](.forgejo/workflows/release.yaml).

| Plattform | Runner | Asset |
|-----------|--------|-------|
| Debian / Ubuntu | `ubuntu-latest` | `rusty-teams-<ver>-amd64.deb` |
| Fedora / RHEL | `ubuntu-latest` | `rusty-teams-<ver>-x86_64.rpm` |
| Arch | `ubuntu-latest` | `rusty-teams-<ver>-x86_64.pkg.tar.zst` |
| Flatpak | `ubuntu-latest` | `rusty-teams-<ver>-x86_64.flatpak` |
| Windows amd64 | `ci-runner-windows-01` | `rusty-teams-<ver>-windows-amd64.exe` |
| Windows ARM64 | `windows-arm64` | `rusty-teams-<ver>-windows-arm64.exe` |
| macOS universal | `macos-arm64` | `rusty-teams-<ver>-macos-universal.zip` |

Tags mit `-` (z. B. `v0.3.0-joe.1`) sind `prerelease`.

## Secrets (Forgejo-Repo)

| Secret | Zweck |
|--------|--------|
| `GH_MIRROR_TOKEN` | GitHub PAT mit `contents: write` auf `d0dg3r/rusty-teams` (Forgejo verbietet den Prefix `GITHUB_` in Secret-Namen). Die Workflows setzen daraus die Env `GITHUB_MIRROR_TOKEN` fürs Publish-Skript. |

Publish-Skript: [`scripts/ci_forgejo_publish_release.sh`](scripts/ci_forgejo_publish_release.sh).

## Vor dem Tag

1. `CHANGELOG.md`: Sektion `## [X.Y.Z] - YYYY-MM-DD` für die Version ohne führendes `v`.
2. Tag auf Forgejo pushen: `git tag v0.3.0-joe.1 && git push origin v0.3.0-joe.1`.
3. Forgejo Actions laufen lassen; GitHub-Release erscheint mit denselben Dateien.

## GitHub Actions

[`.github/workflows/build.yml`](.github/workflows/build.yml) baut **keine** Release-Binaries mehr (Notes-only / abgeschaltet). Tests können weiter unter `.github/workflows/test.yml` laufen.
