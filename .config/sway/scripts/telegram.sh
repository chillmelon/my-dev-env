#!/bin/sh
# telegram.sh summon <mako-id>
#   Open a Telegram notification and make sure the Telegram main window ends up on the
#   workspace you are on right now - also when the window was closed to the tray.
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

case "$1" in
summon)
    ws=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .name')
    makoctl invoke -n "$2"
    makoctl dismiss -n "$2" 2>/dev/null
    # Telegram (re)shows its window asynchronously; wait up to ~3s for it.
    i=0
    while ! main_exists && [ $i -lt 30 ]; do sleep 0.1; i=$((i + 1)); done
    sleep 0.2
    each "$NOT_VIEWER" "move container to workspace \"$ws\""
    swaymsg "workspace \"$ws\"" >/dev/null
    each "$NOT_VIEWER" "focus"
    ;;
esac
