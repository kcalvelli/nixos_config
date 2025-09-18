{
  pkgs,
  inputs,   # <- this is inputs'
  system
}:
let
  mkShell     = inputs.devshell.legacyPackages.${system}.mkShell;
  fenixPkgs   = inputs.fenix.packages.${system};
  toolchain   = fenixPkgs.stable.toolchain;   # or .default.toolchain / toolchainOf { date = "..."; }
  rustAnalyzer = fenixPkgs.rust-analyzer;
in
mkShell {
  name = "rust";
  packages = [ toolchain rustAnalyzer pkgs.pkg-config pkgs.openssl pkgs.cmake pkgs.python3 ];
  commands = [
    { name = "check"; command = "cargo check";                 help = "Type-check"; }
    { name = "test";  command = "cargo test";                  help = "Run tests"; }
    { name = "fmt";   command = "cargo fmt";                   help = "Format code"; }
    { name = "lint";  command = "cargo clippy -- -D warnings"; help = "Clippy (deny warnings)"; }
  ];
}
