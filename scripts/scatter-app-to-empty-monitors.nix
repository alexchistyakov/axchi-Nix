{ pkgs }:

pkgs.writeShellScriptBin "scatter-app-to-empty-monitors" ''
  # Move every window of the focused app's class on the *current workspace*
  # to a distinct empty monitor (uses each monitor's active workspace).
  # Never creates new workspaces.
  set -euo pipefail

  JQ=${pkgs.jq}/bin/jq

  active=$(hyprctl activewindow -j)
  class=$($JQ -r '.class // empty' <<< "$active")

  if [ -z "$class" ] || [ "$class" = "null" ]; then
    notify-send -t 3000 "Hyprland" "No focused window"
    exit 1
  fi

  monitors=$(hyprctl monitors -j)
  clients=$(hyprctl clients -j)
  mon_id=$($JQ -r '.[] | select(.focused == true) | .id' <<< "$monitors")
  active_ws_id=$($JQ -r '.[] | select(.focused == true) | .activeWorkspace.id' <<< "$monitors")

  mapfile -t addresses < <(
    $JQ -r --arg class "$class" --argjson mid "$mon_id" --argjson ws "$active_ws_id" '
      [.[] | select(.class == $class and .monitor == $mid and ((.workspace.id // .workspace) == $ws)) | .address]
      | .[]
    ' <<< "$clients"
  )

  if [ "''${#addresses[@]}" -eq 0 ]; then
    notify-send -t 3000 "Hyprland" "No $class windows on this workspace"
    exit 1
  fi

  mapfile -t target_workspaces < <(
    $JQ -r --argjson clients "$clients" '
      . as $mons |
      [$mons[] |
        select(
          ([$clients[] | select(.monitor == .id)] | length) == 0
        ) |
        .activeWorkspace.id
      ] | .[]
    ' <<< "$monitors"
  )

  if [ "''${#target_workspaces[@]}" -eq 0 ]; then
    notify-send -t 3000 "Hyprland" "No empty monitors available"
    exit 1
  fi

  moved=0
  for i in "''${!addresses[@]}"; do
    if [ "$i" -ge "''${#target_workspaces[@]}" ]; then
      break
    fi
    addr="''${addresses[$i]}"
    ws="''${target_workspaces[$i]}"
    hyprctl dispatch focuswindow "address:$addr"
    hyprctl dispatch movetoworkspacesilent "$ws"
    moved=$((moved + 1))
  done

  last_ws="''${target_workspaces[$((moved - 1))]}"
  hyprctl dispatch workspace "$last_ws"

  leftover=$(( ''${#addresses[@]} - moved ))
  if [ "$leftover" -gt 0 ]; then
    notify-send -t 3000 "Hyprland" \
      "Moved $moved $class window(s) to empty monitors ($leftover left on this workspace)"
  else
    notify-send -t 2500 "Hyprland" \
      "Moved $moved $class window(s) to empty monitors"
  fi
''
