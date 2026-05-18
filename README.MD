# axchios NixOS Configuration

A simple and fast NixOS build designed to be almost entirely keyboard (shortcut) based. This build is specifically designed for easy ricing (including the boot loader)

Easy modules for setting this up on any hardware and simplified laptop/desktop setup (including ones with a touch screen)

Enough terminal prettification and tweaks to make your grandma feel comfortable using it

Clean, minimal, my daily driver.

## Screenshots

'arctic' rice enabled
![Screenshot 1](screenshots/swappy-20250125-004133.png)


'kindleflame' rice enabled
![Screenshot 2](screenshots/swappy-20250418-003645.png)

## Quick Start

Everything starts from **one place**: Albert, the launcher (Spotlight search if you've ever used a Mac, but sexier). 

### Open Albert

- **`SUPER + SPACE`** — open or close Albert from anywhere
- **Click the search icon** on the Waybar (top bar) — same thing, if you prefer the mouse

### Launch apps

SUPER+SPACE

With Albert open, start typing the name of what you want. Albert finds installed applications automatically — no menus to dig through.

Albert is not just an app launcher. The same search field also handles:

- **Files** — type a filename or path to open it
- **Calculator** — type a math expression (e.g. `42 * 17`) for an instant answer
- **Browser** — search bookmarks and browsing history
- **Docs** — look up manual pages and documentation

You really don't need to know anything else, Albert can launch all your apps for you.

### Launch file explorer

SUPER+E. Yeah. It's Thunar and it's good

### Launch Terminal

**`SUPER + Return`** — open Alacritty.

- Fish shell with crisp autocomplete
- Press **Esc** to enter Vim-style navigation (command-line editing)
- Neovim is configured too

### NixOS command aliases

These short Fish aliases live in `config/terminal.nix` and point at your flake under `~/axchios` (hostname is set per machine in `hosts/`):

| Alias | What it does |
|-------|----------------|
| `fr` | **F**lake **r**ebuild — apply your current config (`nh os switch` for this host, no input update) |
| `fu` | **F**lake **u**pdate — update flake inputs, then rebuild and switch (`nh os switch --update`) |
| `ncg` | **N**ix **c**ollect **g**arbage — remove old generations (user + system), then refresh the boot profile |
| `nixrepair` | Verify the Nix store and repair corrupted paths (`nix-store --verify --check-contents --repair`) |

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
   
   - `axchi-nix-desktop`: Example configuration for desktop 
   - `axchi-nix-laptop`: Example configuration for laptop 
   
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
- `SUPER + N`: Switch to empty workspace (global; may jump to another monitor)
- `SUPER + ALT + N`: Open a new workspace on the focused monitor (always creates a fresh workspace; does not reuse an empty one)
- `SUPER + ALT + SHIFT + N`: Move the focused window to an empty workspace on the focused monitor (reuses an empty workspace on that monitor when one exists, otherwise creates one)
- `SUPER + ALT + SHIFT + Return`: Scatter windows — move every window of the focused app's class on the current workspace to its own workspace on the same monitor
- `SUPER + ALT + SHIFT + SPACE`: Scatter to empty monitors — move windows of the same app on the current workspace to distinct monitors that have no windows (one per monitor; never creates new workspaces)
- `ALT + Tab`: Cycle through windows

### Mouse Bindings
- `SUPER + Left Mouse Button`: Move window
- `SUPER + Right Mouse Button`: Resize window

### Touchpad Gestures
- **4-finger horizontal swipe**: Switch workspaces (left/right)
- **2-finger drag**: Move the active window (same as `SUPER + Left Mouse Button`)
- **3-finger drag**: Resize the active window (same as `SUPER + Right Mouse Button`)

## Special thanks:

  - Thanks to Zaney and ZaneyOS for providing the base for this project
