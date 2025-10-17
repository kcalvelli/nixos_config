# Simple version that uses host config files but explicit mapping
{ inputs, self, lib, ... }:
let
  # Load host configurations
  edgeCfg = (import ./edge.nix { inherit lib; }).hostConfig;
  pangolinCfg = (import ./pangolin.nix { inherit lib; }).hostConfig;
  
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
        ++ lib.optional (hostCfg.hardware.vendor == "msi") msi
        ++ lib.optional (hostCfg.hardware.vendor == "system76") system76;
      
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
          ];
        in
        lib.mkMerge [
          {
            networking.hostName = hostCfg.hostname;
            
            # Hardware vendor modules are imported in ourModules above
            # They will be enabled via their respective host configs if needed
            # (e.g., edge.nix can set hardware.msi.enable in extraConfig)
            
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
    edge = mkSystem edgeCfg;
    pangolin = mkSystem pangolinCfg;
    
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
    # 1. Create hosts/newhostname.nix with hostConfig
    # 2. Add: newhostname = mkSystem (import ./newhostname.nix { inherit lib; }).hostConfig;
  };
}
