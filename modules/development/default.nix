{ pkgs
, ...
}:
{
  imports = [
    ./ai.nix
  ];

  # Define system packages for development
  environment.systemPackages = with pkgs; [
    # Editor and IDE tools
    vim
    vscode

    # Nix development tools
    devenv
    nil # Nix LSP

    # Shell and terminal tools
    starship
    fish
    bat # Better cat
    eza # Better ls
    jq # JSON processor
    fzf # Fuzzy finder

    gh # GitHub CLI

    whisper-cpp # Local AI transcription tool
  ];

  # Enable and configure development services
  services = {
    lorri.enable = true;
    vscode-server.enable = true;
  };

  # Configure development programs
  programs = {
    direnv.enable = true;

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
