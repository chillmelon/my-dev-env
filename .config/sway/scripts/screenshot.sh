#!/bin/sh
# Usage: screenshot.sh full|output|area|edit|menu|delay N|record-area|record-output|record-stop
#   full           全部螢幕 → 存檔 + 剪貼簿
#   output         目前所在螢幕 → 存檔 + 剪貼簿
#   area / edit    flameshot gui：定格 → 拖曳框選 + 直接標註；Enter 確認 → 存檔 + 剪貼簿，Esc 取消
#   menu           fuzzel 選單（類似 macOS ⌘⇧5）：延遲截圖、錄影；錄影中只顯示「停止錄影」
#   delay N        N 秒後開 flameshot gui（給定格也拍不到的原生 <select> 用）
#   record-area    框選範圍錄影 → ~/Videos/Screencasts/*.mp4（無聲音）
#   record-output  目前螢幕錄影
#   record-stop    停止錄影
#
# 截圖全部交給 flameshot（設定 ~/.config/flameshot/flameshot.ini，useGrimAdapter=true）。
# 一律用 -r 把 PNG 輸出到 stdout，存檔 / wl-copy / 通知都由本腳本統一處理；
# 錄影仍用 wf-recorder（flameshot 不會錄影）。
set -eu

pics="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")/Screenshots"
vids="$(xdg-user-dir VIDEOS 2>/dev/null || echo "$HOME/Videos")/Screencasts"
stamp="$(date +%F_%H-%M-%S)"
file="$pics/$stamp.png"
mkdir -p "$pics"

focused_output() {
    swaymsg -t get_outputs | jq -r '.[] | select(.focused).name'
}

# flameshot screen -n 的編號 = sway 啟用中螢幕的順序（實測 0=HDMI-A-1, 1=DVI-D-1）
focused_screen_index() {
    swaymsg -t get_outputs | jq -r '[.[] | select(.active)] | map(.focused) | index(true)'
}

# flameshot gui 的覆蓋視窗橫跨兩個螢幕，中心點落在右邊螢幕，sway 會把它（和焦點）
# 搬到那邊的 workspace，預設的 mouse_warping 就把游標拉過去。
# 所以 gui 期間關掉 mouse_warping，結束後把焦點還給原本的視窗/workspace。
# （config 沒設定 mouse_warping，還原成預設值 output）
keep_focus() {
    prev="$(swaymsg -t get_tree | jq -r '.. | objects | select(.focused == true) |
        if .type == "workspace" then "workspace --no-auto-back-and-forth \"\(.name)\"" else "[con_id=\(.id)] focus" end')"
    swaymsg -q mouse_warping none
    trap 'swaymsg -q "$prev"; swaymsg -q mouse_warping output' EXIT
}

# flameshot <args> → $file；取消（沒輸出）就刪掉空檔並結束
shoot() {
    flameshot "$@" -r > "$file" 2>/dev/null || true
    [ -s "$file" ] || { rm -f "$file"; exit 0; }
}

record() {
    mkdir -p "$vids"
    out="$vids/$stamp.mp4"
    notify-send "錄影中" "\$mod+Shift+d → 停止錄影"
    wf-recorder "$@" -f "$out" >/dev/null 2>&1 || true   # 收到 SIGINT 時會正常收尾後結束
    if [ -s "$out" ]; then
        notify-send "錄影已存檔" "$out"
    else
        notify-send "錄影失敗" "沒有產生檔案"
    fi
}

case "${1:-area}" in
    full)
        shoot full
        ;;
    output)
        shoot screen -n "$(focused_screen_index)"
        ;;
    delay)
        n="${2:-3}"
        notify-send -t $((n * 1000)) "截圖" "$n 秒後開始框選"
        keep_focus
        shoot gui -d $((n * 1000))
        ;;
    area|edit)
        keep_focus
        shoot gui
        ;;
    record-area)
        geom="$(slurp -f '%x %y %w %h')" || exit 0
        set -- $geom
        # libx264 需要偶數寬高
        record -g "$1,$2 $(($3 / 2 * 2))x$(($4 / 2 * 2))"
        exit 0
        ;;
    record-output)
        record -o "$(focused_output)"
        exit 0
        ;;
    record-stop)
        pkill -INT -x wf-recorder || true
        exit 0
        ;;
    menu)
        self="$0"
        if pgrep -x wf-recorder >/dev/null; then
            choice="$(printf '停止錄影\n' | fuzzel --dmenu --prompt '錄影> ')" || exit 0
        else
            choice="$(printf '%s\n' '3 秒後截圖' '10 秒後截圖' '錄影（框選範圍）' '錄影（目前螢幕）' |
                fuzzel --dmenu --prompt '截圖> ')" || exit 0
        fi
        case "$choice" in
            '3 秒後截圖')       exec "$self" delay 3 ;;
            '10 秒後截圖')      exec "$self" delay 10 ;;
            '錄影（框選範圍）') exec "$self" record-area ;;
            '錄影（目前螢幕）') exec "$self" record-output ;;
            '停止錄影')         exec "$self" record-stop ;;
        esac
        exit 0
        ;;
    *)
        echo "usage: $0 full|output|area|edit|menu|delay N|record-area|record-output|record-stop" >&2
        exit 2
        ;;
esac

wl-copy --type image/png < "$file"
notify-send -i "$file" "截圖已複製" "$file"
