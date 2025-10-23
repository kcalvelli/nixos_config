{ pkgs }:
{
  # Gaming utilities
  # Note: gamemode and mangohud moved here from Steam override
  # They're more useful as system packages (available for all games/apps)
  gaming = with pkgs; [
    gamescope
    gamemode      # Performance optimization for games
    mangohud      # Performance overlay
    superTuxKart # Fun racing game
  ];
}
