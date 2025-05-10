{
  pkgs,
  config,
  ...
}; {
  home.packages = with pkgs; [
    protonup-ng;
  ];
}