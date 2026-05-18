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
  ];

  # ===== Hardware-specific kernel params =====
  boot.kernelParams = [
    # Required for NVIDIA suspend/resume to preserve framebuffer
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  # ===== GPU / driver tailoring =====
  drivers.amdgpu.enable = false;
  drivers.nvidia = {
    enable = true;
    maxPerformance = false;
  };
  drivers.nvidia-prime = {
    enable = true;
    intelBusID = "PCI:0:2:0";
    nvidiaBusID = "PCI:1:0:0";
  };
  drivers.intel.enable = true;

  # ===== Security: do not auto-login on a portable device =====
  services.displayManager.autoLogin.enable = lib.mkForce false;

  # ===== Power management =====
  # TLP only (auto-cpufreq would fight it for governor control).
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      # Uncomment to extend battery lifespan (caps charge at 80%).
      # Many laptops only honor BAT0; check your hardware via `tlp-stat -b`.
      # START_CHARGE_THRESH_BAT0 = 40;
      # STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # Intel thermal management daemon — useful on Intel laptops to avoid
  # aggressive throttling under sustained load.
  services.thermald.enable = true;

  # Firmware updates via `fwupdmgr refresh && fwupdmgr update`.
  services.fwupd.enable = true;
}
