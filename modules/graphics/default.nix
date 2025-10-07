{ pkgs, ... }:
{
  # --- GPU / Graphics ---
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa          # OpenGL + RADV Vulkan for AMD
        libva         # VA-API
        vulkan-loader # Core Vulkan ICD loader (harmless to keep)
      ];
    };

    amdgpu = {
      initrd.enable = true;
      # overdrive.enable = true;   # enable only if you actually use it
    };
  };

  # --- Kernel params (minimal + stable) ---
  boot.kernelParams = [
    "amdgpu.gpu_recovery=1"  # good stability safety net
  ];

  # --- Tools you actually use (no debug layers) ---
  environment.systemPackages = with pkgs; [
    radeontop
    corectrl
    lact
    amdgpu_top
    clinfo
    wayland-utils
    # vulkan-tools         # uncomment if you want vkcube/vulkaninfo for debugging
    # vulkan-validation-layers  # leave commented: can cause issues when globally active
    # mesa-demos               # optional OpenGL demos
    # rocmPackages.clr         # only if you need OpenCL/HIP compute
    # rocmPackages.rocminfo
  ];

  # --- Sensible defaults for GTK4 on Wayland ---
  environment.variables = {
    HIP_PLATFORM = "amd";
    GSK_RENDERER = "ngl";  # force GTK4 to OpenGL path (stable on wlroots/Hyprland)
  };

  # Gives CoreCtrl polkit integration (fan/clock controls without sudo)
  programs.corectrl.enable = true;
}
