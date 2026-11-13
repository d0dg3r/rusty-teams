# Spec Delta

## Purpose

Controls the language of the app chrome: derive from the OS locale on first launch, persist the user’s choice, and apply it to all product UI strings in English and German.

## ADDED Requirements

### Requirement: Supported UI languages

The app MUST offer exactly the UI languages English and German. German MUST use Germany orthography in visible product text.

#### Scenario: Language picker shows DE and EN

- **WHEN** the user opens the UI language setting
- **THEN** English and German are available
- **AND** no other UI language is selectable

### Requirement: First launch follows the OS locale

Without a saved UI language setting, the app MUST read the system locale: if the locale starts with `de`, the UI MUST be German; otherwise it MUST be English.

#### Scenario: System German

- **GIVEN** no saved UI language exists yet
- **WHEN** the app starts and the system locale starts with `de`
- **THEN** the app shows its chrome in German

#### Scenario: System not German

- **GIVEN** no saved UI language exists yet
- **WHEN** the app starts and the system locale does not start with `de`
- **THEN** the app shows its chrome in English

### Requirement: User choice overrides and persists

The user MUST be able to set the UI language to English or German in settings. The choice MUST be stored and MUST apply on later launches regardless of the then-current system locale.

#### Scenario: Explicitly save German

- **WHEN** the user sets the UI language to German
- **THEN** the app shows German
- **AND** after restart German stays active even if the system locale does not start with `de`

#### Scenario: Explicitly save English

- **WHEN** the user sets the UI language to English
- **THEN** the app shows English
- **AND** after restart English stays active even if the system locale starts with `de`

### Requirement: Switch without restart

When the user changes the UI language, the visible chrome MUST adopt the new language without quitting the app.

#### Scenario: Change in settings

- **WHEN** the user switches from English to German in a running session
- **THEN** navigation, settings, and dialogs appear in German
- **AND** the session stays open

### Requirement: All product UI is localized

All surface strings that originate from the app itself MUST appear in the active UI language. That includes navigation, settings, dialogs, menus, tooltips, shortcut labels, toasts, the tray menu, agent UI, and user-facing notices from calls and error paths.

#### Scenario: Settings and chrome

- **WHEN** the UI language is German
- **THEN** settings navigation, the rail, and common dialog actions (for example Cancel and Save) are in German

#### Scenario: Call notice

- **WHEN** the UI language is German and a locally produced call notice is shown
- **THEN** the notice text appears in German

#### Scenario: Tray

- **WHEN** the UI language is German and the user opens the tray menu
- **THEN** the menu entries are in German

### Requirement: Missing translation falls back to English

If a UI string has no translation in the active language, the app MUST show the English text instead of an empty label or a raw key.

#### Scenario: Missing key under German

- **WHEN** the UI language is German and a UI string has no German translation
- **THEN** the app shows the English text for that entry
- **AND** the other localized strings stay German

### Requirement: Foreign content stays unchanged

Server and user content MUST NOT be replaced by the UI locale. Message translation, captions spoken language, Adaptive Card titles from the server, and OS device names remain their own paths.

#### Scenario: Chat message

- **WHEN** the UI language is German and an English chat message is shown
- **THEN** the message body stays English
- **AND** the surrounding app controls are German

#### Scenario: Message translation unchanged

- **WHEN** the user uses message translation
- **THEN** the existing translation setting still applies
- **AND** the UI locale does not replace that setting
