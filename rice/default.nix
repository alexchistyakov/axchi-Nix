{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  # The currently active rice theme
  activeRice = "arctic";
in
import ./${activeRice} { inherit lib config username pkgs; } 