# linux-desktop-notifications Specification

## Purpose
Shows chat, call, meeting, and agent alerts on Linux through the desktop notification service so users see and act on them when the main window is in the background.

## Requirements

### Requirement: Message toast on Linux

When a chat message would show a desktop toast under the existing notification rules, Linux MUST show a desktop notification with the same title and body the Windows card would use. Preview off MUST hide message content. A later message in the same chat MUST replace the previous notification for that chat.

#### Scenario: New direct message
- **WHEN** a direct message arrives and the notification rules allow a toast
- **THEN** a desktop notification appears with the sender name and preview text

#### Scenario: Preview disabled
- **WHEN** the account setting hides message preview and a toast is shown
- **THEN** the notification body does not include the message text

#### Scenario: Bundled follow-up replaces
- **WHEN** another message arrives in a chat that already has a visible toast
- **THEN** that chat keeps a single notification updated to the latest message

### Requirement: Message toast actions

A message notification MUST open the chat at that message when activated. It MUST offer Mark as read. It MUST offer Reply: when the desktop supports inline reply, sending that reply MUST send the message; otherwise Reply MUST open the chat.

#### Scenario: Activate opens chat
- **WHEN** the user activates a message notification
- **THEN** the main window comes to the front at that conversation and message

#### Scenario: Mark as read
- **WHEN** the user chooses Mark as read on a message notification
- **THEN** the conversation is marked read and the notification is closed

#### Scenario: Inline reply when supported
- **WHEN** the desktop advertises inline reply and the user sends a reply from the notification
- **THEN** the reply is sent to that chat as from the toast Reply path

### Requirement: Incoming call notification

An incoming ring MUST show a desktop notification that stays until the ring ends or the user acts. It MUST offer Decline and an audio accept action. When the ring is video, it MUST also offer Video accept.

#### Scenario: Audio ring
- **WHEN** an audio call rings and the main window is not handling it in the foreground
- **THEN** a notification shows Decline and Accept (or Audio) and does not time out on its own

#### Scenario: Video ring
- **WHEN** a video call rings
- **THEN** the notification also offers Video

#### Scenario: Decline closes
- **WHEN** the user chooses Decline
- **THEN** the ring is declined and the notification is closed

### Requirement: Meeting reminder notification

A meeting start reminder MUST show Join. In the Soon phase it MUST also offer Snooze. Dismissing the notification MUST dismiss the reminder. Phase changes for the same meeting MUST replace the same notification.

#### Scenario: Soon phase
- **WHEN** a meeting enters the Soon reminder phase
- **THEN** the notification offers Snooze and Join

#### Scenario: Started or Live
- **WHEN** the same meeting moves to Started or Live
- **THEN** the existing notification is replaced and still offers Join

### Requirement: App sound, no shell sound

The app MUST continue to play its notification and ring tones under the existing sound rules. Desktop notifications MUST request that the shell not play its own sound for those alerts.

#### Scenario: Message with sound on
- **WHEN** a toast is shown and notification sound is enabled
- **THEN** the app plays its notification tone and the desktop notification asks the shell to stay silent

### Requirement: Desktop Do not disturb

When the desktop notification service reports that notifications are inhibited, Linux MUST treat that as system quiet the same way Windows treats Focus Assist, so ordinary toasts are suppressed.

#### Scenario: Desktop inhibited
- **WHEN** the notification service reports inhibited and a non-urgent message arrives
- **THEN** no desktop notification is shown for that message

### Requirement: Missing notification service

When no desktop notification service is available, the app MUST NOT open a broken popup window. Sounds MUST still follow the existing rules. The failure MUST be logged at most once per session.

#### Scenario: No daemon
- **WHEN** the session has no Notifications service and a toast would otherwise show
- **THEN** no extra window appears, the sound still plays when allowed, and a single log line records the missing service

### Requirement: Windows and macOS unchanged

Windows MUST keep the existing GPUI toast cards. macOS MUST keep its current stub behaviour for this change.

#### Scenario: Windows path
- **WHEN** a toast is shown on Windows
- **THEN** the existing GPUI corner card is used

### Requirement: Meeting reminder card floats on Linux

On Linux a meeting reminder MUST open the meeting card as a floating window, including when a desktop notification service is connected. The desktop notification MUST still be published. The card MUST use the same floating window kind as the incoming-call card. Chat message toasts MUST NOT open a card while that service is connected.

#### Scenario: Reminder with a notification service

- **WHEN** a meeting reminder is due on Linux and a desktop notification service is connected
- **THEN** the meeting card opens as a floating window
- **AND** the desktop notification is still published

#### Scenario: Chat toast stays a notification

- **WHEN** a chat message toast is due and a desktop notification service is connected
- **THEN** no chat card window is opened

### Requirement: Incoming ring shows the in-app ring card

When a desktop notification service is connected, an incoming ring MUST still open the in-app ring card. The card MUST show the caller and MUST offer decline and audio accept. When the ring is video, the card MUST also offer video accept. The desktop notification for that ring MUST still be published. The card MUST close when the ring ends.

#### Scenario: Ring while a notification service is connected

- **WHEN** an incoming call rings and a desktop notification service is connected
- **THEN** the in-app ring card is visible and the desktop notification for that ring is also shown

#### Scenario: Video ring offers video on the card

- **WHEN** the incoming ring is a video call
- **THEN** the ring card offers video accept as well as decline and audio accept

#### Scenario: Ring ends

- **WHEN** the ring is accepted, declined, or otherwise ends
- **THEN** the ring card closes

### Requirement: Chat toasts stay notifications

Chat toasts MUST stay desktop notifications and MUST NOT open an in-app window. Meeting reminder cards are specified separately and MAY open while the service is connected.

#### Scenario: Chat toast stays a notification

- **WHEN** a chat message toast is due and a desktop notification service is connected
- **THEN** the message is a desktop notification and no in-app toast window opens

### Requirement: Ring card actions answer the same ring

Decline, audio accept, and video accept on the ring card MUST act on the same ring as the matching desktop notification actions. Audio accept MUST answer without sending camera. Video accept MUST answer with the camera.

#### Scenario: Audio accept on the card

- **WHEN** the user accepts audio on the ring card
- **THEN** the call is answered without sending the camera and the desktop notification for that ring closes

#### Scenario: Decline on the card

- **WHEN** the user declines on the ring card
- **THEN** the ring is declined and the desktop notification for that ring closes
