# windows-background-blur Specification

## Purpose

Which background-blur model Windows uses when a GPU is present and the machine is on battery.

## Requirements

### Requirement: Battery keeps the small GPU blur model

On Windows, when a GPU blur device is available and the machine is on battery, background blur SHALL still offer the small GPU model and SHALL NOT offer the large GPU model. When the machine is on external power, both the small and the large GPU models SHALL be offered. Without a GPU, or without the blur runtime, battery SHALL NOT add a GPU model.

#### Scenario: On battery with a GPU

- **WHEN** background blur runs on Windows, a GPU device is available, and the machine is on battery
- **THEN** the small GPU model is available
- **AND** the large GPU model is not

#### Scenario: Plugged in with a GPU

- **WHEN** background blur runs on Windows, a GPU device is available, and the machine is on external power
- **THEN** both the small and the large GPU models are available

#### Scenario: On battery without a GPU

- **WHEN** the machine is on battery and no GPU blur device is available
- **THEN** blur does not add a GPU model
