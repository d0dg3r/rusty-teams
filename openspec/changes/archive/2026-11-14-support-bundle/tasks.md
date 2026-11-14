# Tasks

## 1. Support engine

- [x] 1.1 Add client snapshot helpers (version/build, OS, arch, session, locale, timezone, signed-in flag inputs) in `app-base` or adjacent module and verify unit tests for the English markdown block
- [x] 1.2 Implement `write_support_bundle` that creates `support-bundles/support-<utc>/` with `client.md`, scrubbed `diagnostics.log`, last 3 call-report `.md` files, and `README.md`; verify with a temp-dir test that secrets are scrubbed and store files are absent
- [x] 1.3 On diagnostics install, append a client snapshot line; install a panic hook that records the panic message; verify with unit or integration coverage where practical (`cargo test -p app-base --lib` and the crate that owns the bundle writer)

## 2. Help settings UI

- [x] 2.1 Add `SettingsSection::Help`, nav placement with About, and Help panel actions (create package + reveal, open GitHub issue URL, copy summary, open logs folder); verify compile and layout selectors if used
- [x] 2.2 Add DE/EN locale strings for Help in `crates/app-base/locales/app.yml` and verify `tr("settings.nav.help")` (and related keys) resolve in both locales

## 3. GitHub issue form

- [x] 3.1 Add `.github/ISSUE_TEMPLATE/bug_report.yml` for structured bug reports on the fork mirror and verify the file is valid YAML with the expected fields

## 4. Paths, ADR, docs tracking

- [x] 4.1 Extend OpenSpec spec/design with OS path layout and Help path display; validate with `openspec validate support-bundle`
- [x] 4.2 Remove `docs/*` ignore whitelist from `.gitignore` so `docs/` is fully tracked
- [x] 4.3 Add ADR 0012 and index row in `docs/decisions/README.md` (`status: proposed`)
- [x] 4.4 Centralize `local_data_dir` / diagnostics / support-bundles / call-reports path helpers; wire bundle + logs reveal; put absolute paths in `client.md` / issue body; unit-test layout names
- [x] 4.5 Help UI shows logs root and support-bundles root with copy; DE/EN locale keys; verify `tr` for new keys

## 5. Help path polish and bundle manager

- [x] 5.1 Extend OpenSpec for path Copy/Open and bundle list expand/delete; validate
- [x] 5.2 Add `list_support_bundles` / `list_bundle_files` / `delete_support_bundle` helpers with temp-dir tests
- [x] 5.3 Help Entity view: readable path rows with Copy|Open; bundle list expand/delete; DE/EN; mount in settings dialog
- [x] 5.4 `cargo test` + `openspec validate support-bundle` + `./scripts/install-linux-local.sh --restart`

## 6. Path copy icon and in-app file preview

- [x] 6.1 Path rows use `IconName::Copy` with path-only clipboard; Open still reveals folders
- [x] 6.2 File click opens in-app preview (`.md` rendered, `.log`/text mono); no file manager for files
- [x] 6.3 OpenSpec + DE/EN locales; validate; `./scripts/install-linux-local.sh --restart`

## 7. Debug toggle, rotation, richer bundles

- [x] 7.1 OpenSpec + ADR 0012: default-off toggle, ring rotation, crash/call JSON/timeline in bundle
- [x] 7.2 `diagnostics.rs` / `crash_log.rs`: AtomicBool gate, ring rotate, clear, own-crate logger
- [x] 7.3 Help + AppState: toggle, clear logs, `client.md` debug flag; DE/EN
- [x] 7.4 Signal hooks: notice, call start/end, store-ready snapshot, calendar id hygiene
- [x] 7.5 Bundle merges rotated logs + crash + call JSON + scrubbed timeline
- [x] 7.6 Tests + `openspec validate` + `./scripts/install-linux-local.sh --restart`

## Workflow follow-up

- Archive the change after merge when ready (`/opsx-archive`).
