{ pkgs, lib, config, username, host, ... }:

let
  variables = import ../hosts/${host}/variables.nix;
  rice = import ../rice { inherit lib config username pkgs variables; };

  # Pull base16 hex colors from the active rice (via stylix) for use in
  # the subshell banner. Semantic mapping:
  #   base0D (blue)    — box edges
  #   base09 (orange)  — bright label
  #   base03 (comment) — dim detail text
  scheme = config.stylix.base16Scheme;
  bannerColors = {
    box = scheme.base0D;
    label = scheme.base09;
    dim = scheme.base03;
  };
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
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi

        # Skip the rest for non-interactive bash (scripts, `bash -c '...'`).
        case $- in *i*) ;; *) return ;; esac

        # Only launch fish for top-level interactive shells.
        # Subshells from nix-shell, nix develop, conda, etc. stay in bash so
        # their env vars and tooling resolve correctly.
        if [ -z "$IN_NIX_SHELL" ] \
           && [ -z "$NIX_BUILD_TOP" ] \
           && [ -z "$CONDA_DEFAULT_ENV" ] \
           && [ -z "$CONDA_PREFIX" ] \
           && [ "$SHLVL" = "1" ]; then
          fastfetch
          exec fish
        else
          # Subshell: precompute ANSI escape sequences from the active rice
          # so both the entry banner and the exit trap can use them.
          __axchios_fg() {
            local h=$1
            printf '\033[38;2;%d;%d;%dm' \
              "$((16#''${h:0:2}))" \
              "$((16#''${h:2:2}))" \
              "$((16#''${h:4:2}))"
          }
          AXCHIOS_C_BOX=$(__axchios_fg '${bannerColors.box}')
          AXCHIOS_C_LABEL=$(printf '\033[1m'; __axchios_fg '${bannerColors.label}')
          AXCHIOS_C_DIM=$(__axchios_fg '${bannerColors.dim}')
          AXCHIOS_C_OFF=$'\033[0m'
          unset -f __axchios_fg

          __axchios_subshell_kind() {
            local kind="" detail=""
            if [ -n "$IN_NIX_SHELL" ]; then
              kind="nix-shell · $IN_NIX_SHELL"
              [ -n "$name" ] && detail="$name"
            elif [ -n "$NIX_BUILD_TOP" ]; then
              kind="nix-build"
              detail="$NIX_BUILD_TOP"
            elif [ -n "$CONDA_DEFAULT_ENV" ]; then
              kind="conda"
              detail="$CONDA_DEFAULT_ENV"
              [ -n "$CONDA_PREFIX" ] && detail="$detail ($CONDA_PREFIX)"
            else
              kind="bash subshell"
              detail="SHLVL=$SHLVL · pid=$$"
            fi
            export AXCHIOS_SUBSHELL_KIND="$kind"
            export AXCHIOS_SUBSHELL_DETAIL="$detail"
          }
          __axchios_subshell_kind
          unset -f __axchios_subshell_kind

          # Entry banner — describes what was just opened.
          {
            printf '\n'
            printf '%s╭─ %s%s%s\n' \
              "$AXCHIOS_C_BOX" "$AXCHIOS_C_LABEL" "$AXCHIOS_SUBSHELL_KIND" "$AXCHIOS_C_OFF"
            [ -n "$AXCHIOS_SUBSHELL_DETAIL" ] && printf '%s│  %s%s%s\n' \
              "$AXCHIOS_C_BOX" "$AXCHIOS_C_DIM" "$AXCHIOS_SUBSHELL_DETAIL" "$AXCHIOS_C_OFF"
            printf '%s╰─%s\n\n' "$AXCHIOS_C_BOX" "$AXCHIOS_C_OFF"
          }

          # Exit banner — fires when the subshell terminates.
          # Outlined box in amber, matching the rice's label color.
          __axchios_subshell_exit() {
            printf '\n'
            printf '%s╭─%s\n' "$AXCHIOS_C_LABEL" "$AXCHIOS_C_OFF"
            printf '%s│  %sleft %s%s\n' \
              "$AXCHIOS_C_LABEL" "$AXCHIOS_C_LABEL" "$AXCHIOS_SUBSHELL_KIND" "$AXCHIOS_C_OFF"
            printf '%s╰─%s\n' "$AXCHIOS_C_LABEL" "$AXCHIOS_C_OFF"
          }
          trap __axchios_subshell_exit EXIT
        fi
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