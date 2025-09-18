# devshells/rust.nix
{
  pkgs,
  inputs,   # this is inputs'
  system
}:
let
  mkShell   = inputs.devshell.legacyPackages.${system}.mkShell;
  fenixPkgs = inputs.fenix.packages.${system};
  toolchain = fenixPkgs.stable.toolchain;   # or .default.toolchain for nightly
in
mkShell {
  name = "rust";

  # IMPORTANT: do NOT add a separate rust-analyzer here if the toolchain includes it.
  packages = [
    toolchain
    pkgs.pkg-config
    pkgs.openssl
    pkgs.cmake
    pkgs.python3
  ];

  commands = [
    { name = "check"; command = "cargo check";                 help = "Type-check"; }
    { name = "test";  command = "cargo test";                  help = "Run tests"; }
    { name = "fmt";   command = "cargo fmt";                   help = "Format code"; }
    { name = "lint";  command = "cargo clippy -- -D warnings"; help = "Clippy (deny warnings)"; }
  ];
}
