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
        "hyprpaper"
        "dunst"
        "nm-applet --indicator"
        "lxqt-policykit-agent"
        "albert &"
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

      render.explicit_sync = 1;

      windowrulev2 = rice.hyprland.windowrulev2 ++ [
        # Converted from windowrule to windowrulev2
        "center,class:^(steam)$"
        "float,class:^(nm-connection-editor)$"
        "float,class:^(blueman-manager)$"
        "float,class:^(swayimg)$"
        "float,class:^(vlc)$"
        "float,class:^(Viewnior)$"
        "float,class:^(pavucontrol)$"
        "float,class:^(nwg-look)$"
        "float,class:^(qt5ct)$"
        "float,class:^(mpv)$"
        "float,class:^(zoom)$"
        "float,class:(nmtui)"
        "dimaround,title:(VNC Viewer: Connection Details)"
        "dimaround,title:(VNC authentication)"
        
        # Existing windowrulev2 entries
        "center,title:(VNC Viewer: Connection Details)"
        "center,title:(VNC authentication)"
        "stayfocused,title:^()$,class:^(steam)$"
        "stayfocused,title:(VNC Viewer: Connection Details)"
        "stayfocused,title:(VNC authentication)"
        "minsize 1 1,title:^()$,class:^(steam)$"
        "xray,title:(Albert)"
        "nodim on,title:(Albert)"
        "opacity 1.0 1.0,class:^(swaync)$"
        "rounding 15,class:^(Dunst)$"
        "noshadow false,class:^(Dunst)$"
        "float,class:(nmtui)"
        "move 70% 5%,class:(nmtui)"
        "size 25% 40%,class:(nmtui)"
        "float,class:^(.virt-manager-wrapped)$,title:^(Virtual Machine Manager)$"
        "size 516 449,class:^(.virt-manager-wrapped)$,title:^(Virtual Machine Manager)$"
        "move 41% 40,class:^(.virt-manager-wrapped)$,title:^(Virtual Machine Manager)$"
        "fullscreen,class:^(virt-viewer)$,title:^(MicroWin11 on QEMU/KVM)$"
        "noshadow, title:^(Albert)$"
        
        # Fix for Steam dropdowns
        "stayfocused,class:^(steam)$,title:^((?!Steam).)*$"
        
        # Fix for app popups to stay at cursor
        "move onscreen cursor,class:^(xdg-desktop-portal)$"
        "move onscreen cursor,class:^(xdg-desktop-portal-gtk)$"
        "move onscreen cursor,class:^(.*?)(.exe)$"
      ];

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_invert = false;
        workspace_swipe_min_fingers = true;
        workspace_swipe_distance = 750;
      };

      misc = {
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        render_ahead_of_time = true;
        render_ahead_safezone = 70;
        vfr = true;
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
        "${modifier}SHIFT,J,togglesplit,"
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
        "animation slidefade 80%, notifications"
        "blur, notifications"
        "ignorezero, notifications"
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