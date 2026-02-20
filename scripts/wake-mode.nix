{ pkgs }:

pkgs.writeShellScriptBin "wake-mode" ''
  # Turn display back on
  hyprctl dispatch dpms on
  
  # Restore RGB profile if it exists
  if [ -f ~/.config/OpenRGB/before-sleep.orp ]; then
    ${pkgs.openrgb-with-all-plugins}/bin/openrgb --noautoconnect --load-profile ~/.config/OpenRGB/before-sleep.orp 2>/dev/null || true
  fi
''

