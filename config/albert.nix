{ lib, config, pkgs, username, host, ... }:
# Albert launcher (https://albertlauncher.github.io/) writes its config to
# ~/.config/albert/config as a Qt-style INI file. Home-manager has no
# dedicated module, so we render the INI ourselves and link it into place.
#
# Functional bits (which plugins are on, browser profile path, etc.) live
# here. The visual/look-and-feel block comes from the active rice via
# `rice.albert.widgetsboxmodel`.
#
# Note: Albert writes back to this file when settings are changed via its
# GUI. Those changes will be reverted on the next `nixos-rebuild switch`.
# The Nix file is the source of truth.
let
  variables = import ../hosts/${host}/variables.nix;
  rice = import ../rice { inherit lib config username pkgs variables; };
  inherit (config.home) homeDirectory;
in
{
  xdg.configFile."albert/config".text = lib.generators.toINI { } {
    General = {
      showTray = true;
      telemetry = false;
    };

    # Plugins (functional, not rice-themed)
    applications.enabled = true;
    calculator_qalculate.enabled = true;
    chromium = {
      enabled = true;
      profile_path = "${homeDirectory}/.config/BraveSoftware/Brave-Browser/Default";
    };
    clipboard.enabled = false;
    docs.enabled = true;
    files = {
      enabled = true;
      paths = "@Invalid()";
    };

    # Frontend look & feel — driven by the active rice
    widgetsboxmodel = rice.albert.widgetsboxmodel;
  };
}
