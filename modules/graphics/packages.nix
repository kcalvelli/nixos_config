{ pkgs }:
{
  # AMD GPU monitoring and management tools
  amd = with pkgs; [
    radeontop
    corectrl
    amdgpu_top
    clinfo
  ];

  # Wayland utilities
  wayland = with pkgs; [
    wayland-utils
  ];

  # Uncomment these groups as needed for debugging/development:
  
  # vulkan = with pkgs; [
  #   vulkan-tools         # vkcube, vulkaninfo
  #   vulkan-validation-layers
  # ];
  
  # opengl = with pkgs; [
  #   mesa-demos           # glxinfo, glxgears
  # ];
  
  # compute = with pkgs; [
  #   rocmPackages.clr     # OpenCL/HIP compute
  #   rocmPackages.rocminfo
  # ];
}
