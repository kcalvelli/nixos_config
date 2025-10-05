{
  lib,
  myPkgs,
  homeModules,
  pkgs,
  config,
  ...
}:
{
  # Define Hyprland options
  options.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland window manager";
  };

  # Configure Hyprland if enabled
  config = lib.mkIf config.hyprland.enable {

    services = {
      flatpak.enable = true;
      displayManager.cosmic-greeter.enable = true;    
      displayManager.sessionPackages = [ pkgs.hyprland ];  
    };

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    xdg.portal.xdgOpenUsePortal = true;    
  
    programs = {
      hyprland.enable = true;
      xwayland.enable = true;
      # Enable file-roller (archive manager)
      #file-roller.enable = true;
      # Enable GNOME Disks (disk utility)
      #gnome-disks.enable = true;
      # Enable Seahorse (GNOME keyring manager)
      #seahorse.enable = true;
      # Enable CoreCtrl (hardware control)
      #corectrl.enable = true;    
      # Enable KDE Connect (using Valent package)
      #kdeconnect = {
      #  enable = true;
      #  package = pkgs.valent;
      #};
      # This is listed in the readme of dankMaterialShell but does not appear to be exported currently
      #dankMaterialShell.greeter = {
      #  enable = true;
      #  compositor = "hyprland"; # or set to hyprland
      #  configHome = "/home/user"; # optionally symlinks that users DMS settings to the greeters data directory
      #};      
    };

    # Add system packages for utilities, graphics, and theming
    environment.systemPackages = with pkgs; [
      # System apps
      baobab

      # Utilities
      qalculate-gtk

      # Graphics apps
      pinta
      shotwell

      # Themes and appearance
      kdePackages.qt6ct

      nautilus
    ];

    # Enable some homeManager stuff
    home-manager.sharedModules = with homeModules; [
      hyprland
      dankMaterialShell
    ];    
  };
}
