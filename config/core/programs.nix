{
  lib,
  username,
  config,
  pkgs,
  host,
  ...
}:
let
  variables = import ../../hosts/${host}/variables.nix;
  rice = import ../../rice { inherit lib config username pkgs variables; };
in
{
  programs = {
    starship = {
      enable = true;
      settings = rice.starship.settings;
    };
    obs-studio = {
      enable = false;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];
    };
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    fish.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
      ];
    };
  };
}
