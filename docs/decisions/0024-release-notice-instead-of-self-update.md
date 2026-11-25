---
status: rejected
date: 2026-11-24
---

# ADR 0024: A new release is a notice, not a new binary

Rejected 2026-11-25. Upstream #86 and the follow-up on this fork keep self-update where the install owns the binary (ADR 0014). This proposal is not in effect.

## Context

ADR 0014 lets the installed Linux binary download a GitHub release and swap itself, and Windows does the same without asking once the window is idle. Replacing the running executable fights file locks, the database, and the single-instance lock. The Linux menu install from that ADR still stands.

## Decision

A build that carries a release tag looks up newer releases of this product line (`d0dg3r/rusty-teams`, the public mirror of Forgejo) and shows one dialog. The primary action opens that release's page in the browser. The app does not download a file, does not replace its executable, and does not restart to finish an update. Not now hides that version until the next start. Settings has one switch, `updates.enabled`, on by default, on Windows, Linux, and macOS, plus Check now. Dev builds with no release tag stay quiet. Flatpak does not check and does not show the switch. The Linux install into `~/.local/share/rusty-teams` is unchanged.

## Consequences

- Users install the new build themselves from the release page.
- Releases no longer need a bare binary sitting next to the running executable for the app to update.
- A Linux user who had turned updates off under the old Linux-only key sees the check on again.
- ADR 0014's install half remains; its self-update half does not.
