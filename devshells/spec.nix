{
  pkgs,
  inputs,   # <- this is inputs'
  system
}:
let
  mkShell = inputs.devshell.legacyPackages.${system}.mkShell;
in
mkShell {
  name = "spec-kit";
  packages = [ pkgs.python311 pkgs.uv pkgs.git pkgs.gh pkgs.nodejs_20 ];
  commands = [
    { name = "specify";    help = "Run GitHub Spec Kit CLI via uvx";
      command = ''uvx --from git+https://github.com/github/spec-kit.git specify "$@"''; }
    { name = "spec-check"; help = "Check Spec Kit prerequisites"; command = "specify check"; }
  ];
  env = { PIP_DISABLE_PIP_VERSION_CHECK = "1"; UV_NO_SYNC = "1"; };
}
