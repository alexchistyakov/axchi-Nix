{
  config,
  pkgs,
  lib,
  ...
}: {
  # Enable virtualization services
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
    spiceUSBRedirection.enable = true;
  };

  # Required system packages for VM management
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    swtpm
    OVMF
  ];

  # Add user to required groups
  users.groups.libvirtd.members = [ "root" config.users.users.${config.users.users.axchi.name}.name ];
  users.groups.kvm.members = [ "root" config.users.users.${config.users.users.axchi.name}.name ];

  # Enable dconf - required for saving virt-manager settings
  programs.dconf.enable = true;

  # Add necessary kernel modules
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
} 