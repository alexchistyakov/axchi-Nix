# AxchiOS NixOS Configuration

This repository contains my personal NixOS configuration files for an operating system that I daily drive.

## Screenshots

![Screenshot 1](screenshots/swappy-20250125-004133.png)

![Screenshot 2](screenshots/swappy-20250418-003645.png)

## Features

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
- Modules for supporting other hardware
- Thunar as the file explorer
- Comprehensive Neovim/Neovide configs
- Dunst for a simple notification manager
- Essentials: Chrome, Spotify, Discord, GIMP, KolourPaint
- Cursor AI IDE for coding

## System Structure

- **flake.nix**: Main entry point that defines the system configuration, inputs, and outputs
- **hosts/**: Machine-specific configurations
  - `axchi-nix-desktop/`: Desktop configuration
  - `axchi-nix-laptop/`: Laptop configuration
  - `default/`: Default/fallback configuration
- **modules/**: Hardware and system service modules
  - Hardware drivers (nvidia, intel, amd)
  - Specialized hardware support (apple-silicon)
  - System services configurations
- **config/**: Application and environment configurations
  - `core/`: Core system and home-manager configurations
  - Window manager (Hyprland) and related tools
  - Terminal emulator and shell settings
  - Various application configurations (neovim, waybar, etc.)
- **rice/**: Visual themes and customizations
  - Different theme options (arctic, kindleflame)
- **scripts/**: Utility scripts for system management

## Special thanks:

  - Thanks to Zaney and ZaneyOS for providing the base for this project
