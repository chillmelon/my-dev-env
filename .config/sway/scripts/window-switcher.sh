#!/usr/bin/env bash
# Super+Tab window switcher: list windows in recently-used order, pick with fuzzel.
# The current window goes last, so Super+Tab -> Enter jumps to the previous one.

mapfile -t rows < <(swaymsg -t get_tree | jq -r '
  def leaves($ws):
    (if .type == "workspace" then .name else $ws end) as $w
    | if ((.nodes + .floating_nodes) | length) == 0 then
        if .pid then {id, focused, ws: $w,
                      app: (.app_id // .window_properties.class // ""),
                      title: (.name // "")}
        else empty end
      else
        .focus[] as $f | (.nodes + .floating_nodes)[] | select(.id == $f) | leaves($w)
      end;
  [leaves("")] | map(select(.ws != "__i3_scratch"))
  | map(select(.focused | not)) + map(select(.focused))
  | .[] | [.id, .ws, .app, .title] | map(tostring | gsub("[\t\n]"; " ")) | join("\t")')

[ ${#rows[@]} -eq 0 ] && exit 0

# Window classes are not always icon names (e.g. JetBrains Snap applications).
# Prefer desktop-entry icons, with user entries taking precedence.
desktop_files=("${XDG_DATA_HOME:-$HOME/.local/share}"/applications/*.desktop)
IFS=: read -ra data_dirs <<<"${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
for dir in "${data_dirs[@]}" /var/lib/snapd/desktop; do
  desktop_files+=("$dir"/applications/*.desktop)
done

idx=$(for r in "${rows[@]}"; do
        IFS=$'\t' read -r id ws app title <<<"$r"
        icon=${app,,}
        if [[ -n $app ]]; then
          desktop_file=$(grep -ilFx -- "StartupWMClass=$app" "${desktop_files[@]}" 2>/dev/null | head -n 1)
          if [[ -n $desktop_file ]]; then
            desktop_icon=$(awk '/^Icon=/ {print substr($0, 6); exit}' "$desktop_file")
            [[ -n $desktop_icon ]] && icon=$desktop_icon
          fi
        fi
        printf '%s  %s\0icon\x1f%s\n' "$ws" "${title:-$app}" "$icon"
      done | fuzzel --dmenu --index --prompt "window ❯ ") || exit 0

# Guard: a non-numeric or negative idx would make ${rows[idx]} pick the wrong row.
[[ $idx =~ ^[0-9]+$ ]] && (( idx < ${#rows[@]} )) || exit 0
id=${rows[idx]%%$'\t'*}
[ -n "$id" ] && swaymsg "[con_id=$id] focus" >/dev/null
