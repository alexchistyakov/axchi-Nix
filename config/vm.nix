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
        package = pkgs.qemu;
        ovmf = {
          enable = true;
          packages = with pkgs; [
            OVMFFull.fd
          ];
        };
      };
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
    spiceUSBRedirection.enable = true;
  };
  
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;

  # Required system packages for VM management
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    virtiofsd
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    swtpm
    OVMFFull
  ];

  # Add user to required groups
  users.groups.libvirtd.members = [ "root" config.users.users.${config.users.users.axchi.name}.name ];
  users.groups.kvm.members = [ "root" config.users.users.${config.users.users.axchi.name}.name ];

  # Enable dconf - required for saving virt-manager settings
  programs.dconf.enable = true;

  # Enable IOMMU
  boot.kernelParams = [
    "amd_iommu=on"  # Use intel_iommu=on if you have an Intel CPU
    #"vfio-pci.ids=10de:2786,10de:22bc"  # NVIDIA RTX 4070 GPU and its audio controller
    #"video=efifb:off"  # Disable EFI framebuffer to prevent conflicts
  ];

  boot.kernelModules = [
    "kvm-amd"
  ];

  # Load VFIO related modules
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

} 
