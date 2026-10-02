#!/usr/bin/env bash
# Power menu (fuzzel). Used by the waybar power button (custom/power).
# First entry is the harmless one (lock), so a stray Enter can't shut anything down.
# Esc cancels.

# Nerd Font icons (Material Design): lock, logout, sleep, restart, power
entries=(
    $'\U000F033E  鎖定'
    $'\U000F0343  登出'
    $'\U000F04B2  休眠'
    $'\U000F0709  重新開機'
    $'\U000F0425  關機'
)

idx=$(printf '%s\n' "${entries[@]}" |
    fuzzel --dmenu --index --prompt 'power ❯ ' --lines ${#entries[@]} --width 18) || exit 0

case "$idx" in
    0) swaylock -f ;;          # colors from ~/.config/swaylock/config
    1) swaymsg exit ;;
    2) systemctl suspend ;;    # swayidle locks before sleep
    3) systemctl reboot ;;
    4) systemctl poweroff ;;
esac
