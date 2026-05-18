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
  variables = import ../../hosts/${host}/variables.nix;
  inherit (variables) keyboardLayout;
  rice = import ../../rice { inherit lib config username pkgs variables; };
in
{
  imports = [
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  nixpkgs.config.allowBroken = true;
  nixpkgs.config.cudaSupport = true;
  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    consoleLogLevel = 3;
    kernelModules = [
      "v4l2loopback"
    ];
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    kernelParams = [
      "quiet"
      "loglevel=3"
    ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    plymouth.enable = false;
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    loader = {
      timeout = -1;
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
        theme = rice.grub.theme;
        gfxmodeEfi = "1920x1080, auto";
        font = rice.grub.font;
        fontSize = rice.grub.fontSize;
      };
      efi.canTouchEfiVariables = true;
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };

  stylix = rice.stylix;

  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  networking.networkmanager.enable = true;
  networking.hostName = host;
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  time.timeZone = "America/Denver";

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
    obs-studio = {
      enable = false;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];
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
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
      ];
    };
  };

  users.mutableUsers = true;

  environment.systemPackages = with pkgs;
    let
      ricePackagesList = rice.packages;
    in
    ricePackagesList ++ [
      vim
      wget
      killall
      eza
      git
      cmatrix
      lolcat
      htop
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
      nixfmt
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
      zoom
      slack
      audacity
      zip
      graphviz
      libreoffice
      freerdp
      remmina
      gnumake
      awscli2
      uv
      openrgb-with-all-plugins
      databricks-cli
    ];

  environment.variables = {
    AXCHIOS_VERSION = "0.0.1";
    AXCHIOS = "true";
    NIXOS_OZONE_WL = "1";
  };

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

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "${keyboardLayout}";
        variant = "";
      };
    };
    xrdp = {
      enable = true;
      defaultWindowManager = "startplasma-x11";
      openFirewall = true;
    };
    gnome.gnome-remote-desktop.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "${username}";
      };
      sessionPackages = [
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
      ];
      defaultSession = "hyprland";
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
    pulseaudio.enable = false;
    rpcbind.enable = false;
    nfs.server.enable = false;
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };
    blueman.enable = true;
  };

  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      disabledDefaultBackends = [ "escl" ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

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
  security.pam.services.swaylock.text = ''
    auth include login
  '';

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

  console.keyMap = "${keyboardLayout}";

  system.stateVersion = "23.11";
}
