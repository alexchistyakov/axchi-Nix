{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  rice = import ../../rice { inherit lib config username pkgs; };
in
{
  programs.fastfetch = {
    enable = true;
    settings = lib.mkForce rice.fastfetch.settings;
  };
}
