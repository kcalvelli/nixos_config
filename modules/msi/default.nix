 
{ inputs, config, pkgs, ... }:
{
  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = false;
    opengl = {
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
        vaapiVdpau
        libvdpau-va-gl
      ];
      driSupport = true;
      #driSupport32Bit = true;
    };
  };

  boot = {
    # Kernel
    kernelParams = [
      "quiet" "iommu=pt"   
    ];
    kernelModules = [ "amdgpu" ];

    initrd = {
      # Setup keyfile
      secrets = {
        "/crypto_keyfile.bin" = null;
      };
      systemd.enable = true;
      kernelModules = [ "amdgpu"];
    };
  };
}
