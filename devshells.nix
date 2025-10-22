# devshell.nix
{ inputs, ... }: {
  perSystem = { pkgs, system, lib, ... }:
    {
      devShells = {
        spec = import ./devshells/spec.nix { inherit pkgs inputs system; };
        rust = import ./devshells/rust.nix { inherit pkgs inputs system; };
        zig = import ./devshells/zig.nix { inherit pkgs inputs system; };
        qml = import ./devshells/qml.nix { inherit pkgs inputs system; };

        # Pick whichever one you want as default
        default = lib.mkDefault (import ./devshells/spec.nix { inherit pkgs inputs system; });
      };
    };
}
