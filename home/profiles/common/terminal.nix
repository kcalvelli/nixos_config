{
  pkgs,
  ...
}:
{
  programs = {
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-airline ];
      settings = {
        ignorecase = true;
      };
      extraConfig = ''
        set mouse=v
      '';
    };

    git = {
      enable = true;
    };

    ghostty = {
      enable = true;
      enableFishIntegration = true;
      installVimSyntax = true;
      settings = {
        background = "#080c12";
        foreground = "#e0e4e9";
        cursor-color = "#2a3a4e";
        selection-background = "#2a3a4e";
        selection-foreground = "#e0e4e9";
        font-family = "FiraCode Nerd Font Mono";
        font-size = 12;
        palette = [
          "0=#080c12"
          "1=#e06c75"
          "2=#98c379"
          "3=#e5c07b"
          "4=#61afef"
          "5=#c678dd"
          "6=#56b6c2"
          "7=#e0e4e9"
          "8=#9ca4ae"
          "9=#ff7b86"
          "10=#a3d48a"
          "11=#f0d08c"
          "12=#72c0ff"
          "13=#d789ff"
          "14=#67c7d3"
          "15=#ffffff"
        ];
      };
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = true;
        format = ''
          [╭─](bold #2a3a4e)$username[@](bold #e0e4e9)$hostname[:](bold #2a3a4e)$directory$git_branch$git_status
          [╰─➤ ](bold #2a3a4e)$character
        '';
        character = {
          success_symbol = "[➜](bold #e0e4e9)";
          error_symbol = "[➜](bold #9ca4ae)";
        };
        username = {
          style_user = "bold #e0e4e9";
          style_root = "bold #9ca4ae";
          format = "[$user]($style)";
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          style = "bold #e0e4e9";
          format = "[$hostname]($style)";
        };
        directory = {
          style = "bold #1c252f";
          truncation_length = 3;
          truncate_to_repo = true;
          format = "[ $path ]($style)";
        };
        git_branch = {
          style = "bold #e0e4e9";
          format = "[ $symbol$branch ]($style)";
          symbol = " ";
        };
        git_status = {
          style = "bold #9ca4ae";
          format = "[$all_status$ahead_behind]($style) ";
        };
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        direnv hook fish | source
      '';
      plugins = [
        # {
        #   name = "grc";
        #   src = pkgs.fishPlugins.grc.src;
        # }
        # { name = "github-copilot-cli-fish"; src = pkgs.fishPlugins.github-copilot-cli-fish.src; }
      ];
    };
  };

  # Additional packages can be added here
  # home.packages = with pkgs; [ grc ];
}
