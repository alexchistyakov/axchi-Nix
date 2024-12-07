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
    settings = {
      display = rice.fastfetch.display;
      logo = rice.fastfetch.logo;
      modules = rice.fastfetch.modules;
    };
  };
}
