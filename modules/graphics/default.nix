{
  pkgs,
  inputs,
  ...
}:
{
  # Import necessary modules
  imports = [ inputs.nixos-hardware.nixosModules.common-gpu-amd ];

  # Hardware configuration
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        libva
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    amdgpu = {
      initrd.enable = true;
      overdrive.enable = true;
    };
  };

  # Boot parameters for optimal AMD GPU performance
  boot = {
    kernelParams = [
      "amdgpu.dc=1" # Enable Display Core
      "amdgpu.gpu_recovery=1" # Better stability
      "amdgpu.vm_update_mode=0" # Performance optimization
    ];
  };

  # System packages for graphics
  environment.systemPackages = with pkgs; [
    # GPU monitoring and management
    radeontop
    corectrl
    lact
    amdgpu_top
    clinfo

    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    mesa-demos
    wayland-utils

    rocmPackages.clr
    rocmPackages.rocminfo
  ];

  environment.variables = {
    HIP_PLATFORM = "amd";
  };

  # Linux AMDGPU Controller
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];
}
