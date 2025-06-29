{
  pkgs,
  inputs,
  ...
}: {
  # Enable and configure Vim
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [vim-airline];
    settings = {
      ignorecase = true;
    };
    extraConfig = ''
      set mouse=v
    '';
  };

  # Enable Git
  programs.git.enable = true;

  # Additional packages can be added here
  # home.packages = with pkgs; [ grc ];

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    installVimSyntax = true;
    settings = {
      theme = "tokyonight";
      background = "#080C12";
      font-family = "FiraCode Nerd Font Mono";
      font-size = 12;
    };
  };
}