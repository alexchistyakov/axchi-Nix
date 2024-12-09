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
    keyboardLayout;
  rice = import ../rice { inherit lib config username pkgs; };
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
        "NIXPKGS_ALLOW_UNFREE,1"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "NVD_BACKEND,direct"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_RENDERER,vulkan"
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
      ];

      # Startup commands
      exec-once = [
        "dbus-update-activation-environment --systemd --all"
        "systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "killall -q hyprpaper;sleep .5 && hyprpaper"
        "hyprlock"
        "killall -q waybar;sleep .5 && waybar"
        "killall -q swaync;sleep .5 && swaync"
        "nm-applet --indicator"
        "lxqt-policykit-agent"
        "albert &"
      ];



      general = {
        gaps_in = rice.hyprland.general.gaps_in;
        gaps_out = rice.hyprland.general.gaps_out;
        border_size = rice.hyprland.general.border_size;
        layout = rice.hyprland.general.layout;
        resize_on_border = rice.hyprland.general.resize_on_border;
        "col.active_border" = rice.hyprland.general.col.active_border;
        "col.inactive_border" = rice.hyprland.general.col.inactive_border;
      };

      input = {
        kb_layout = keyboardLayout;
        kb_options = [
          "grp:alt_shift_toggle"
          "caps:super"
        ];
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.8;
        };
        sensitivity = 0;
        accel_profile = "flat";
      };

      cursor.no_hardware_cursors = true;

      xwayland.force_zero_scaling = true;


      render.explicit_sync = 1;

      # Window rules
      windowrule = [
        "noborder,^(wofi)$"
        "center,^(wofi)$"
        "center,^(steam)$"
        "float,nm-connection-editor|blueman-manager"
        "float,swayimg|vlc|Viewnior|pavucontrol"
        "float,nwg-look|qt5ct|mpv"
        "float,zoom"
      ];

      windowrulev2 = [
        "center,title:(VNC Viewer: Connection Details)"
        "center,title:(VNC authentication)"
        "stayfocused,title:^()$,class:^(steam)$"
        "minsize 1 1,title:^()$,class:^(steam)$"
        "opacity 0.9 0.7,class:^(google-chrome-stable)$"
        "opacity 0.75 0.7,class:^(thunar)$"
        "opacity 1.0 0.9,class:(Neovide)"
        "xray on,title:(Albert)"
      ];

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      misc = {
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        render_ahead_of_time = false;
        render_ahead_safezone = 70;
        vfr = true;
        vrr = false;
      };

      # Keybinds
      bind = [
        "${modifier},Return,exec,${terminal}"
        "${modifier},SPACE,exec,albert toggle"
        "${modifier}SHIFT,W,exec,web-search"
        "${modifier}ALT,W,exec,wallsetter"
        "${modifier}SHIFT,N,exec,swaync-client -rs"
        "${modifier},B,exec,${browser}"
        "${modifier},S,exec,screenshootin"
        "${modifier},D,exec,discord"
        "${modifier},O,exec,obs"
        "${modifier},C,exec,hyprpicker -a"
        "${modifier},G,exec,gimp"
        "${modifier}SHIFT,G,exec,godot4"
        "${modifier},E,exec,thunar"
        "${modifier},M,exec,spotify"
        "${modifier},V,exec,vncviewer"
        "${modifier},Q,killactive,"
        "${modifier},P,pseudo,"
        "${modifier}SHIFT,J,togglesplit,"
        "${modifier},F,fullscreen,"
        "${modifier}SHIFT,T,togglefloating,"
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
