{
  lib,
  config,
  username,
  pkgs,
  variables,
  ...
}:

let
  # Define rice-specific packages
  ricePackages = with pkgs; [
    bibata-cursors
    montserrat
    # Font packages
    noto-fonts-emoji
    noto-fonts-cjk-sans
    font-awesome
    # symbola  # Commented out as noted in original config
    material-icons
    pkgs.nerd-fonts.jetbrains-mono
    terminus_font  # For GRUB terminal font
    unifont       # For GRUB menu items
    powerline-fonts
    powerline-symbols
  ];
  
  # Define wallpaper path
  wallpaperPath = ./assets/wallpapers/mountain_saturated_geometric_down.jpg;
in
{
  # Package management for this rice
  packages = ricePackages;

  # Fonts configuration
  fonts = {
    packages = ricePackages;
  };

  starship = {
    settings = {
        add_newline = false;
        line_break = {
          disabled = true;
        };
        format = "$username $directory$git_branch$character";
        #format = "$username| $directory$git_branch|$character";
        #format = "$username$hostname| $directory$git_branch|$character";
      
        username = {
          format = "[ $user ](bg:white fg:black bold)";
          style_user = "white";
          show_always = true;
        };

        hostname = {
          format = "[ $hostname ](bg:cyan fg:white bold)";
          style = "white";
          ssh_only = false;
        };

        character = {
          success_symbol = "[❯❯](bold white)";
          error_symbol = "[❯](bold red)";
          vimcmd_symbol = "[❯](bold green)";
        };

        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        directory = {
          read_only = " 󰌾";
        };
        docker_context = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        git_branch = {
          symbol = " ";
        };
        golang = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        package = {
          symbol = "󰏗 ";
        };
        python = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
        swift = {
          symbol = " ";
        };
        zig = {
          symbol = " ";
        };
      };
    };

  # Hyprland styling configuration
  hyprland = {
    decoration = {
      rounding = 15;
      blur = {
        enabled = true;
        size = 6;
        passes = 3;
        new_optimizations = true;
        ignore_opacity = true;
        xray = false;
        brightness = 0.8;
      };
      active_opacity = 0.85;
      inactive_opacity = 0.80;
      fullscreen_opacity = 1.0;
      shadow = {
        enabled = true;
        range = 30;
        render_power = 3;
        color = "0x66000000";
      };
    };

    layerrule = [
      #"blur,waybar"
    ];

    windowrulev2 = [
      "opacity 0.9 0.7,class:^(google-chrome-stable)$"
      "opacity 0.70 0.68,class:^(thunar)$"
      "opacity 1.0 0.9,class:(Neovide)"
      "dimaround, title:(Albert)"
    ];

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
        "workspaces, 1, 6.2831, easeOutExpo, slide"
        #"workspaces, 1, 3.1415, easeOutCirc, slide"
        "specialWorkspace, 1, 3, md3_decel, slidevert"
      ];
    };

    general = {
      gaps_in = 6;
      gaps_out = 8;
      border_size = 0;
      layout = "dwindle";
      resize_on_border = true;
      "col.active_border" = "rgb(${config.stylix.base16Scheme.base08}) rgb(${config.stylix.base16Scheme.base0C}) 45deg";
      "col.inactive_border" = "rgb(${config.stylix.base16Scheme.base01})";
    };
  };
  # GDM Styling 
  gdm = {
    background = wallpaperPath;
  };  
  # Hyprlock styling configuration
  hyprlock = {
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = {
        blur_passes = 3;
        blur_size = 8;
        path = "${wallpaperPath}";
      };
      input-field = {
        size = variables.hyprlockInputSize;
        outline_thickness = 0;
        dots_size = 0.25; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
        dots_fade_time = 100;
        outer_color = "rgb(151515)";
        inner_color = "rgb(FFFFFF)";
        font_color = "${config.stylix.base16Scheme.base00}";
        fade_on_empty = true;
        fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
        placeholder_text = "Password"; # Text rendered in the input box when it's empty.
        hide_input = false;
        rounding = 10; # -1 means complete rounding (circle/oval)
        check_color = "rgba(150, 150, 150, 0.5)";
        fail_color = "rgb(250, 250, 250)"; # if authentication failed, changes outer_color and fail message color
        fail_text = "Incorrect"; # can be set to empty
        fail_transition = 300; # transition time in ms between normal outer_color and fail_color
        capslock_color = -1;
        numlock_color = -1;
        bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
        invert_numlock = false; # change color if numlock is off
        swap_font_color = false; # see below
        position = "0, -20";
        halign = "center";
        valign = "center";
        monitor = variables.hyprlockMonitor;
      };
    };
  };

  # Hyprpaper configuration
  hyprpaper = {
    settings = {
      preload = ["${toString wallpaperPath}"];
      wallpaper = ", ${toString wallpaperPath}";
    };
  };

  # Fastfetch styling configuration
  fastfetch = {
    settings = {
      display = {
        color = {
          keys = "35";
          output = "90";
        };
      };
      logo = {
        # Commented out previous logo configuration for later use
        #type = "kitty-direct";
        type = "chafa";
        source = ./assets/nix.png;
        height = 15;
        width = 34;
        padding = {
          top = 0;
          left = 2;
        };
      };
      modules = [
        "break"
        {
            type = "custom";
            format = "┌──────────────────── Hardware ────────────────────┐";
        }
        {
            type = "cpu";
            key = "│  ";
        }
        {
            type = "gpu";
            key = "│ 󰍛 ";
        }
        {
            type = "memory";
            key = "│ 󰑭 ";
        }
        {
            "type"= "disk";
            "key"= "│ 󰋊 ";
        }
        {
            type = "custom";
            format = "└──────────────────────────────────────────────────┘";
        }
        {
            type = "custom";
            format = "┌──────────────────── Software ────────────────────┐";
        }
        {
            type = "custom";
            format = " OS -> NixOS (axchi-style)";
        }
        {
            type = "kernel";
            key = "│ ├ ";
        }
        {
            type = "packages";
            key = "│ ├󰏖 ";
        }
        {
            type = "shell";
            key = "│ └ ";
        }
        {
            type = "custom";
            format = "└──────────────────────────────────────────────────┘";
        }
        {
            type = "command";
            key = " ";
            text = #bash
            ''
              # Calculate age of system in days
              birth_install=$(stat -c %W /)
              current=$(date +%s)
              delta=$((current - birth_install))
              delta_days=$((delta / 86400))
              echo "Uptime: $(awk '{printf "%d hours, %d minutes\n", int($1/3600), int(($1%3600)/60)}' /proc/uptime) | Age: $delta_days days"
            '';
        }
        "break"
      ];
    };
  };

  # Global styling configuration
  stylix = {
    image = wallpaperPath;
    enable = true;
    polarity = "dark";
    opacity.terminal = 0.95;
    base16Scheme = {
      base00 = "191b27";
      base01 = "374284";
      base02 = "4467b8";
      base03 = "7b9fd9";
      base04 = "3cc8ec";
      base05 = "cfe6f4";
      base06 = "c0fbf9";
      base07 = "bffbfc";
      base08 = "c338fa";
      base09 = "249ada";
      base0A = "7b8fce";
      base0B = "158ee6";
      base0C = "5093e2";
      base0D = "6d94bd";
      base0E = "7b90c9";
      base0F = "2ad186";
    };
    #base16Scheme = {
      #base00 = "0E060F";
      #base01 = "712336";
      #base02 = "312E50";
      #base03 = "3A3B63";
      #base04 = "533351";
      #base05 = "44446C";
      #base06 = "90272E";
      #base07 = "d19e94";
      #base08 = "926e67";
      #base09 = "712336";
      #base0A = "312e50";
      #base0B = "3a3b63";
      #base0C = "533351";
      #base0D = "44446C";
      #base0E = "f6c177";
      #base0F = "d19e94";
    #};
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono ;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 13;
        desktop = 11;
        popups = 12;
      };
    };
  };

  # GTK Theme Configuration
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Qt Theme Configuration
  qt = {
    enable = true;
    style.name = "adwaita";
    platformTheme.name = "gtk4";
  };

  # Terminal styling
  terminal = {
    kitty = {
      settings = {
        window_padding_width = 4;
        tab_bar_style = "fade";
        tab_fade = 1;
        active_tab_font_style = "bold";
        inactive_tab_font_style = "bold";
      };
    };
    alacritty = {
      settings = {
        window = {
          opacity = 1.0;
          padding = {
            x = 4;
            y = 4;
          };
        };
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Italic";
          };
          bold_italic = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Bold Italic";
          };
          size = 13;
        };
      };
    };
  };

  # GRUB theme configuration
  grub = {
    theme = lib.mkForce ./assets/grub/vimix;
    fontSize = 16;
    font = lib.mkForce ./assets/grub/vimix/terminus-16.pf2;  # Default font
  };
  waybarOpacity = 0.5;
} 
