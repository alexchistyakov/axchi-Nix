{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.drivers.amdgpu;
in
{
  options.drivers.amdgpu = {
    enable = mkEnableOption "Enable AMD Drivers";
    enableCompute = mkEnableOption "Enable AMD GPU compute capabilities";
    enableVulkan = mkEnableOption "Enable Vulkan support (including 32-bit)";
    enableOpenCL = mkEnableOption "Enable OpenCL support";
    optimizePerformance = mkEnableOption "Enable performance optimizations";
  };

  config = mkIf cfg.enable {
    # Basic AMD GPU setup
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    # Modern OpenGL/graphics setup (NixOS 24.11+ syntax)
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # For compatibility with older NixOS versions
    hardware.opengl = {
      enable = true;
      driSupport32Bit = cfg.enableVulkan;
      extraPackages = mkIf cfg.enableOpenCL (with pkgs; [ 
        rocmPackages.clr.icd
      ]);
    };

    # ROCm setup for compute capabilities
    systemd.tmpfiles.rules = mkIf cfg.enableCompute [
      # Enhanced symlink with more ROCm components
      "L+    /opt/rocm   -    -    -     -    ${pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [ rocblas hipblas clr ];
      }}"
      # Backward compatibility for existing software
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    # Performance optimizations
    boot.kernelParams = mkIf cfg.optimizePerformance [
      # Potential performance-related parameters for AMDGPU
      "amdgpu.ppfeaturemask=0xffffffff" # Enable all powerplay features
      "amdgpu.dpm=1"                    # Enable dynamic power management
      "amdgpu.dc=1"                     # Enable display core
      "amdgpu.deep_color=1"            # Enable deep color support
    ];

    # Install useful utilities for AMD GPU management
    environment.systemPackages = mkIf cfg.optimizePerformance (with pkgs; [
      radeontop     # Monitor GPU utilization
      clinfo        # OpenCL information
      vulkan-tools  # Vulkan utilities
      glxinfo       # OpenGL information
    ]);
  };
}