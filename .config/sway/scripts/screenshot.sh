#!/bin/sh
# Usage: screenshot.sh full|output|area|edit
#   full    全部螢幕 → 存檔 + 剪貼簿
#   output  目前所在螢幕 → 存檔 + 剪貼簿
#   area    框選 → 存檔 + 剪貼簿
#   edit    框選 → satty 標註（Enter 複製+存檔+關閉，Esc 放棄；設定在 ~/.config/satty/config.toml）
set -eu

dir="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")/Screenshots"
mkdir -p "$dir"
file="$dir/$(date +%F_%H-%M-%S).png"

case "${1:-area}" in
    full)
        grim "$file"
        ;;
    output)
        out="$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).name')"
        grim -o "$out" "$file"
        ;;
    area)
        geom="$(slurp)" || exit 0   # Esc 取消就安靜結束
        grim -g "$geom" "$file"
        ;;
    edit)
        # satty 是從 GitHub release 裝到 ~/.local/bin（sway 的 PATH 沒有這個目錄）
        satty="$HOME/.local/bin/satty"
        command -v satty >/dev/null && satty=satty
        if ! command -v "$satty" >/dev/null; then
            notify-send "截圖" "找不到 satty：https://github.com/Satty-org/Satty/releases"
            exit 1
        fi
        geom="$(slurp)" || exit 0
        grim -g "$geom" - | "$satty" --filename - --output-filename "$file"
        exit 0
        ;;
    *)
        echo "usage: $0 full|output|area|edit" >&2
        exit 2
        ;;
esac

wl-copy --type image/png < "$file"
notify-send -i "$file" "截圖已複製" "$file"
