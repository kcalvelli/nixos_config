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
  programs.git = {
    enable = true;
  };

  # Additional packages can be added here
  # home.packages = with pkgs; [ grc ];

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    installVimSyntax = true;
    settings = {
      background = "#080c12"; # BackgroundNormal
      foreground = "#e0e4e9"; # ForegroundNormal
      cursor-color = "#2a3a4e"; # DecorationFocus
      selection-background = "#2a3a4e"; # Selection BackgroundNormal
      selection-foreground = "#e0e4e9"; # ForegroundNormal
      font-family = "FiraCode Nerd Font Mono";
      font-size = 12;
      # ANSI color palette (16 colors)
      palette = [
        "0=#080c12"  # Black (background)
        "1=#e06c75"  # Red (adjusted for contrast)
        "2=#98c379"  # Green (adjusted for contrast)
        "3=#e5c07b"  # Yellow (adjusted for contrast)
        "4=#61afef"  # Blue (adjusted for contrast)
        "5=#c678dd"  # Magenta (adjusted for contrast)
        "6=#56b6c2"  # Cyan (adjusted for contrast)
        "7=#e0e4e9"  # White (foreground)
        "8=#9ca4ae"  # Bright Black (inactive foreground)
        "9=#ff7b86"  # Bright Red (adjusted)
        "10=#a3d48a" # Bright Green (adjusted)
        "11=#f0d08c" # Bright Yellow (adjusted)
        "12=#72c0ff" # Bright Blue (adjusted)
        "13=#d789ff" # Bright Magenta (adjusted)
        "14=#67c7d3" # Bright Cyan (adjusted)
        "15=#ffffff" # Bright White
      ];
    };
  };

  programs.starship = {
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
    ];
  };
}