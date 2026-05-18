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
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../../config/core/system.nix
    ../../config/vm.nix
  ];

  # ===== Hardware-specific kernel modules / params =====
  boot.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
    "i2c-dev"
  ];

  # ===== Bootloader: extra OS chainload entries =====
  boot.loader.grub.extraEntries = ''
    menuentry "macOS" --class macosx {
      insmod chain
      insmod fat
      insmod part_gpt
      insmod search_fs_uuid

      search --fs-uuid --no-floppy --set=root 67E3-17ED
      chainloader ($root)/EFI/OC/OpenCore.efi
    }
  '';

  # ===== GPU / driver tailoring =====
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

  # ===== CPU vendor microcode =====
  hardware.cpu.amd.updateMicrocode = true;

  # ===== Power: desktop is always on AC, pin governor =====
  powerManagement.cpuFreqGovernor = "performance";

  # ===== Peripherals / motherboard =====
  hardware.i2c.enable = true;
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  services.udev.packages = [ pkgs.openrgb ];
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  # ===== Power management (desktop is always on AC) =====
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
    };
  };
}
