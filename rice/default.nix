{
  lib,
  config,
  username,
  ...
}:
let
  # The currently active rice theme
  activeRice = "default";
in
import ./${activeRice} { inherit lib config username; } 