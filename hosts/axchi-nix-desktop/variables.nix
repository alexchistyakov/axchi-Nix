{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "alex_chistyakov";
  gitEmail = "ax.chistyakov@gmail.com";

  # Hyprland Settings
  extraMonitorSettings = [
    "DP-1,1920x1090@60.0,3840x1201,1.0"
    "DP-1,transform,1"
    "DP-2,1920x1080@60.0,966x0,1.0"
    "HDMI-A-1,3840x2160@240Hz, 0x1080,1.0"
  ];

  # Waybar Settings
  clock24h = false;

  # Program Options
  browser = "google-chrome-stable"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "alacritty"; # Set Default System Terminal
  keyboardLayout = "us";
  displayBattery = false;

  # Hyprlock Settings
  hyprlockInputSize = "250, 50"; # Standard input field size
  hyprlockMonitor = "HDMI-A-1"; # Primary desktop display
}
