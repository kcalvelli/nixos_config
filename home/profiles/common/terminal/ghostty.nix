{ 
  config, 
  pkgs, 
  lib, 
  inputs,
  ... 
}:
{
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.system}.default;
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
}
