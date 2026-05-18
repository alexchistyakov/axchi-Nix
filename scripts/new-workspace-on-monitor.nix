{ pkgs }:

pkgs.writeShellScriptBin "new-workspace-on-monitor" ''
  # Switch to a new workspace on the focused monitor (never reuse an empty one).
  set -euo pipefail

  JQ=${pkgs.jq}/bin/jq

  workspaces=$(hyprctl workspaces -j)
  target_ws=$($JQ '[.[].id] | max + 1' <<< "$workspaces")

  hyprctl dispatch workspace "$target_ws"
''
