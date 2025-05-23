{ pkgs, lib, config, ... }:

{
  services.dunst = {
    enable = true;
    settings = lib.mkForce {
      global = {
        monitor = 2; # MOVE TO HOST CONFIG
        follow = "none"; # MOVE MOST OF THIS TO RICE
        width = 500;
        height = "(0,500)";
        origin = "top-center";
        offset = "30x30";
        scale = 1;
        notification_limit = 20;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        progress_bar_corner_radius = 10;
        icon_corner_radius = 10;
        indicate_hidden = true;
        transparency = 25;
        separator_height = 2;
        padding = 20;
        horizontal_padding = 20;
        text_icon_padding = 0;
        frame_width = 1;
        frame_color = "#333333";
        gap_size = 0;
        separator_color = "frame";
        sort = true;
        font = "Fira Sans Semibold 11";
        line_height = 1;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        enable_recursive_icon_lookup = true;
        icon_theme = "Papirus-Dark,Adwaita";
        icon_path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/16x16/status/:${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/16x16/devices/:${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/16x16/apps/:${pkgs.adwaita-icon-theme}/share/icons/Adwaita/16x16/status/:${pkgs.adwaita-icon-theme}/share/icons/Adwaita/16x16/devices/:${pkgs.adwaita-icon-theme}/share/icons/Adwaita/16x16/apps/";
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 128;
        sticky_history = true;
        history_length = 20;
        #dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst:";
        #browser = "${pkgs.xdg-utils}/bin/xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 10;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      experimental = {
        per_monitor_dpi = false;
      };

      urgency_low = {
        background = "#d4beba55";
        foreground = "#FFFFFF";
        timeout = 3;
      };

      urgency_normal = {
        background = "#d4beba55";
        foreground = "#FFFFFF";
        timeout = 3;
      };

      urgency_critical = {
        background = "#90000055";
        foreground = "#ffffff";
        frame_color = "#ffffff";
        timeout = 5;
      };
    };
  };
}