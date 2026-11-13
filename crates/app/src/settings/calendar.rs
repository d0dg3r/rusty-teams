use gpui_kit::ClipboardItem;
use gpui_kit::component::v_flex;
use gpui_kit::*;
use store::{CalendarProvider, CalendarRef};

use super::rows::{caption, control_row, text_button, toggle_row};
use crate::app_state::AppState;
use crate::i18n::tr;
use crate::theme;

pub fn render(app: &Entity<AppState>, cx: &App) -> Div {
    let accounts = app.read(cx).calendar_accounts();
    let pending = app.read(cx).google_connect_pending().is_some();
    let mut body = v_flex()
        .w_full()
        .child(caption(tr("settings.calendar.section_google")))
        .child(connect_row(app, accounts.has_google(), pending));
    for account in &accounts.google_accounts {
        body = body.child(account_block(app, account, &accounts));
    }
    body = body
        .child(caption(tr("settings.calendar.section_home")))
        .child(home_choices(app, &accounts))
        .child(caption(tr("settings.calendar.section_write")));
    if accounts.home.provider != CalendarProvider::Outlook {
        let write_app = app.clone();
        let target = CalendarRef::outlook();
        let selected = accounts
            .write_targets
            .iter()
            .any(|existing| existing.key() == target.key());
        body = body.child(
            toggle_row(
                "settings-write-outlook",
                tr("settings.calendar.outlook_mailbox"),
                tr("settings.calendar.dual_write_when_google_home"),
                theme::text_muted(),
                selected,
            )
            .on_click(move |_, _, cx| {
                write_app.update(cx, |state, cx| {
                    state.toggle_write_target(target.clone(), cx)
                })
            }),
        );
    } else if accounts.google_accounts.is_empty() {
        body = body.child(control_row(
            tr("settings.calendar.no_extra_targets"),
            tr("settings.calendar.connect_then_dual_write"),
            div(),
        ));
    }
    body
}

fn connect_row(app: &Entity<AppState>, connected: bool, pending: bool) -> Div {
    let app = app.clone();
    if connected {
        control_row(
            tr("settings.calendar.google_title"),
            tr("settings.calendar.connected_detail"),
            div(),
        )
    } else if pending {
        let reopen = app.clone();
        let copy = app.clone();
        let cancel = app.clone();
        control_row(
            tr("settings.calendar.google_title"),
            tr("settings.calendar.finish_in_browser"),
            div()
                .flex()
                .gap_2()
                .child(
                    text_button(
                        "settings-google-reopen",
                        tr("settings.calendar.open_browser_again"),
                    )
                    .on_click(move |_, _, cx| {
                        reopen.update(cx, |state, cx| state.reopen_google_connect(cx))
                    }),
                )
                .child(
                    text_button("settings-google-copy", tr("settings.calendar.copy_link")).on_click(
                        move |_, _, cx| {
                            if let Some(url) = copy.read(cx).google_connect_pending().map(str::to_owned)
                            {
                                cx.write_to_clipboard(ClipboardItem::new_string(url));
                            }
                        },
                    ),
                )
                .child(
                    text_button("settings-google-cancel", tr("common.cancel")).on_click(
                        move |_, _, cx| {
                            cancel.update(cx, |state, cx| state.cancel_google_connect(cx))
                        },
                    ),
                ),
        )
    } else {
        let connect = app.clone();
        control_row(
            tr("settings.calendar.google_title"),
            tr("settings.calendar.connect_hint"),
            text_button(
                "settings-google-connect",
                tr("settings.calendar.connect_button"),
            )
            .on_click(move |_, _, cx| {
                connect.update(cx, |state, cx| state.connect_google_calendar(cx))
            }),
        )
    }
}

fn account_block(
    app: &Entity<AppState>,
    account: &store::GoogleAccount,
    accounts: &store::CalendarAccounts,
) -> Div {
    let disconnect_app = app.clone();
    let account_id = account.id.clone();
    let mut block = v_flex().w_full().child(control_row(
        account.email.clone(),
        tr("settings.calendar.google_account"),
        text_button(
            format!("settings-google-disconnect-{}", account.id),
            tr("settings.calendar.disconnect"),
        )
        .on_click(move |_, _, cx| {
            disconnect_app.update(cx, |state, cx| {
                state.disconnect_google_account(&account_id, cx)
            })
        }),
    ));
    for calendar in &account.calendars {
        let toggle_app = app.clone();
        let account_id = account.id.clone();
        let calendar_id = calendar.id.clone();
        let write_ref = CalendarRef::google(&account.id, &calendar.id);
        let is_home = accounts.home.key() == write_ref.key();
        let is_write = accounts
            .write_targets
            .iter()
            .any(|target| target.key() == write_ref.key());
        block = block.child(
            toggle_row(
                format!("settings-google-cal-{}", calendar.id),
                calendar.summary.clone(),
                if calendar.primary {
                    tr("settings.calendar.primary")
                } else {
                    tr("settings.calendar.show_in_grid")
                },
                theme::text_muted(),
                calendar.selected,
            )
            .on_click(move |_, _, cx| {
                toggle_app.update(cx, |state, cx| {
                    state.toggle_google_calendar_selected(&account_id, &calendar_id, cx)
                })
            }),
        );
        if !is_home {
            let write_app = app.clone();
            let target = write_ref;
            block = block.child(
                toggle_row(
                    format!("settings-google-write-{}", calendar.id),
                    tr_args_write(&calendar.summary),
                    "",
                    theme::text_muted(),
                    is_write,
                )
                .on_click(move |_, _, cx| {
                    write_app.update(cx, |state, cx| {
                        state.toggle_write_target(target.clone(), cx)
                    })
                }),
            );
        }
    }
    block
}

fn tr_args_write(summary: &str) -> String {
    let mut args = std::collections::HashMap::new();
    args.insert("name".to_owned(), summary.to_owned());
    crate::i18n::tr_args("settings.calendar.also_write_to", &args)
}

fn home_choices(app: &Entity<AppState>, accounts: &store::CalendarAccounts) -> Div {
    let mut choices = v_flex().w_full();
    let outlook_app = app.clone();
    let outlook_home = accounts.home.provider == CalendarProvider::Outlook;
    choices = choices.child(
        toggle_row(
            "settings-home-outlook",
            tr("settings.calendar.outlook_mailbox"),
            tr("settings.calendar.outlook_home_detail"),
            theme::text_muted(),
            outlook_home,
        )
        .on_click(move |_, _, cx| {
            outlook_app.update(cx, |state, cx| {
                state.set_home_calendar(CalendarRef::outlook(), cx)
            })
        }),
    );
    for account in &accounts.google_accounts {
        for calendar in &account.calendars {
            let home_app = app.clone();
            let target = CalendarRef::google(&account.id, &calendar.id);
            let selected = accounts.home.key() == target.key();
            choices = choices.child(
                toggle_row(
                    format!("settings-home-google-{}", calendar.id),
                    format!("{} · {}", tr("settings.calendar.google_label"), calendar.summary),
                    account.email.clone(),
                    theme::text_muted(),
                    selected,
                )
                .on_click(move |_, _, cx| {
                    home_app.update(cx, |state, cx| state.set_home_calendar(target.clone(), cx))
                }),
            );
        }
    }
    choices
}
