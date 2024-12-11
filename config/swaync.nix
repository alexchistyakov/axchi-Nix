{ config, ... }:

{
  home.file.".config/swaync/config.json".text = ''
  {
    "$schema": "/etc/xdg/swaync/configSchema.json",

    "positionX": "right",
    "positionY": "top",
    "control-center-positionX": "none",
    "control-center-positionY": "none",
    "control-center-margin-top": 0,
    "control-center-margin-bottom": 0,
    "control-center-margin-right": 0,
    "control-center-margin-left": 0,
    "control-center-width": 500,
    "control-center-height": 600,
    "control-center-exclusive-zone": true,
    "fit-to-screen": true,
    "layer-shell": true,
    "layer": "overlay",
    "control-center-layer": "overlay",
    "cssPriority": "user",
    "notification-icon-size": 64,
    "notification-body-image-height": 100,
    "notification-body-image-width": 200,
    "notification-inline-replies": true,
    "timeout": 10,
    "timeout-low": 5,
    "timeout-critical": 0,
    "notification-window-width": 500,
    "keyboard-shortcuts": true,
    "image-visibility": "always",
    "transition-time": 200,
    "hide-on-clear": true,
    "hide-on-action": true,
    "script-fail-notify": true,

    "widgets": [
      "inhibitors",
      "dnd",
      "mpris",
      "notifications"
    ],
    "widget-config": {
      "inhibitors": {
        "text": "Inhibitors",
        "button-text": "Clear All",
        "clear-all-button": true
      },
      "title": {
        "text": "Notifications",
        "clear-all-button": false,
        "button-text": "Clear All"
      },
      "dnd": {
        "text": "Do Not Disturb"

      "label": {
        "max-lines": 5,
        "text": "Label Text"
      },
      "mpris": {
        "image-size": 96,
        "blur": true
      }
    }
  }
  '';
  home.file.".config/swaync/style.css".text = ''
    * {
      font-size: 14px;
    }

    .notification-container {
      background-color: #1e1e2e;
      padding: 8px;
      margin: 4px;
    }

    .notification {
      background-color: #1e1e2e;
      padding: 8px;
      margin: 4px;
      border: 1px solid #313244;
      border-radius: 8px 0px 0px 8px;
    }

    .control-center {
      background: #1e1e2e;
      margin: 0px;
      box-shadow: 0 0px 0px 5px rgba(0, 0, 0, 0.3);
      transition: transform 200ms ease-out;
      transform: translateX(100%);
      opacity: 1.0;
      border-radius: 0px;
    }

    .control-center.visible {
      transform: translateX(0);
      opacity: 1.0;
    }

    .widget-mpris {
      background: #313244;
      padding: 8px;
      margin: 4px;
      border-radius: 8px;
    }

    .widget-dnd {
      background: #313244;
      padding: 8px;
      margin: 4px;
      border-radius: 8px;
    }

    .widget-title {
      font-size: 16px;
      font-weight: bold;
      padding: 8px;
    }
  '';
}
