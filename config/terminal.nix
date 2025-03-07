{ pkgs, lib, config, username, host, ... }:

let
  variables = import ../hosts/${host}/variables.nix;
  rice = import ../rice { inherit lib config username pkgs variables; };
in
{
  programs = {
    alacritty = {
      enable = true;
      package = pkgs.alacritty;
      settings = lib.mkForce rice.terminal.alacritty.settings // {
        window = {
          padding = {
            x = 4;
            y = 4;
          };
        };
        terminal = {
          osc52 = "CopyPaste";
        };
      };
    };

    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = lib.mkForce rice.terminal.kitty.settings;
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
      '';
    };

    starship = {
      enable = true;
      package = pkgs.starship;
    };

    bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        export TERM=alacritty-direct
        fastfetch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
        fish
      '';
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        # Vi mode
        fish_vi_key_bindings
        source (/etc/profiles/per-user/axchi/bin/starship init fish --print-full-init | psub)
      '';      
      shellAliases = {
        sv = "sudo nvim";
        fr = "nh os switch --hostname ${host} /home/${username}/axchios";
        fu = "nh os switch --hostname ${host} --update /home/${username}/axchios";
        ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        cat = "bat";
        ls = "eza --icons";
        ll = "eza -lh --icons --grid --group-directories-first";
        la = "eza -lah --icons --grid --group-directories-first";
        nd = "nix develop --show-trace";
        nixrepair = "sudo nix-store --verify --check-contents --repair";
        ".." = "cd ..";
      };
    };
  };
} 