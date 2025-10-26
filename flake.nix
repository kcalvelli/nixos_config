{
  description = "Personal NixOS configurations based on axiOS";

  inputs = {
    # Use axios as the base framework
    # Track master branch for latest changes
    axios = {
      url = "github:kcalvelli/axios/master";
    };
    
    # Follow axios's nixpkgs to ensure compatibility
    nixpkgs.follows = "axios/nixpkgs";
    
    # These are re-exported from axios, no need to declare separately
    # nixos-hardware, home-manager, disko, etc. come from axios
  };

  outputs = { self, axios, nixpkgs, ... }:
    let
      # User module path
      userModule = self.outPath + "/keith.nix";
      
      # Load host configurations  
      pangolinCfg = (import ./hosts/pangolin.nix { 
        lib = nixpkgs.lib;
        userModulePath = userModule;
      }).hostConfig;
      edgeCfg = (import ./hosts/edge.nix { 
        lib = nixpkgs.lib;
        userModulePath = userModule;
      }).hostConfig;
    in
    {
      nixosConfigurations = {
        pangolin = axios.lib.mkSystem pangolinCfg;
        edge = axios.lib.mkSystem edgeCfg;
      };
    };
}
