{ pkgs
, inputs
, # <- this is inputs'
  system
}:
let
  mkShell = inputs.devshell.legacyPackages.${system}.mkShell;
  zigPkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ inputs."zig-overlay".overlays.default ];
  };
in
mkShell {
  name = "zig";
  packages = [ zigPkgs.zig pkgs.zls pkgs.cmake pkgs.pkg-config ];
  commands = [
    { name = "build"; command = "zig build"; help = "Build project"; }
    { name = "run"; command = "zig build run"; help = "Run default target"; }
  ];
}
