{ pkgs }:

pkgs.writeShellScriptBin "scatter-app-windows" ''
  # Move every window of the focused app's class on the *current workspace*
  # to its own new empty workspace (same monitor). Ignores same app on other workspaces.
  set -euo pipefail

  JQ=${pkgs.jq}/bin/jq

  active=$(hyprctl activewindow -j)
  class=$($JQ -r '.class // empty' <<< "$active")

  if [ -z "$class" ] || [ "$class" = "null" ]; then
    notify-send -t 3000 "Hyprland" "No focused window"
    exit 1
  fi

  monitors=$(hyprctl monitors -j)
  mon_id=$($JQ -r '.[] | select(.focused == true) | .id' <<< "$monitors")
  active_ws_id=$($JQ -r '.[] | select(.focused == true) | .activeWorkspace.id' <<< "$monitors")

  mapfile -t addresses < <(
    $JQ -r --arg class "$class" --argjson mid "$mon_id" --argjson ws "$active_ws_id" '
      [.[] | select(.class == $class and .monitor == $mid and ((.workspace.id // .workspace) == $ws)) | .address]
      | .[]
    ' <<< "$(hyprctl clients -j)"
  )

  if [ "''${#addresses[@]}" -eq 0 ]; then
    notify-send -t 3000 "Hyprland" "No $class windows on this workspace"
    exit 1
  fi

  new_workspace_on_monitor() {
    local clients workspaces ws_id count
    clients=$(hyprctl clients -j)
    workspaces=$(hyprctl workspaces -j)

    while IFS= read -r candidate; do
      [ -z "$candidate" ] && continue
      count=$($JQ --argjson ws "$candidate" --argjson mid "$mon_id" \
        '[.[] | select((.workspace.id // .workspace) == $ws and .monitor == $mid)] | length' <<< "$clients")
      if [ "$count" -eq 0 ]; then
        echo "$candidate"
        return 0
      fi
    done < <($JQ -r --argjson mid "$mon_id" '.[] | select(.monitor == $mid) | .id' <<< "$workspaces")

    ws_id=$($JQ '[.[].id] | max + 1' <<< "$workspaces")
    echo "$ws_id"
  }

  for addr in "''${addresses[@]}"; do
    ws_id=$(new_workspace_on_monitor)
    hyprctl dispatch focuswindow "address:$addr"
    hyprctl dispatch movetoworkspacesilent "$ws_id"
  done

  hyprctl dispatch workspace "$ws_id"
  notify-send -t 2500 "Hyprland" "Scattered ''${#addresses[@]} $class window(s) from this workspace"
''
