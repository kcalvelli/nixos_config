{ inputs, config, pkgs, ... }:
{
    imports = [
      ./kdepim.nix
    ];
    
    environment.systemPackages = with pkgs; [
     #Need these 
     pkgs.kdePackages.kcalc
     pkgs.kdePackages.skanlite
     pkgs.kdePackages.filelight
     
     #Kaccounts
     pkgs.kdePackages.kaccounts-integration
     pkgs.kdePackages.kaccounts-providers
     
    ];

  #programs.kdepim.enable = true;
}