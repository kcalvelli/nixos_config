# devshell.nix
{
  inputs,
  ...
}:
{
  # bring in numtide/devshell as a flake-parts module
  imports = [ inputs.devshell.flakeModule ];

  # define per-system dev shells
  perSystem =
    { pkgs, ... }:
    {
      # numtide/devshell uses `devshells` (flake-parts will expose `devShells`)
      devshells.default = {
        packages = with pkgs; [
          nixfmt-rfc-style
          statix
          deadnix
          nil # Nix LSP
          nvd # Nix closure diff viewer
          nix-output-monitor # pretty build output
          just # tiny task runner
        ];
      };
    };
}
