{ /* wrapper file that returns the LazyVim home-manager module
     This file is meant as a pattern for other inputs: create
     home/inputs/<name>/default.nix with the same structure and
     update `home/default.nix` to include `./inputs/<name>`.
*/ }:

let
  # Replace the URL below with a pinned flake if you want reproducibility.
  lazy = builtins.getFlake "github:pfassina/lazyvim-nix";
in
  # Return the home-manager module provided by the remote flake
  lazy.homeManagerModules.default
