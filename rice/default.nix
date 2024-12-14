{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  # The currently active rice theme
  activeRice = "kindleflame";
in
import ./${activeRice}/rice.nix { inherit lib config username pkgs; } 