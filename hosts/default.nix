# Simple version that uses host config files but explicit mapping
{ inputs, self, lib, ... }:
let
  inherit (lib) mapAttrs mkIf mkMerge optionals;

  # Load host configurations from simple data files.
  loadHostConfig = path: (import path { inherit lib; }).hostConfig;

  hostConfigs = {
    edge = loadHostConfig ./edge.nix;
    pangolin = loadHostConfig ./pangolin.nix;
  };

  # Helper to build nixos-hardware modules based on the provided hardware metadata.
  hardwareModules = hostCfg:
    let
      hw = hostCfg.hardware or {};
      hwMods = inputs.nixos-hardware.nixosModules;
    in
    optionals (hw.cpu or null == "amd") [ hwMods.common-cpu-amd ]
    ++ optionals (hw.cpu or null == "intel") [ hwMods.common-cpu-intel ]
    ++ optionals (hw.gpu or null == "amd") [ hwMods.common-gpu-amd ]
    ++ optionals (hw.gpu or null == "nvidia") [ hwMods.common-gpu-nvidia ]
    ++ optionals (hw.hasSSD or false) [ hwMods.common-pc-ssd ]
    ++ optionals (hw.isLaptop or false) [ hwMods.common-pc-laptop ];

  includeModule = cond: module: optionals cond [ module ];

  # Helper to build module list for a host
  buildModules = hostCfg:
    let
      modulesCfg = hostCfg.modules or {};
      hardware = hostCfg.hardware or {};

      baseModules = [
        inputs.disko.nixosModules.disko
        inputs.niri.nixosModules.niri
        inputs.dankMaterialShell.nixosModules.greeter
        inputs.home-manager.nixosModules.home-manager
        inputs.determinate.nixosModules.default
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.vscode-server.nixosModules.default
      ];

      ourModules = with self.nixosModules;
        includeModule (modulesCfg.system or true) system
        ++ includeModule (modulesCfg.desktop or false) desktop
        ++ includeModule (modulesCfg.development or false) development
        ++ includeModule (modulesCfg.services or false) services
        ++ includeModule (modulesCfg.graphics or false) graphics
        ++ includeModule (modulesCfg.networking or true) networking
        ++ includeModule (modulesCfg.users or true) users
        ++ includeModule (modulesCfg.virt or false) virt
        ++ includeModule (modulesCfg.gaming or false) gaming
        ++ includeModule (hardware.vendor == "msi") desktopHardware
        ++ includeModule (hardware.vendor == "system76") laptopHardware
        ++ includeModule (
          (hardware.vendor or null == null) && (hostCfg.formFactor or "" == "desktop")
        ) desktopHardware
        ++ includeModule (
          (hardware.vendor or null == null) && (hostCfg.formFactor or "" == "laptop")
        ) laptopHardware;

      hostModule = { config, lib, ... }:
        let
          profile = hostCfg.homeProfile or "workstation";
        in
        mkMerge [
          {
            networking.hostName = hostCfg.hostname;
            home-manager.sharedModules =
              if profile == "workstation" then [ self.homeModules.workstation ]
              else if profile == "laptop" then [ self.homeModules.laptop ]
              else [];
          }
          hostCfg.extraConfig or {}
          (mkIf ((modulesCfg.virt or false) && (hostCfg ? virt)) {
            virt = hostCfg.virt;
          })
          (mkIf ((modulesCfg.services or false) && (hostCfg ? services)) {
            services = hostCfg.services;
          })
          (mkIf (hardware.vendor == "msi") {
            hardware.desktop = {
              enable = true;
              enableMsiSensors = true;
            };
          })
          (mkIf (hardware.vendor == "system76") {
            hardware.laptop = {
              enable = true;
              enableSystem76 = true;
              enablePangolinQuirks = true; # Assuming Pangolin 12
            };
          })
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
    baseModules ++ (hardwareModules hostCfg) ++ ourModules ++ [ hostModule diskModule ];

  # Helper to create a system config
  mkSystem = _: hostCfg: inputs.nixpkgs.lib.nixosSystem {
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
  flake.nixosConfigurations =
    mapAttrs mkSystem hostConfigs // {
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
      # 2. Add an entry to `hostConfigs` above.
    };
}
