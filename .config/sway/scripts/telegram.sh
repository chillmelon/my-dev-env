#!/bin/sh
# telegram.sh focus
#   swaync: run by the "telegram-focus" script (run-on: action) after swaync has already
#   invoked the notification's action; just switch to the Telegram main window.
# telegram.sh summon <mako-id>   (legacy, mako only)
#   Open a Telegram notification and switch to the workspace the Telegram main window is on.
#   Telegram re-maps its window on activation; the for_window rule in 50-rules.conf pins it to
#   workspace 3, and focusing it here switches to that workspace.
# Criteria cover both native Wayland (app_id) and XWayland (class); the non-matching one is a harmless no-op.
NOT_VIEWER='title="^(?!Media viewer$)"'

each() { # each <title-criterion> <command>
    swaymsg "[app_id=\"(?i)telegram\" $1] $2" >/dev/null 2>&1
    swaymsg "[class=\"(?i)telegram\" $1] $2" >/dev/null 2>&1
}

main_exists() {
    swaymsg -t get_tree | jq -e '[.. | objects
        | select((.window_properties.class // .app_id // "") | test("telegram"; "i"))
        | select(.name != "Media viewer")] | length > 0' >/dev/null
}

focus_main() {
    # Telegram (re)shows its window asynchronously; wait up to ~3s for it.
    i=0
    while ! main_exists && [ $i -lt 30 ]; do sleep 0.1; i=$((i + 1)); done
    sleep 0.2
    each "$NOT_VIEWER" "focus"
}

case "$1" in
focus)
    focus_main
    ;;
summon)
    makoctl invoke -n "$2"
    makoctl dismiss -n "$2" 2>/dev/null
    focus_main
    ;;
esac
# swaync reports a non-zero exit as a failure notification; a non-matching criterion is not one.
exit 0
