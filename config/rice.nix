{
  lib,
  config,
  username,
  ...
}:
{
  # Hyprland styling configuration
  hyprland = {
    decoration = {
      rounding = 15;
      blur = {
        enabled = true;
        size = 8;
        passes = 2;
        new_optimizations = true;
        ignore_opacity = true;
        xray = true;
      };
      active_opacity = 0.95;
      inactive_opacity = 0.88;
      fullscreen_opacity = 1.0;
      shadow = {
        enabled = true;
        range = 30;
        render_power = 3;
        color = "0x66000000";
      };
    };

    animations = {
      enabled = true;
      bezier = [
        "linear, 0, 0, 1, 1"
        "md3_standard, 0.2, 0, 0, 1"
        "md3_decel, 0.05, 0.7, 0.1, 1"
        "md3_accel, 0.3, 0, 0.8, 0.15"
        "overshot, 0.05, 0.9, 0.1, 1.1"
        "crazyshot, 0.1, 1.5, 0.76, 0.92"
        "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
        "fluent_decel, 0.1, 1, 0, 1"
        "easeInOutCirc, 0.85, 0, 0.15, 1"
        "easeOutCirc, 0, 0.55, 0.45, 1"
        "easeOutExpo, 0.16, 1, 0.3, 1"
        "myBezier, 0.05, 0.9, 0.1, 1.00"
        "easeInOutQuint, 0.83, 0, 0.17, 1"
        "easeOutQuint, 0.22, 1, 0.36, 1"
        "wind, 0, 0.5, 0.5, 1.0"
        "winIn, 0.1, 1.1, 0.1, 1.1"
        "winOut, 0.3, -0.3, 0, 1"
      ];
      animation = [
        "windows, 1, 3.5, wind, slide"
        "windowsIn, 1, 6, winIn, slide"
        "windowsOut, 1, 5, winOut, slide"
        "windowsMove, 1, 2, wind, slide"
        "border, 1, 10, default"
        "fade, 1, 10, easeOutQuint"
        "fadeDim, 1, 10, easeOutQuint"
        "fadeSwitch, 1, 10, easeOutQuint"
        "fadeShadow, 1, 10, easeOutQuint"
        "workspaces, 1, 7, easeOutExpo, slide"
        "specialWorkspace, 1, 3, md3_decel, slidevert"
      ];
    };

    general = {
      gaps_in = 6;
      gaps_out = 8;
      border_size = 0;
      layout = "dwindle";
      resize_on_border = true;
      col.active_border = "rgb(${config.stylix.base16Scheme.base08}) rgb(${config.stylix.base16Scheme.base0C}) 45deg";
      col.inactive_border = "rgb(${config.stylix.base16Scheme.base01})";
    };
  };

  # Hyprlock styling configuration
  hyprlock = {
    background = {
      blur_passes = 2;
      blur_size = 8;
    };
    input-field = {
      size = "200, 50";
      dots_center = true;
      fade_on_empty = false;
      font_color = "rgb(CFE6F4)";
      inner_color = "rgb(657DC2)";
      outer_color = "rgb(0D0E15)";
      outline_thickness = 5;
      shadow_passes = 2;
    };
  };

  # Global styling configuration
  stylix = {
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor = {
      package = "bibata-cursors";
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = "nerdfonts";
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = "montserrat";
        name = "Montserrat";
      };
      serif = {
        package = "montserrat";
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
} 