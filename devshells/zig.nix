# devshells/zig.nix
{
  pkgs,
  inputs,
  system
}:
let
  # If you're using the overlay (mitchellh/zig-overlay)
  zigPkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ inputs."zig-overlay".overlays.default ];
  };
in
pkgs.devshell.mkShell {
  name = "zig";
  packages = [
    zigPkgs.zig
    pkgs.zls
    pkgs.cmake
    pkgs.pkg-config
  ];
  commands = [
    { name = "build"; command = "zig build";      help = "Build project"; }
    { name = "run";   command = "zig build run";  help = "Run default target"; }
  ];
}
