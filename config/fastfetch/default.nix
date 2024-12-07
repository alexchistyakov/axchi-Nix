{
  lib,
  config,
  ...
}:
let
  rice = import ../../rice { inherit lib config; };
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      display = rice.fastfetch.display;
      logo = {
        inherit (rice.fastfetch.logo) type height width padding;
        source = ../../rice/default/nix.png;
      };
      modules = rice.fastfetch.modules;
    };
  };
}
