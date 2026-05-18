{
  lib,
  username,
  host,
  config,
  pkgs,
  ...
}:

let
  variables = import ../hosts/${host}/variables.nix;
  inherit (variables)
    browser
    terminal
    extraMonitorSettings
    keyboardLayout;
  rice = import ../rice { inherit lib config username pkgs variables; };
  modifier = "SUPER";
in
with lib;
{
  wayland.windowManager.hyprland = lib.mkForce {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    configType = "hyprlang";

    settings = {
      # Environment variables
      env = [
        "NIXOS_OZONE_WL,1"
        "NIXPKGS_ALLOW_U4FREE,1"
        #"LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        #"GBM_BACKEND,nvidia-drm"
        "NVD_BACKEND,direct"
        #"__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "__GL_GSYNC_ALLOWED,1"
        "__GL_VRR_ALLOWED,1"
        "XCURSOR_SIZE,24"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "GDK_BACKEND,wayland,x11"
        "CLUTTER_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "SDL_VIDEODRIVER,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "MOZ_ENABLE_WAYLAND,1"
        "__GL_THREADED_OPTIMIZATIONS,1"
      ];

      # Startup commands
      exec-once = [
        "hyprlock"
        "dbus-update-activation-environment --systemd --all"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "waybar"
        "dunst"
        "nm-applet --indicator"
        "lxqt-policykit-agent"
        "albert"
        "hyprpaper"
      ];

      general = rice.hyprland.general;

      input = {
        kb_layout = keyboardLayout;
        kb_options = [
          "grp:alt_shift_toggle"
          "caps:super"
        ];
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
          disable_while_typing = true;
          scroll_factor = 0.6;
        };
        sensitivity = 0.9;
        accel_profile = "flat";
      };

      cursor = {
        no_hardware_cursors = false;
        use_cpu_buffer = true;
      };

      xwayland = {
        force_zero_scaling = false;
        use_nearest_neighbor = true;
      };

      windowrule = rice.hyprland.windowrule ++ [
        "center on, match:class ^(steam)$"
        "float on, match:class ^(nm-connection-editor)$"
        "float on, match:class ^(blueman-manager)$"
        "float on, match:class ^(swayimg)$"
        "float on, match:class ^(vlc)$"
        "float on, match:class ^(Viewnior)$"
        "float on, match:class ^(pavucontrol)$"
        "float on, match:class ^(nwg-look)$"
        "float on, match:class ^(qt5ct)$"
        "float on, match:class ^(mpv)$"
        "float on, match:class ^(zoom)$"
        "float on, match:class (nmtui)"
        "dim_around on, match:title (VNC Viewer: Connection Details)"
        "dim_around on, match:title (VNC authentication)"
        
        "center on, match:title (VNC Viewer: Connection Details)"
        "center on, match:title (VNC authentication)"
        "stay_focused on, match:title ^()$, match:class ^(steam)$"
        "stay_focused on, match:title (VNC Viewer: Connection Details)"
        "stay_focused on, match:title (VNC authentication)"
        "min_size 1 1, match:title ^()$, match:class ^(steam)$"
        "xray on, match:title (Albert)"
        "no_dim on, match:title (Albert)"
        "opacity 1.0 1.0, match:class ^(swaync)$"
        "rounding 15, match:class ^(Dunst)$"
        "no_shadow off, match:class ^(Dunst)$"
        "float on, match:class (nmtui)"
        "move 70% 5%, match:class (nmtui)"
        "size 25% 40%, match:class (nmtui)"
        "float on, match:class ^(.virt-manager-wrapped)$, match:title ^(Virtual Machine Manager)$"
        "size 516 449, match:class ^(.virt-manager-wrapped)$, match:title ^(Virtual Machine Manager)$"
        "move 41% 40, match:class ^(.virt-manager-wrapped)$, match:title ^(Virtual Machine Manager)$"
        "fullscreen on, match:class ^(virt-viewer)$, match:title ^(MicroWin11 on QEMU/KVM)$"
        "no_shadow on, match:title ^(Albert)$"
        
        # Fix for Steam dropdowns
        "stay_focused on, match:class ^(steam)$, match:title ^((?!Steam).)*$"
        
        # Fix for app popups to stay at cursor
        "move onscreen cursor, match:class ^(xdg-desktop-portal)$"
        "move onscreen cursor, match:class ^(xdg-desktop-portal-gtk)$"
        "move onscreen cursor, match:class ^(.*?)(.exe)$"
      ];

      # Gestures (new syntax as of Hyprland 0.51)
      # 2-finger drag = move active window (mirrors SUPER + left-click drag).
      # 3-finger drag = resize active window (mirrors SUPER + right-click drag).
      gesture = [
        "4, horizontal, workspace"
        "2, swipe, move"
        "3, swipe, resize"
      ];

      misc = {
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        vrr = true;
      };

      # Keybinds
      bind = [
        "${modifier},Return,exec,${terminal}"
        "${modifier},SPACE,exec,albert toggle"
        "${modifier}SHIFT,W,exec,web-search"
        "${modifier},W,exec,hyprctl dispatch workspace empty && virt-viewer -f -c qemu:///system MicroWin11"
        "${modifier}ALT,W,exec,wallsetter"
        "${modifier}SHIFT,N,movetoworkspace,empty"
        "${modifier},B,exec,${browser}"
        "${modifier},S,exec,screenshootin"
        "${modifier},D,exec,discord"
        "${modifier},O,exec,obs"
        "${modifier},C,exec,hyprpicker -a"
        "${modifier},G,exec,gimp"
        "${modifier},Z,exec,steam"
        "${modifier}SHIFT,G,exec,godot4"
        "${modifier},E,exec,thunar"
        "${modifier},M,exec,spotify"
        "${modifier},V,exec,vncviewer"
        "${modifier},Q,killactive,"
        "${modifier},P,pseudo,"
        "${modifier}SHIFT,J,layoutmsg,togglesplit"
        "${modifier},F,fullscreen,"
        "${modifier},T,togglefloating,"
        "${modifier}SHIFT,C,exit,"
        "${modifier}SHIFT,left,movewindow,l"
        "${modifier}SHIFT,right,movewindow,r"
        "${modifier}SHIFT,up,movewindow,u"
        "${modifier}SHIFT,down,movewindow,d"
        "${modifier}SHIFT,h,movewindow,l"
        "${modifier}SHIFT,l,movewindow,r"
        "${modifier}SHIFT,k,movewindow,u"
        "${modifier}SHIFT,j,movewindow,d"
        "${modifier},left,movefocus,l"
        "${modifier},right,movefocus,r"
        "${modifier},up,movefocus,u"
        "${modifier},down,movefocus,d"
        "${modifier},h,movefocus,l"
        "${modifier},l,movefocus,r"
        "${modifier},k,movefocus,u"
        "${modifier},j,movefocus,d"
        "${modifier},1,workspace,1"
        "${modifier},2,workspace,2"
        "${modifier},3,workspace,3"
        "${modifier},4,workspace,4"
        "${modifier},5,workspace,5"
        "${modifier},6,workspace,6"
        "${modifier},7,workspace,7"
        "${modifier},8,workspace,8"
        "${modifier},9,workspace,9"
        "${modifier},0,workspace,10"
        "${modifier}SHIFT,SPACE,movetoworkspace,special"
        "${modifier}SHIFT,1,movetoworkspace,1"
        "${modifier}SHIFT,2,movetoworkspace,2"
        "${modifier}SHIFT,3,movetoworkspace,3"
        "${modifier}SHIFT,4,movetoworkspace,4"
        "${modifier}SHIFT,5,movetoworkspace,5"
        "${modifier}SHIFT,6,movetoworkspace,6"
        "${modifier}SHIFT,7,movetoworkspace,7"
        "${modifier}SHIFT,8,movetoworkspace,8"
        "${modifier}SHIFT,9,movetoworkspace,9"
        "${modifier}SHIFT,0,movetoworkspace,10"
        "${modifier}CONTROL,right,workspace,e+1"
        "${modifier}CONTROL,left,workspace,e-1"
        "${modifier},mouse_down,workspace,e+1"
        "${modifier},mouse_up,workspace,e-1"
        "${modifier},TAB,workspace,m+1"
        "${modifier}SHIFT,Tab,workspace,m-1"
        "${modifier},N,workspace,empty"
        "ALT,Tab,cyclenext"
        "ALT,Tab,bringactivetotop"
        ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioPlay,exec,playerctl play-pause"
        ",XF86AudioPause,exec,playerctl play-pause"
        ",XF86AudioNext,exec,playerctl next"
        ",XF86AudioPrev,exec,playerctl previous"
        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
        ",XF86MonBrightnessUp,exec,brightnessctl set +5%"
      ];

      bindm = [
        "${modifier},mouse:272,movewindow"
        "${modifier},mouse:273,resizewindow"
      ];      # Monitor configuration

      # User-defined settings coming from elsewhere

      monitor = extraMonitorSettings;

      animations = rice.hyprland.animations;
      decoration = rice.hyprland.decoration;
      layerrule = rice.hyprland.layerrule ++ [
        #"blur,waybar"
        "animation slidefade 80%, match:namespace notifications"
        "blur on, match:namespace notifications"
        "ignore_alpha 0.5, match:namespace notifications"
        #"xray, notifications"
      ];
    };
  };


  services.hyprpaper = {
    enable = true;
    settings = lib.mkForce rice.hyprpaper.settings;
  };

  programs.hyprlock = {
    enable = true;
    settings = lib.mkForce rice.hyprlock.settings;
  };
} 
