{ pkgs }:

pkgs.writeShellScriptBin "move-to-empty-workspace" ''
  # Move the active window to an empty workspace on the focused monitor only.
  # Never uses Hyprland's global "empty" keyword (that can jump monitors).
  set -euo pipefail

  JQ=${pkgs.jq}/bin/jq

  active_win=$(hyprctl activewindow -j)
  win_addr=$($JQ -r '.address // empty' <<< "$active_win")

  if [ -z "$win_addr" ] || [ "$win_addr" = "null" ]; then
    notify-send -t 3000 "Hyprland" "No focused window to move"
    exit 1
  fi

  monitors=$(hyprctl monitors -j)
  mon_id=$($JQ -r '.[] | select(.focused == true) | .id' <<< "$monitors")
  active_ws_id=$($JQ -r '.[] | select(.focused == true) | .activeWorkspace.id' <<< "$monitors")

  clients=$(hyprctl clients -j)
  workspaces=$(hyprctl workspaces -j)

  # Empty workspace on this monitor: count clients per workspace (not workspace.windows).
  target_ws=""
  while IFS= read -r ws_id; do
    [ -z "$ws_id" ] && continue
    count=$($JQ --argjson ws "$ws_id" --argjson mid "$mon_id" \
      '[.[] | select((.workspace.id // .workspace) == $ws and .monitor == $mid)] | length' <<< "$clients")
    if [ "$count" -eq 0 ] && [ "$ws_id" != "$active_ws_id" ]; then
      target_ws="$ws_id"
      break
    fi
  done < <($JQ -r --argjson mid "$mon_id" '.[] | select(.monitor == $mid) | .id' <<< "$workspaces")

  if [ -z "$target_ws" ]; then
    while IFS= read -r ws_id; do
      [ -z "$ws_id" ] && continue
      count=$($JQ --argjson ws "$ws_id" --argjson mid "$mon_id" \
        '[.[] | select((.workspace.id // .workspace) == $ws and .monitor == $mid)] | length' <<< "$clients")
      if [ "$count" -eq 0 ]; then
        target_ws="$ws_id"
        break
      fi
    done < <($JQ -r --argjson mid "$mon_id" '.[] | select(.monitor == $mid) | .id' <<< "$workspaces")
  fi

  if [ -z "$target_ws" ]; then
    # New workspace ID — created on the focused monitor when the window is moved there.
    target_ws=$($JQ '[.[].id] | max + 1' <<< "$workspaces")
  fi

  # Move the window first, then follow it. Switching workspace before moving leaves
  # the window behind because focus moves away from it.
  hyprctl dispatch focuswindow "address:$win_addr"
  hyprctl dispatch movetoworkspacesilent "$target_ws"
  hyprctl dispatch workspace "$target_ws"
''
