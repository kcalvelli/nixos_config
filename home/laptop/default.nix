{ config, pkgs, ... }:
{
  imports = [
    ../pwa
    ../virtualisation
    ../shell
    ../development
    ../ags
    ../hyper
  ];
}
