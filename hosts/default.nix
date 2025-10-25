# Simple version that uses host config files but explicit mapping
{ inputs, self, lib, ... }:
let
  # Load host configurations
  # Add your host configurations here:
  # myHostCfg = (import ./myhost.nix { inherit lib; }).hostConfig;
  
  # Helper to build nixos-hardware modules
  hardwareModules = hw:
    let
      hwMods = inputs.nixos-hardware.nixosModules;
    in
      lib.optional (hw.cpu or null == "amd") hwMods.common-cpu-amd
      ++ lib.optional (hw.cpu or null == "intel") hwMods.common-cpu-intel
      ++ lib.optional (hw.gpu or null == "amd") hwMods.common-gpu-amd
      ++ lib.optional (hw.gpu or null == "nvidia") hwMods.common-gpu-nvidia
      ++ lib.optional (hw.hasSSD or false) hwMods.common-pc-ssd
      ++ lib.optional (hw.isLaptop or false) hwMods.common-pc-laptop;
  
  # Helper to build module list for a host
  buildModules = hostCfg:
    let
      baseModules = [
        inputs.disko.nixosModules.disko
        inputs.niri.nixosModules.niri
        inputs.dankMaterialShell.nixosModules.greeter
        inputs.home-manager.nixosModules.home-manager
        inputs.determinate.nixosModules.default
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.vscode-server.nixosModules.default
      ];
      
      hwModules = hardwareModules hostCfg.hardware;
      
      ourModules = with self.nixosModules;
        lib.optional (hostCfg.modules.system or true) system
        ++ lib.optional (hostCfg.modules.desktop or false) desktop
        ++ lib.optional (hostCfg.modules.development or false) development
        ++ lib.optional (hostCfg.modules.services or false) services
        ++ lib.optional (hostCfg.modules.graphics or false) graphics
        ++ lib.optional (hostCfg.modules.networking or true) networking
        ++ lib.optional (hostCfg.modules.users or true) users
        ++ lib.optional (hostCfg.modules.virt or false) virt
        ++ lib.optional (hostCfg.modules.gaming or false) gaming
        # Hardware modules based on form factor and vendor
        ++ lib.optional (hostCfg.hardware.vendor == "msi") desktopHardware
        ++ lib.optional (hostCfg.hardware.vendor == "system76") laptopHardware
        # Generic hardware based on form factor (if no specific vendor)
        ++ lib.optional (
          (hostCfg.hardware.vendor or null == null) &&
          (hostCfg.formFactor or "" == "desktop")
        ) desktopHardware
        ++ lib.optional (
          (hostCfg.hardware.vendor or null == null) &&
          (hostCfg.formFactor or "" == "laptop")
        ) laptopHardware;
      
      hostModule = { config, lib, ... }: 
        let
          hwVendor = hostCfg.hardware.vendor or null;
          profile = hostCfg.homeProfile or "workstation";
          extraCfg = hostCfg.extraConfig or {};
          
          # Build dynamic config based on what's defined in hostCfg
          # Only include virt/services if the respective modules are enabled AND the config exists
          dynamicConfig = lib.mkMerge [
            # Always include extraConfig first
            extraCfg
            # Add virt config only if module is enabled and config exists
            (lib.optionalAttrs ((hostCfg.modules.virt or false) && (hostCfg ? virt)) {
              virt = hostCfg.virt;
            })
            # Add services config only if module is enabled and config exists  
            (lib.optionalAttrs ((hostCfg.modules.services or false) && (hostCfg ? services)) {
              services = hostCfg.services;
            })
            # Enable desktop hardware module if vendor is msi
            (lib.optionalAttrs (hwVendor == "msi") {
              hardware.desktop = {
                enable = true;
                enableMsiSensors = true;
              };
            })
            # Enable laptop hardware module if vendor is system76
            (lib.optionalAttrs (hwVendor == "system76") {
              hardware.laptop = {
                enable = true;
                enableSystem76 = true;
                enablePangolinQuirks = true; # Assuming Pangolin 12
              };
            })
          ];
        in
        lib.mkMerge [
          {
            networking.hostName = hostCfg.hostname;
            
            # Hardware vendor modules are imported in ourModules above
            # Desktop hardware is auto-enabled for desktop form factor or specific vendors
            
            home-manager.sharedModules = 
              if profile == "workstation" then [ self.homeModules.workstation ]
              else if profile == "laptop" then [ self.homeModules.laptop ]
              else [];
          }
          dynamicConfig
        ];
      
      diskModule = 
        if hostCfg ? diskConfigPath 
        then hostCfg.diskConfigPath
        else { 
          # Default: No disk configuration
          # User must provide diskConfigPath or define fileSystems in extraConfig
          imports = [];
        };
    in
      baseModules ++ hwModules ++ ourModules ++ [ hostModule diskModule ];
  
  # Helper to create a system config
  mkSystem = hostCfg: inputs.nixpkgs.lib.nixosSystem {
    system = hostCfg.system or "x86_64-linux";
    specialArgs = {
      inherit inputs self;
      inherit (self) nixosModules homeModules;
    };
    modules = buildModules hostCfg;
  };
  
  # Minimal installer configuration
  installerModules = [
    inputs.disko.nixosModules.disko
    ./installer
  ];
in
{
  flake.nixosConfigurations = {
    # Add your host configurations here:
    # Example:
    # myhost = mkSystem myHostCfg;
    
    # Installer ISO
    installer = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs self;
        inherit (self) nixosModules homeModules;
      };
      modules = installerModules;
    };
    
    # To add a new host:
    # 1. Create hosts/newhostname.nix with hostConfig (use TEMPLATE.nix or EXAMPLE-*.nix)
    # 2. Import it above: myHostCfg = (import ./myhost.nix { inherit lib; }).hostConfig;
    # 3. Add here: myhost = mkSystem myHostCfg;
  };
}
