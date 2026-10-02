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

idx=$(for r in "${rows[@]}"; do
        IFS=$'\t' read -r id ws app title <<<"$r"
        printf '%s  %s\0icon\x1f%s\n' "$ws" "${title:-$app}" "${app,,}"
      done | fuzzel --dmenu --index --prompt "window ❯ ") || exit 0

# Guard: a non-numeric or negative idx would make ${rows[idx]} pick the wrong row.
[[ $idx =~ ^[0-9]+$ ]] && (( idx < ${#rows[@]} )) || exit 0
id=${rows[idx]%%$'\t'*}
[ -n "$id" ] && swaymsg "[con_id=$id] focus" >/dev/null
