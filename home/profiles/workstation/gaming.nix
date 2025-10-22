{ pkgs, ... }:
{
  home.packages = with pkgs; [
    protonup-ng
    #superTuxKart
  ];
}
