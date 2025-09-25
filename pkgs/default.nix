{
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      system,
      pkgs,
      ...
    }:
    {
      packages = {
        inherit (pkgs)
          brave-browser-nightly
          networkmanagerapplet
          cosmic-ext-applet-clipboard-manager
          ;
      };

      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [ self.overlays.default ];
      };
    };

  flake.overlays.default = final: prev: {
    # Custom packages
    brave-browser-nightly = prev.callPackage ./brave-browser-nightly { };
    networkmanagerapplet = prev.callPackage ./networkmanagerapplet { };
    cosmic-ext-applet-clipboard-manager = prev.callPackage ./cosmic-ext-applet-clipboard-manager { };
  };
}
