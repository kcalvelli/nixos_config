{ inputs
, pkgs
, ...
}:
# Include AI development tools from nix-ai-tools
{
  environment.systemPackages = with inputs.nix-ai-tools.packages.${pkgs.system}; [
    copilot-cli
  ];
}
