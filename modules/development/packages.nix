{ pkgs, inputs, ... }:
{
  # Editors and IDEs
  editors = with pkgs; [
    vim
    vscode
  ];

  # Nix development tools
  nix = with pkgs; [
    devenv
    nil # Nix LSP
  ];

  # Shell and terminal utilities
  shell = with pkgs; [
    starship
    fish
    bat # Better cat
    eza # Better ls
    jq # JSON processor
    fzf # Fuzzy finder
  ];

  # Version control and collaboration
  vcs = with pkgs; [
    gh # GitHub CLI
  ];

  # AI and machine learning tools
  ai = with pkgs; [
    whisper-cpp # Local AI transcription tool
  ] ++ (with inputs.nix-ai-tools.packages.${pkgs.system}; [
    copilot-cli # GitHub Copilot CLI
  ]);
}
