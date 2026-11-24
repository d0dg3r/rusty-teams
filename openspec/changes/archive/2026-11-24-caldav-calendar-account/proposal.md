# Proposal

## Why

Linux users without a usable Outlook mailbox still need a writable calendar that can hold Teams join links. Google covers some of them; many others live on Nextcloud, Fastmail, mailbox.org, Posteo, iCloud, Synology, or Radicale — all speak CalDAV. Building Nextcloud only would leave the same work for every other host.

## What Changes

- Add a generic CalDAV calendar account: connect with server URL, username, and app password; list calendars; poll into the shared week/month grid; use as home calendar and write target.
- Expand recurring events client-side when the server does not expand them; resolve Teams join links from iCalendar fields the way Google already does from descriptions.
- Store the app password in the OS keyring; keep URL, username, and calendar list on device; redact credentials in diagnostics and support bundles.
- Generalise merge preference, load failures, reminders, and New meeting so non-Outlook homes (including CalDAV-only) mint a Teams join link before writing.
- Add read-only ICS subscriptions on the shared iCalendar core, including `webcal://` / `webcals://` normalisation to HTTPS.
- Harden review blockers: real OS keyring backends (not the mock store), unique `object_id` per series occurrence, EXDATE for occurrence delete, HTTP timeouts, and per-calendar fetch errors that do not drop sibling calendars.

## Capabilities

### New Capabilities

- (none)

### Modified Capabilities

- `calendar-accounts`: Connect CalDAV; show CalDAV calendars in the picker and grid; home and write targets; RSVP and delete for CalDAV-owned events (EXDATE for series occurrences); unique occurrence ids; local reminders; polling without push; read-only ICS subscriptions with webcal normalisation; load failures surface as banners including per-calendar failures and timeouts (never a silent empty week); MCP `create_meeting` remains Graph-only.

## Impact

- Store calendar accounts model, chatsvc calendar sources, week load, meeting create, RSVP/delete, settings UI (EN/DE with Swiss German orthography), Flatpak secrets portal note.
- New modules for iCalendar parsing/expansion and CalDAV HTTP (PROPFIND/REPORT/PUT).
- ADR 0019 for app-password CalDAV and keyring storage.
- Out of scope: Proton/Tuta bridges, CalDAV for Google, Digest auth, ignoring TLS, MCP home-calendar write.
