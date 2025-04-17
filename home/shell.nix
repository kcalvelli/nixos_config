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

  # Enable and configure Starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # Enable and configure Fish shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      direnv hook fish | source
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      # {
      #   name = "grc";
      #   src = pkgs.fishPlugins.grc.src;
      # }
      # { name = "github-copilot-cli-fish"; src = pkgs.fishPlugins.github-copilot-cli-fish.src; }

      # Manually packaging and enable a plugin
    ];
    # shellInit = ''
    #   set -gx NPM_CONFIG_PREFIX "$HOME/.npm-global"
    #   fish_add_path "$HOME/.npm-global/bin"
    # '';
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
