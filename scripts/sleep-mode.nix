{ pkgs }:

pkgs.writeShellScriptBin "sleep-mode" ''
  # Turn off display with grace period to ignore accidental mouse movements
  # Keep forcing display off for 3 seconds
  sleep 0.2
  hyprctl dispatch dpms off

  # Save current RGB profile before turning off
  mkdir -p ~/.config/OpenRGB
  ${pkgs.openrgb-with-all-plugins}/bin/openrgb --noautoconnect --save-profile ~/.config/OpenRGB/before-sleep.orp 2>/dev/null || true
  
  # Turn off all OpenRGB devices (pattern from NixOS wiki)
  NUM_DEVICES=$(${pkgs.openrgb-with-all-plugins}/bin/openrgb --noautoconnect --list-devices | grep -E '^[0-9]+: ' | wc -l)
  
  for i in $(seq 0 $(($NUM_DEVICES - 1))); do
    ${pkgs.openrgb-with-all-plugins}/bin/openrgb --noautoconnect --device $i --mode static --color 000000
  done
  

''
