{ /* wrapper file that returns the LazyVim home-manager module */ }:

let
  lazy = builtins.getFlake "github:pfassina/lazyvim-nix";
in
  lazy.homeManagerModules.default
