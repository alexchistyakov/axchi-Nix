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
    # Required for OpenCL to work alongside NVIDIA suspend/resume
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

  # ===== Power management (battery + AC profiles) =====
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
    };
  };

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}
