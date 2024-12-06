{
  pkgs,
  lib,
  host,
  config,
  ...
}:

let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  inherit (import ../hosts/${host}/variables.nix) clock24h;
in
with lib;
{
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-center = [ "hyprland/window" ];
        modules-left = [
          "custom/startmenu"
          "idle_inhibitor"
          "hyprland/workspaces"
        ];
        modules-right = [
          "custom/notification"
          "cpu"
          "memory"
          "pulseaudio"
          "tray"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "clock" = {
          format = if clock24h == true then '' {:L%H:%M} '' else '' {:L%I:%M %p} '';
          tooltip = true;
          tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
        };
        "hyprland/window" = {
          max-length = 22;
          separate-outputs = false;
          rewrite = {
            "" = " you're staring at an empty screen, sir ";
          };
        };
        "memory" = {
          interval = 5;
          format = " {}%";
          tooltip = true;
        };
        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
        };
        "disk" = {
          format = " {free}";
          tooltip = true;
        };
        "network" = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };
        "tray" = {
          spacing = 12;
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "sleep 0.1 && pavucontrol";
        };
        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && wlogout";
        };
        "custom/startmenu" = {
          tooltip = false;
          format = " ";
          on-click = "albert toggle";
        };
        "custom/hyprbindings" = {
          tooltip = false;
          format = "󱕴";
          on-click = "sleep 0.1 && list-hypr-bindings";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = "true";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon} {}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && task-waybar";
          escape = true;
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          on-click = "";
          tooltip = false;
        };
      }
    ];
    style = concatStrings [
      ''
@define-color backgroundlight #FFFFFF;
@define-color backgrounddark #FFFFFF;
@define-color workspacesbackground1 #FFFFFF;
@define-color workspacesbackground2 #CCCCCC;
@define-color bordercolor #FFFFFF;
@define-color textcolor1 #000000;
@define-color textcolor2 #000000;
@define-color textcolor3 #FFFFFF;
@define-color iconcolor #FFFFFF;
        * {
          font-family: "Fira Sans semibold", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        
          border: none;
          border-radius: 0px;
      }

  window#waybar {
      background-color: rgba(0,0,0,0.5);
      border-bottom: 0px solid #ffffff;
      /* color: #FFFFFF; */
      transition-property: background-color;
      transition-duration: .5s;
      }
        #workspaces {
            margin: 3px 3px 3px 3px;
            border: 0px;
            font-size: 14px;
            color: @textcolor1;
            background: rgba(0,0,0,0.2);
            border-radius: 6px;
        }

        #workspaces button {
            border: 0px;
            margin:4px 5px 4px 4px;
            padding:0px 4px 0px 4px;
            color: @textcolor3;
            transition: all 0.5s ease-in-out;
        }

        #workspaces button.active {
            color: @textcolor1;
            background-color: #FFFFFF;
            border-radius: 5px;
        }

        #workspaces button:hover {
            color: @textcolor1;
            background: @workspacesbackground2;
            border-radius: 15px;
}

        #idle_inhibitor {
          background: rgba(0,0,0,0);
          font-weight: bold;
          margin: 4px 0px;
          margin-right: 15px;
          color: #FFFFFF;
        }
        #idle_inhibitor.active {
          color: rgba(117,207,255,1);
        }
        #custom-startmenu {
          font-size: 28px;
          background: rgba(16,16,16,0.3);
          background-image: url('nix.png');
          background-position: center;
          background-repeat: no-repeat;
          background-size: contain;
          color: #FFFFFF;
          margin-right: 10px;
          margin-left: 5px;
          padding: 0px 8px 0px 8px;
          transition: all 0.2s ease-in-out;
        }
        #custom-startmenu:hover {
          color: rgba(153,213,255,1);
        }
        #window, #pulseaudio, #cpu, #memory, 
        #custom-hyprbindings, #network, #battery,
        #custom-notification, #tray, #custom-exit {
          font-weight: bold;
          background: rgba(0,0,0,0);
          color: #FFFFFF;
          margin-right: 5px;
        }
        #clock {
          font-weight: bold;
          background: rgba(0,0,0,0);
          color: #FFFFFF;
          margin: 0px;
          padding: 0px 7px 0px 8px;
          margin-right: 8px;
          margin-left: 5px;
        }
      ''
    ];
  };
}
