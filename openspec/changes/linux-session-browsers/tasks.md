## 1. Discovery

- [x] 1.1 Add Edge, Brave, Helium, and Vivaldi executable names to the Linux Chromium search list, after Chrome and Chromium.
- [x] 1.2 Map `microsoft-edge.desktop` and `brave-browser.desktop` onto the installed executable, and list one row when two names are the same file.

## 2. Process stop

- [x] 2.1 Treat a process image named `microsoft-edge` as a managed Chromium browser.

## 3. Verify

- [x] 3.1 `cargo test -p browser --lib sign_in_choice` and `cargo test -p browser --lib process` pass, including the Edge and Brave desktop-entry cases.
