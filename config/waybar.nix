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
          #"custom/startmenu"
          "custom/exit"
          "idle_inhibitor"
          "hyprland/workspaces"
        ];
        modules-right = [
          "custom/notification"
          "group/hardware"
          "pulseaudio"
          "bluetooth"
          "network"
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
            "" = "empty screen";
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
          format-wifi = "{icon}  {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };
        "group/hardware" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 300;
            children-class = "not-memory";
            transition-left-to-right = false;
          };
          modules = [
            "memory"
            "disk"
            "cpu"
          ];
        };
        "bluetooth" = {
          format = " {status}";
          format-disabled = "";
          format-off = "";
          interval = 30;
          on-click = "blueman-manager";
          format-no-controller = "";
        };
        
        "tray" = {
          spacing = 12;
        };
        "pulseaudio" = {
          format = "{icon}   {volume}%";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = " ";
            hands-free = " ";
            headset = "0 ";
            phone = " ";
            portable = " ";
            car = " ";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };
        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "hyprlock";
        };
        "custom/startmenu" = {
          tooltip = false;
          format = "  ";
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
    # TODO hardcoded background image. Use a variable
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
            transition-property: background-color;
            transition-duration: .5s;
        }

        #workspaces {
            margin: 3px 10px 3px 3px;
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

        .modules-left {
          margin-left: 7px;
        }

        #idle_inhibitor {
          background: rgba(0,0,0,0);
          font-weight: bold;
          margin: 4px 0px;
          margin-right: 10px;
          margin-left: 5px;
          color: #FFFFFF;
        }
        #idle_inhibitor.active {
          color: rgba(117,207,255,1);
        }
        #custom-startmenu {
          font-size: 28px;
          background: rgba(16,16,16,0.3);
          background-image: url("/home/axchi/zaneyos/config/nix.png");
          background-position: center;
          background-repeat: no-repeat;
          background-size: contain;
          color: #FFFFFF;
          margin-right: 10px;
          margin-left: 5px;
          padding: 5px 10px 5px 10px;
          min-width: 25px;
          min-height: 25px;
          transition: all 0.2s ease-in-out;
          border-radius: 0px 0px 15px 15px;
        }
        #custom-startmenu:hover {
          color: rgba(153,213,255,1);
        }
        #window, #pulseaudio,
        #custom-hyprbindings, #network, #battery,
        #custom-notification, #tray {
          background: rgba(0,0,0,0);
          color: #FFFFFF;
          margin-right: 5px;
          font-size: 14px;
        }

        #pulseaudio {
          font-size: 14px;
          color: #FFFFFF;
          margin-right: 10px;
        }
        #disk,#memory,#cpu {
          margin:0px;
          padding:0px 5px 0px 5px;
          font-size:14px;
          color:#FFFFFF;
        }
        #custom-exit {
          margin-right: 8px;
          margin-left: 5px;
        }
        #custom-exit:hover {
          color: rgba(153,213,255,1);
        }
        #bluetooth, #bluetooth.on, #bluetooth.connected {
          font-size: 14px;
          color: @textcolor;
          border-radius: 15px;
          margin: 0px 5px 0px 0px;
        }
        #clock {
          font-weight: bold;
          background: rgba(0,0,0,0);
          color: #FFFFFF;
          padding: 0px 7px 0px 0px;
          margin-right: 8px;
        }
      ''
    ];
  };
}
