{
  pkgs,
  inputs,
  system
}:
let
  fenixPkgs = inputs.fenix.packages.${system};

  # Latest release toolchain (or use .beta.toolchain / .default.toolchain for nightly)
  toolchain = fenixPkgs.stable.toolchain;

  # Pin by date (e.g., 2025-09-18) if you want reproducibility:
  # toolchain = (inputs.fenix.packages.${system}.toolchainOf { date = "2025-09-18"; channel = "nightly"; }).toolchain;

  rustAnalyzer = fenixPkgs.rust-analyzer;
in
pkgs.devshell.mkShell {
  name = "rust";

  packages = [
    toolchain
    rustAnalyzer
    pkgs.pkg-config
    pkgs.openssl
    pkgs.cmake
    pkgs.python3
  ];

  commands = [
    { name = "check"; command = "cargo check";                 help = "Type-check the workspace"; }
    { name = "test";  command = "cargo test";                  help = "Run tests"; }
    { name = "fmt";   command = "cargo fmt";                   help = "Format code"; }
    { name = "lint";  command = "cargo clippy -- -D warnings"; help = "Clippy lint (deny warnings)"; }
  ];
}
