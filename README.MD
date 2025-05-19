# axchios NixOS Configuration

This repository contains my personal NixOS configuration files for an operating system that I daily drive.

## Screenshots

'arctic' rice enabled
![Screenshot 1](screenshots/swappy-20250125-004133.png)


'kindleflame' rice enabled
![Screenshot 2](screenshots/swappy-20250418-003645.png)

## Quick Overview + Features

- Modular support for a wide range of hardware
  - Tested on: Intel CPU, Intel integrated graphics, AMD CPU, NVIDIA GPU
- Fully riced Hyprland setup (tested to run on an NVIDIA GPU)
    - Hyprland, Hyprpaper and Hyprlock
- GRUB Bootloader for multi-boot
- Linux-zen kernel for lower latency and extra-crisp desktop experience
- NVIDIA and CUDA set up for PyTorch and other GPU accelerated training of ML models (and actively used for that)
- Separated rice files for easily swapping themes (Hyprland, GRUB bootloader, Waybar and others in one place!)
    - Easily declare new rices and swap between them
- Customized terminal with Vim-style navigation (Alacritty as the terminal emulator)
- Albert as the launcher (SUPER + SPACE to bring up) - basically Spotlight search but more customizable
- Everything designed to be within quick access with shortcuts (check hypr.nix in config/core)
- Thunar as the file explorer
- Comprehensive Neovim/Neovide configs
- Dunst for a simple notification manager
- Waybar for the top bar
- Essentials: Chrome, Spotify, Discord, GIMP, KolourPaint
- Cursor AI IDE for coding

## Installation

### Prerequisites
- A working NixOS installation
- Git installed (`nix-env -iA nixos.git` if needed)

### Installation Steps
1. **Clone the Repository**
   ```bash
   git clone https://github.com/alexchistyakov/axchi-Nix
   cd axchi-Nix
   ```

2. **Create or Select a Host Configuration**
   
   You will most likely need to create your own host configuration based on your hardware. Example configurations are provided in the `hosts/` directory:
   
   - `axchi-nix-desktop`: Example configuration for desktop with NVIDIA GPU and AMD Ryzen
   - `axchi-nix-laptop`: Example configuration for laptop with Intel CPU, Intel integrated graphics and NVIDIA mobile GPU
   
   To create your own configuration, use the available hardware modules in the `modules/` directory:
   
   - `nvidia-drivers.nix`: Support for NVIDIA GPUs
   - `intel-drivers.nix`: Support for Intel integrated graphics
   - `amd-drivers.nix`: Support for AMD GPUs
   - `nvidia-prime-drivers.nix`: Support for NVIDIA Optimus (laptop with dual GPU)
   - `local-hardware-clock.nix`: Hardware clock configuration
   - `vm-guest-services.nix`: Support for running as a VM guest
   - `apple-silicon-support/`: Support for Apple Silicon hardware
   
   After creating or selecting your host configuration:
   ```bash
   export HOST="your-host-name"
   ```

3. **Customize Configuration**
   - Update username in `flake.nix`
   - Choose rice theme in `rice/default.nix`
   - Modify host-specific settings in `hosts/$HOST/config.nix`

4. **Build and Activate**
   ```bash
   sudo nixos-rebuild switch --flake .#$HOST
   ```

5. **Reboot**
   ```bash
   sudo reboot
   ```

6. **Update System** (when needed)
   ```bash
   cd /path/to/axchios
   sudo nixos-rebuild switch --flake .#$HOST
   ```

## System Structure

- **flake.nix**: Main entry point that defines the system configuration, inputs, and outputs
- **hosts/**: Machine-specific configurations
  - `axchi-nix-desktop/`: my desktop configuration 
      - NVIDIA RTX 4070 + AMD Ryzen 9 with two SSDs: one with Windows, one with NixOS
  - `axchi-nix-laptop/`: Laptop configuration
      - Intel CPU + Intel integrated graphics + NVIDIA mobile GPU (Dell XPS)
  - `default/`: Default/fallback configuration (BROKEN)
- **modules/**: Hardware and system service modules
  - Hardware drivers (nvidia, intel, amd)
  - Specialized hardware support (apple-silicon)
  - Basically, modular hardware support so that you can just select your hardware in `hosts/<yourhostname>`
- **config/**: Application and environment configurations
  - `core/`: Core system and home-manager configurations (WIP)
  - Window manager (Hyprland) and related tools
  - Terminal emulator and shell settings
  - Various application configurations (neovim, waybar, etc.)
  - All of the OS configs that will be common accross hosts are here
- **rice/**: Visual themes and customizations
  - Different theme options (arctic, kindleflame)
  - Switch between them by changing the name of your rice in `rice/default.nix`
- **scripts/**: Utility scripts for system management

## Keyboard Shortcuts

### Application Shortcuts
- `SUPER + Return`: Open terminal
- `SUPER + SPACE`: Toggle Albert launcher
- `SUPER + SHIFT + W`: Execute web search
- `SUPER + W`: Open Windows VM in full workspace
- `SUPER + ALT + W`: Set wallpaper
- `SUPER + SHIFT + N`: Show notification history
- `SUPER + B`: Open browser
- `SUPER + S`: Take screenshot
- `SUPER + D`: Open Discord
- `SUPER + O`: Open OBS
- `SUPER + C`: Open color picker
- `SUPER + G`: Open GIMP
- `SUPER + Z`: Open Steam
- `SUPER + SHIFT + G`: Open Godot 4
- `SUPER + E`: Open Thunar file manager
- `SUPER + M`: Open Spotify
- `SUPER + V`: Open VNC viewer

### Window Management
- `SUPER + Q`: Kill active window
- `SUPER + P`: Toggle pseudo mode
- `SUPER + SHIFT + J`: Toggle split
- `SUPER + F`: Toggle fullscreen
- `SUPER + T`: Toggle floating
- `SUPER + SHIFT + C`: Exit Hyprland

### Window Movement
- `SUPER + SHIFT + ←/→/↑/↓`: Move window left/right/up/down
- `SUPER + SHIFT + h/l/k/j`: Move window left/right/up/down
- `SUPER + ←/→/↑/↓`: Focus window left/right/up/down
- `SUPER + h/l/k/j`: Focus window left/right/up/down

### Workspace Management
- `SUPER + 1-0`: Switch to workspace 1-10
- `SUPER + SHIFT + SPACE`: Move window to special workspace
- `SUPER + SHIFT + 1-0`: Move window to workspace 1-10
- `SUPER + CTRL + →/←`: Switch to next/previous workspace
- `SUPER + mouse_wheel`: Switch workspaces
- `SUPER + TAB`: Switch to next monitor workspace
- `SUPER + SHIFT + Tab`: Switch to previous monitor workspace
- `SUPER + N`: Switch to empty workspace
- `ALT + Tab`: Cycle through windows

### Media Controls
- `XF86AudioRaiseVolume`: Increase volume
- `XF86AudioLowerVolume`: Decrease volume
- `XF86AudioMute`: Toggle mute
- `XF86AudioPlay/Pause`: Play/pause media
- `XF86AudioNext`: Next track
- `XF86AudioPrev`: Previous track
- `XF86MonBrightnessDown`: Decrease brightness
- `XF86MonBrightnessUp`: Increase brightness

### Mouse Bindings
- `SUPER + Left Mouse Button`: Move window
- `SUPER + Right Mouse Button`: Resize window

## Special thanks:

  - Thanks to Zaney and ZaneyOS for providing the base for this project
