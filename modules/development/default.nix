{
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Import necessary modules
  imports = [
    inputs.vscode-server.nixosModules.default
  ];

  # Define system packages for development
  environment.systemPackages = with pkgs; [
    # Editor and IDE tools
    vim
    vscode
    code-cursor

    # Nix development tools
    devenv
    nil # Nix LSP
    nixfmt-rfc-style

    # Shell and terminal tools
    starship
    fish
    bat # Better cat
    eza # Better ls
    ripgrep # Fast search
    fd # Better find
    jq # JSON processor
    fzf # Fuzzy finder

    # Version control
    github-desktop
    git-lfs

    # Build tools and compilers
    gcc
    gnumake
    cmake
    pkg-config

    # AI tools
    claude-code
  ];

  # Enable and configure development services
  services = {
    lorri.enable = true;
    vscode-server.enable = true;
  };

  # Configure development programs
  programs = {
    direnv.enable = true;

    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        core = {
          editor = "vim";
          autocrlf = "input";
        };
      };
    };

    # Configure starship prompt
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };
      };
    };

    # Configure fish shell
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -U fish_greeting # Disable greeting
        fish_vi_key_bindings # Use vi key bindings
      '';
    };

    # Launch Fish when interactive shell is detected
    bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
  };
}
