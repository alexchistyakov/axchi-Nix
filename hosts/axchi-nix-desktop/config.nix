{
  lib,
  username,
  config,
  pkgs,
  host,
  inputs,
  options,
  ...
}:
let
  variables = import ./variables.nix;
  inherit (variables) keyboardLayout;
  rice = import ../../rice { inherit lib config username pkgs variables; };
in
{
  # ========= MOVE TO config/core/system.nix =========
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
    ../../config/vm.nix
  ];

  nixpkgs.config.allowBroken = true;
  nixpkgs.config.cudaSupport = true;
  nixpkgs.config.allowUnfree = true;

  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    consoleLogLevel = 3;
    kernelModules = [ 
      "v4l2loopback"
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];
    initrd = {
      verbose = false;  # Reduce boot messages
      systemd.enable = true;  # Use systemd in initrd
    };
    kernelParams = [
      "quiet"
      "loglevel=3"
    ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    plymouth = {
      enable = false;
    };
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Bootloader.
    loader.grub = { 
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      theme = rice.grub.theme;
      gfxmodeEfi = "1920x1080, auto";
      font = rice.grub.font;
      fontSize = rice.grub.fontSize;
      extraEntries = ''
        menuentry "macOS" --class macosx {
          insmod chain
          insmod fat
          insmod part_gpt
          insmod search_fs_uuid
          
          search --fs-uuid --no-floppy --set=root 67E3-17ED 
          chainloader ($root)/EFI/OC/OpenCore.efi
        }
      '';
    };

    loader.efi = { 
      canTouchEfiVariables = true;
    };
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };

  # Styling Options
  stylix = rice.stylix;

  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = host;
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs = {
    starship = {
      enable = true;
      settings = rice.starship.settings;
    };
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  users = {
    mutableUsers = true;
  };

  environment.systemPackages = with pkgs; 
    let
      ricePackagesList = rice.packages;
    in
    ricePackagesList ++ [
    # Existing packages
    vim
    wget
    killall
    eza
    git
    cmatrix
    lolcat
    htop
    #libvirt
    #virt-viewer
    lxqt.lxqt-policykit
    lm_sensors
    unzip
    unrar
    libnotify
    v4l-utils
    ydotool
    duf
    ncdu
    wl-clipboard
    pciutils
    ffmpeg
    socat
    cowsay
    ripgrep
    lshw
    bat
    pkg-config
    meson
    hyprpicker
    ninja
    brightnessctl
    swappy
    appimage-run
    networkmanagerapplet
    yad
    inxi
    playerctl
    nh
    nixfmt-rfc-style
    discord
    grim
    slurp
    file-roller
    imv
    mpv
    gimp
    pavucontrol
    tree
    spotify
    neovide
    albert
    code-cursor
    google-chrome
    fish
    tigervnc
    hyprpaper
    hyprlang
    conda
    alacritty
    papirus-icon-theme
    guestfs-tools
    windsurf
    telegram-desktop
    nodejs
    kdePackages.kolourpaint
    solaar
    mission-center 
    godot
  ];

  environment.variables = {
    AXCHIOS_VERSION = "0.0.1";
    AXCHIOS = "true";
    #CUDA_NVCC_ALLOW_UNSUPPORTED_COMPILER = "1";
  };

  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  # Services to start
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "${keyboardLayout}";
        variant = "";
      };
    };
    displayManager = {
      autoLogin = {
        enable = true;
        user = "${username}";
      };
      sessionPackages = [
        inputs.hyprland.packages.${pkgs.system}.hyprland
      ];
      defaultSession = "hyprland";
    };
    #greetd = {
    #  enable = true;
    #  vt = 3;
    #  settings = #{
    #    default_session = {
    #      command = "Hyprland";
    #      user = "${username}";
    #    };
    #    initial_session = {
    #      command = "Hyprland";
    #      user = "${username}";
    #    };
    #  };
    #};
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
      };
    };
    smartd = {
      enable = false;
      autodetect = true;
    };
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    flatpak.enable = false;
    printing = {
      enable = true;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    syncthing = {
      enable = false;
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    rpcbind.enable = false;
    nfs.server.enable = false;
  };
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # Extra Logitech Support
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Bluetooth Support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;

  # AMD CPU stuff
  hardware.cpu.amd.updateMicrocode = true;
  powerManagement.cpuFreqGovernor = "performance";

  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.retrueboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      cores = 0;
      max-jobs = "auto";
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
  };

  console.keyMap = "${keyboardLayout}";
  # ====================================================================

  # Extra Module Options
  drivers.amdgpu = {
    enable = true;
    enableVulkan = true;
    enableOpenCL = true;
    optimizePerformance = true;
  };
  
  drivers.nvidia = {
    enable = true;
    maxPerformance = false;
  };
  drivers.nvidia-prime = {
    enable = false;
    intelBusID = "";
    nvidiaBusID = "";
  };
  drivers.intel.enable = false;
  # End of module options
  


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
