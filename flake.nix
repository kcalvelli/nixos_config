{
  description = "Personal NixOS configurations based on axiOS";

  inputs = {
    # Use axios as the base framework
    axios = {
      url = "path:/home/keith/Projects/axios";
      # Once tested: url = "github:kcalvelli/axios/flake-approach";
    };
    
    # Follow axios's nixpkgs to ensure compatibility
    nixpkgs.follows = "axios/nixpkgs";
    
    # These are re-exported from axios, no need to declare separately
    # nixos-hardware, home-manager, disko, etc. come from axios
  };

  outputs = { self, axios, nixpkgs, ... }:
    let
      # Load host configurations  
      pangolinCfg = (import ./hosts/pangolin.nix { 
        lib = nixpkgs.lib;
        userModulePath = self.outPath + "/modules/users";
      }).hostConfig;
      edgeCfg = (import ./hosts/edge.nix { 
        lib = nixpkgs.lib;
        userModulePath = self.outPath + "/modules/users";
      }).hostConfig;
    in
    {
      nixosConfigurations = {
        pangolin = axios.lib.mkSystem pangolinCfg;
        edge = axios.lib.mkSystem edgeCfg;
      };
    };
}
