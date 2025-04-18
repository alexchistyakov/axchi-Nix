{
  lib,
  config,
  username,
  pkgs,
  variables,
  ...
}:
let
  # The currently active rice theme
  activeRice = "kindleflame";
in
import ./${activeRice}/rice.nix { inherit lib config username pkgs variables; } 
