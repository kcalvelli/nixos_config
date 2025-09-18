# devshell.nix
{ lib, ... }: {
  perSystem = { pkgs, inputs, system, ... }: {
    devShells = {
      spec   = import ./devshells/spec.nix   { inherit pkgs inputs system; };
      rust   = import ./devshells/rust.nix   { inherit pkgs inputs system; };
      zig    = import ./devshells/zig.nix    { inherit pkgs inputs system; };
      python = import ./devshells/python.nix { inherit pkgs inputs system; };
      node   = import ./devshells/node.nix   { inherit pkgs inputs system; };

      # Pick whichever one you want as default
      default = lib.mkDefault (import ./devshells/python.nix { inherit pkgs inputs system; });
    };
  };
}
