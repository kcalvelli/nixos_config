{ lib, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    devenv
    nil
    zed-editor
    nixfmt-rfc-style
    vim
    starship
    fish
    helix
    gcc
    rustup
    #(vscode-fhs.override {
    #  commandLineArgs = [
    #    "--ozone-platform-hint=auto"
    #    "--ozone-platform=wayland"
    #    "--gtk-version=4"
    #    "--password-store=gnome"
    #  ];
    #})
    vscode-fhs    
  ];  

  programs.direnv.enable = true;
  #services.lorri.enable = true;  
  programs.git.enable = true;   
}