{
  lib,
  config,
  username,
  pkgs,
  host,
  ...
}:
let
  variables = import ../../hosts/${host}/variables.nix;
  rice = import ../../rice { inherit lib config username pkgs variables; };
in
{
  programs.fastfetch = {
    enable = true;
    settings = lib.mkForce rice.fastfetch.settings;
  };
}
