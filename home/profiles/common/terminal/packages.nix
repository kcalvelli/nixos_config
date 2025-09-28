{ 
  config, 
  pkgs, 
  lib, 
  ... 
}:
let
  nodePkgs = pkgs.nodePackages;
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    rust-analyzer
    pyright
    nodePkgs.typescript-language-server
    nodePkgs.vscode-langservers-extracted
    eslint
    nixd
    zls
    lua-language-server
    rustfmt
    black isort
    nodePkgs.prettier
    stylua
    shfmt
    nixfmt-rfc-style
    ripgrep
    fd
  ];
}
