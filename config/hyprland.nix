{
  lib,
  username,
  host,
  config,
  ...
}:

let
  inherit (import ../hosts/${host}/variables.nix)
    browser
    terminal
    extraMonitorSettings
    keyboardLayout
    ;
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
            gaps_in = 6
            gaps_out = 8
            border_size = 0
            layout = dwindle
            resize_on_border = true
            col.active_border = rgb(${config.stylix.base16Scheme.base08}) rgb(${config.stylix.base16Scheme.base0C}) 45deg
            col.inactive_border = rgb(${config.stylix.base16Scheme.base01})
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
            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            accel_profile = flat
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
          
          animations {
              enabled = true
              bezier = linear, 0, 0, 1, 1
              bezier = md3_standard, 0.2, 0, 0, 1
              bezier = md3_decel, 0.05, 0.7, 0.1, 1
              bezier = md3_accel, 0.3, 0, 0.8, 0.15
              bezier = overshot, 0.05, 0.9, 0.1, 1.1
              bezier = crazyshot, 0.1, 1.5, 0.76, 0.92 
              bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
              bezier = fluent_decel, 0.1, 1, 0, 1
              bezier = easeInOutCirc, 0.85, 0, 0.15, 1
              bezier = easeOutCirc, 0, 0.55, 0.45, 1
              bezier = easeOutExpo, 0.16, 1, 0.3, 1
              # animation = windows, 1, 3, md3_decel, popin 60%
              animation = border, 1, 10, default
              #animation = fade, 1, 2.5, md3_decel
              
              # Define custom bezier curves for smoother animations
              bezier = myBezier, 0.05, 0.9, 0.1, 1.00
              bezier = linear, 0.0, 0.0, 1.0, 1.0
              bezier = easeInOutQuint, 0.83, 0, 0.17, 1
              bezier = easeOutQuint, 0.22, 1, 0.36, 1
              bezier = easeInOutCirc, 0.85, 0, 0.15, 1
              bezier = wind, 0, 0.5, 0.5, 1.0	
              bezier = winIn, 0.1, 1.1, 0.1, 1.1
              bezier = winOut, 0.3, -0.3, 0, 1
              
              animation = windows, 1, 3.5, wind, slide
              animation = windowsIn, 1, 6, winIn, slide
              animation = windowsOut, 1, 5, winOut, slide
              animation = windowsMove, 1, 2, wind, slide
              
              bezier = easeInOutQuint, 0.83, 0, 0.17, 1
              bezier = easeOutQuint, 0.22, 1, 0.36, 1
              bezier = easeInOutCirc, 0.85, 0, 0.15, 1
              
              # Fade animations
              animation = fade, 1, 10, easeOutQuint
              animation = fadeDim, 1, 10, easeOutQuint
              animation = fadeSwitch, 1, 10, easeOutQuint
              animation = fadeShadow, 1, 10, easeOutQuint

              animation = workspaces, 1, 7, easeOutExpo, slide
              animation = specialWorkspace, 1, 3, md3_decel, slidevert
          }

          decoration {
            rounding = 15
            blur {
                enabled = true
                size = 8
                passes = 2
                new_optimizations = on
                ignore_opacity = true
                xray = true
            }
            active_opacity = 0.95
            inactive_opacity = 0.88
              fullscreen_opacity = 1.0

            shadow {
                enabled = true
                range = 30
                render_power = 3
                color = 0x66000000
            }

          }

          plugin {
            hyprtrails {
            }
          }

          dwindle {
            pseudotile = true
            preserve_split = true
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
          bind = ${modifier}SHIFT,F,togglefloating,
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
          bind = ${modifier},mouse_down,workspace, e+1
          bind = ${modifier},mouse_up,workspace, e-1
          bindm = ${modifier},mouse:272,movewindow
          bindm = ${modifier},mouse:273,resizewindow

          bind = ${modifier},TAB,workspace,m+1 # Open next workspace
          bind = ${modifier}SHIFT,Tab,workspace, m-1 # Open previous workspace

          bind = ${modifier},N,workspace,empty # Open previous workspace
          
          bind = ALT,Tab,cyclenext
          bind = ALT,Tab,bringactivetotop
          bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          bind = ,XF86AudioPlay, exec, playerctl play-pause
          bind = ,XF86AudioPause, exec, playerctl play-pause
          bind = ,XF86AudioNext, exec, playerctl next
          bind = ,XF86AudioPrev, exec, playerctl previous
          bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
          bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
        ''
      ];
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = lib.mkForce "/home/axchi/Pictures/wallpapers/thisdaone3.jpg";
      wallpaper = lib.mkForce ", /home/axchi/Pictures/wallpapers/thisdaone3.jpg";
    };
  };
}
