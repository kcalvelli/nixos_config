 
{ inputs, config, pkgs, ... }:
{
  hardware = {
    system76.enableAll = true;
    bluetooth.enable = true;
    pulseaudio.enable = false;
    opengl = {
      enabled = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
        vaapiVdpau
        libvdpau-va-gl
      ];
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  boot = {
    # Kernel
    kernelParams = [
      "quiet" "i8042.noaux" "iommu=pt" "amdgpu.noretry=0" "amdgpu.lockup_timeout=1000" "amdgpu.gpu_recovery=1" "ahci.mobile_lpm_policy=3"  
    ];
    kernelModules = [ "amdgpu" ];
    blacklistedKernelModules = [ "psmouse" ];

    initrd = {
      # Setup keyfile
      secrets = {
        "/crypto_keyfile.bin" = null;
      };
      systemd.enable = true;
      kernelModules = [ "amdgpu"];
    };
  };

  nixpkgs = {
    config = {
      permittedInsecurePackages = [
        "python-2.7.18.6"
      ];
    };
  };
}
