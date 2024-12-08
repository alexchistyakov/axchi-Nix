{
  lib,
  username,
  host,
  config,
  pkgs,
  ...
}:

let
  inherit (import ../hosts/${host}/variables.nix)
    browser
    terminal
    extraMonitorSettings
    keyboardLayout
    ;
  rice = import ../rice { inherit lib config username pkgs; };
in
with lib;
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    extraConfig =
      let
        modifier = "SUPER";
      in
      concatStrings [
        ''
          env = NIXOS_OZONE_WL, 1
          env = NIXPKGS_ALLOW_UNFREE, 1
          env = XDG_CURRENT_DESKTOP, Hyprland
          env = XDG_SESSION_TYPE, wayland
          env = XDG_SESSION_DESKTOP, Hyprland
          env = GDK_BACKEND, wayland, x11
          env = CLUTTER_BACKEND, wayland
          env = QT_QPA_PLATFORM=wayland;xcb
          env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
          env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
          env = SDL_VIDEODRIVER, x11
          env = MOZ_ENABLE_WAYLAND, 1
          exec-once = dbus-update-activation-environment --systemd --all
          exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          exec-once = killall swww
          exec-once = killall -q waybar;sleep .5 && waybar
          exec-once = killall -q swaync;sleep .5 && swaync
          exec-once = nm-applet --indicator
          exec-once = lxqt-policykit-agent
          exec-once = albert &
          monitor=,preferred,auto,1
          ${extraMonitorSettings}

          general {
            gaps_in = ${toString rice.hyprland.general.gaps_in}
            gaps_out = ${toString rice.hyprland.general.gaps_out}
            border_size = ${toString rice.hyprland.general.border_size}
            layout = ${rice.hyprland.general.layout}
            resize_on_border = ${if rice.hyprland.general.resize_on_border then "true" else "false"}
            col.active_border = ${rice.hyprland.general.col.active_border}
            col.inactive_border = ${rice.hyprland.general.col.inactive_border}
          }

          input {
            kb_layout = ${keyboardLayout}
            kb_options = grp:alt_shift_toggle
            kb_options = caps:super
            follow_mouse = 1
            touchpad {
              natural_scroll = true
              disable_while_typing = true
              scroll_factor = 0.8
            }
            sensitivity = 0
            accel_profile = flat
          }

          decoration {
            rounding = ${toString rice.hyprland.decoration.rounding}
            blur {
              enabled = ${if rice.hyprland.decoration.blur.enabled then "true" else "false"}
              size = ${toString rice.hyprland.decoration.blur.size}
              passes = ${toString rice.hyprland.decoration.blur.passes}
              new_optimizations = ${if rice.hyprland.decoration.blur.new_optimizations then "on" else "off"}
              ignore_opacity = ${if rice.hyprland.decoration.blur.ignore_opacity then "true" else "false"}
              xray = ${if rice.hyprland.decoration.blur.xray then "true" else "false"}
            }
            active_opacity = ${toString rice.hyprland.decoration.active_opacity}
            inactive_opacity = ${toString rice.hyprland.decoration.inactive_opacity}
            fullscreen_opacity = ${toString rice.hyprland.decoration.fullscreen_opacity}

            shadow {
              enabled = ${if rice.hyprland.decoration.shadow.enabled then "true" else "false"}
              range = ${toString rice.hyprland.decoration.shadow.range}
              render_power = ${toString rice.hyprland.decoration.shadow.render_power}
              color = ${rice.hyprland.decoration.shadow.color}
            }
          }

          animations {
            enabled = ${if rice.hyprland.animations.enabled then "true" else "false"}
            ${concatStringsSep "\n            " (map (b: "bezier = ${b}") rice.hyprland.animations.bezier)}
            ${concatStringsSep "\n            " (map (a: "animation = ${a}") rice.hyprland.animations.animation)}
          }

          windowrule = noborder,^(wofi)$
          windowrule = center,^(wofi)$
          windowrule = center,^(steam)$
          windowrule = center,^(x0vnxserver)
          windowrule = float, nm-connection-editor|blueman-manager
          windowrule = float, swayimg|vlc|Viewnior|pavucontrol
          windowrule = float, nwg-look|qt5ct|mpv
          windowrule = float, zoom
          windowrulev2 = stayfocused, title:^()$,class:^(steam)$
          windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$
          windowrulev2 = opacity 0.9 0.7, class:^(google-chrome-stable)$
          windowrulev2 = opacity 0.85 0.7, class:^(thunar)$
          windowrulev2 = opacity 0.9 0.7, class:^(cursor)$
          windowrulev2 = opacity 1.0 0.9, class:^(neovide)$

          gestures {
            workspace_swipe = true
            workspace_swipe_fingers = 3
          }

          misc {
            initial_workspace_tracking = 0
            mouse_move_enables_dpms = true
            key_press_enables_dpms = false
            disable_splash_rendering = true
            disable_hyprland_logo = true
            render_ahead_of_time = true
            render_ahead_safezone = 60
          }

          # KEYBINDS
          bind = ${modifier},Return,exec,${terminal}
          bind = ${modifier},SPACE,exec,albert toggle
          bind = ${modifier}SHIFT,W,exec,web-search
          bind = ${modifier}ALT,W,exec,wallsetter
          bind = ${modifier}SHIFT,N,exec,swaync-client -rs
          bind = ${modifier},B,exec,${browser}
          bind = ${modifier},S,exec,screenshootin
          bind = ${modifier},D,exec,discord
          bind = ${modifier},O,exec,obs
          bind = ${modifier},C,exec,hyprpicker -a
          bind = ${modifier},G,exec,gimp
          bind = ${modifier}SHIFT,G,exec,godot4
          bind = ${modifier},E,exec,thunar
          bind = ${modifier},M,exec,spotify
          bind = ${modifier},V,exec,vncviewer
          bind = ${modifier},Q,killactive,
          bind = ${modifier},P,pseudo,
          bind = ${modifier}SHIFT,J,togglesplit,
          bind = ${modifier},F,fullscreen,
          bind = ${modifier}SHIFT,T,togglefloating,
          bind = ${modifier}SHIFT,C,exit,
          bind = ${modifier}SHIFT,left,movewindow,l
          bind = ${modifier}SHIFT,right,movewindow,r
          bind = ${modifier}SHIFT,up,movewindow,u
          bind = ${modifier}SHIFT,down,movewindow,d
          bind = ${modifier}SHIFT,h,movewindow,l
          bind = ${modifier}SHIFT,l,movewindow,r
          bind = ${modifier}SHIFT,k,movewindow,u
          bind = ${modifier}SHIFT,j,movewindow,d
          bind = ${modifier},left,movefocus,l
          bind = ${modifier},right,movefocus,r
          bind = ${modifier},up,movefocus,u
          bind = ${modifier},down,movefocus,d
          bind = ${modifier},h,movefocus,l
          bind = ${modifier},l,movefocus,r
          bind = ${modifier},k,movefocus,u
          bind = ${modifier},j,movefocus,d
          bind = ${modifier},1,workspace,1
          bind = ${modifier},2,workspace,2
          bind = ${modifier},3,workspace,3
          bind = ${modifier},4,workspace,4
          bind = ${modifier},5,workspace,5
          bind = ${modifier},6,workspace,6
          bind = ${modifier},7,workspace,7
          bind = ${modifier},8,workspace,8
          bind = ${modifier},9,workspace,9
          bind = ${modifier},0,workspace,10
          bind = ${modifier}SHIFT,SPACE,movetoworkspace,special
          bind = ${modifier}SHIFT,1,movetoworkspace,1
          bind = ${modifier}SHIFT,2,movetoworkspace,2
          bind = ${modifier}SHIFT,3,movetoworkspace,3
          bind = ${modifier}SHIFT,4,movetoworkspace,4
          bind = ${modifier}SHIFT,5,movetoworkspace,5
          bind = ${modifier}SHIFT,6,movetoworkspace,6
          bind = ${modifier}SHIFT,7,movetoworkspace,7
          bind = ${modifier}SHIFT,8,movetoworkspace,8
          bind = ${modifier}SHIFT,9,movetoworkspace,9
          bind = ${modifier}SHIFT,0,movetoworkspace,10
          bind = ${modifier}CONTROL,right,workspace,e+1
          bind = ${modifier}CONTROL,left,workspace,e-1
          bind = ${modifier},mouse_down,workspace,e+1
          bind = ${modifier},mouse_up,workspace,e-1
          bindm = ${modifier},mouse:272,movewindow
          bindm = ${modifier},mouse:273,resizewindow

          bind = ${modifier},TAB,workspace,m+1
          bind = ${modifier}SHIFT,Tab,workspace,m-1

          bind = ${modifier},N,workspace,empty
          
          bind = ALT,Tab,cyclenext
          bind = ALT,Tab,bringactivetotop
          bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          binde = ,XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          bind = ,XF86AudioPlay,exec,playerctl play-pause
          bind = ,XF86AudioPause,exec,playerctl play-pause
          bind = ,XF86AudioNext,exec,playerctl next
          bind = ,XF86AudioPrev,exec,playerctl previous
          bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
          bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
        ''
      ];
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = rice.hyprpaper.settings.preload;
      wallpaper = rice.hyprpaper.settings.wallpaper;
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = rice.hyprlock.settings.general.disable_loading_bar;
        grace = rice.hyprlock.settings.general.grace;
        hide_cursor = rice.hyprlock.settings.general.hide_cursor;
        no_fade_in = rice.hyprlock.settings.general.no_fade_in;
      };
      background = lib.mkForce [
        {
          path = rice.hyprlock.settings.background.path;
          blur_passes = rice.hyprlock.settings.background.blur_passes;
          blur_size = rice.hyprlock.settings.background.blur_size;
        }
      ];

      input-field = lib.mkForce [
        {
          size = rice.hyprlock.settings.input-field.size;
          position = rice.hyprlock.settings.input-field.position;
          monitor = rice.hyprlock.settings.input-field.monitor;
          dots_center = rice.hyprlock.settings.input-field.dots_center;
          fade_on_empty = rice.hyprlock.settings.input-field.fade_on_empty;
          font_color = rice.hyprlock.settings.input-field.font_color;
          inner_color = rice.hyprlock.settings.input-field.inner_color;
          outer_color = rice.hyprlock.settings.input-field.outer_color;
          outline_thickness = rice.hyprlock.settings.input-field.outline_thickness;
          placeholder_text = rice.hyprlock.settings.input-field.placeholder_text;
          shadow_passes = rice.hyprlock.settings.input-field.shadow_passes;
        }
      ];
    };
  };
}
