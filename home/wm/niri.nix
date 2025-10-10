{ inputs, pkgs, lib, ... }:
{
  imports = [ 
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  programs = {
    dankMaterialShell = {
      niri = {
        enableKeybinds = true;
        enableSpawn = true;
      };
    }; 
    niri.settings = {
      prefer-no-csd = true;
      xwayland-satellite.path = "${lib.getExe pkgs.xwayland-satellite}";
      layout = {
        # Kill borders around all windows
        border = {
          enable = false;
        };
        focus-ring = {
          enable = true;
        };
      };

      window-rules = [
        {
         geometry-corner-radius = let
           radius = 12.0;
         in {
           bottom-left = radius;
           bottom-right = radius;
           top-left = radius;
           top-right = radius;
         };
         clip-to-geometry = true;
         draw-border-with-background = false;
        }  
        {
         matches = [
           {is-floating = true;}
         ];
         shadow.enable = true;
        }        
      ];

      # Keybindings      
      binds = {
        # --- App launches ---
        "Mod+B".action.spawn = [ "brave" ];
        "Mod+F".action.spawn = [ "nautilus" ];
        "Mod+T".action.spawn = [ "ghostty" ];
        
        # --- Workspace: jump directly (1..8) ---
        "Mod+1".action."focus-workspace" = [ 1 ];
        "Mod+2".action."focus-workspace" = [ 2 ];
        "Mod+3".action."focus-workspace" = [ 3 ];
        "Mod+4".action."focus-workspace" = [ 4 ];
        "Mod+5".action."focus-workspace" = [ 5 ];
        "Mod+6".action."focus-workspace" = [ 6 ];
        "Mod+7".action."focus-workspace" = [ 7 ];
        "Mod+8".action."focus-workspace" = [ 8 ]; 
        
        # --- Navigation ---
        "Mod+Left".action."focus-column-left" = [];
        "Mod+H".action."focus-column-left" = [];
        "Mod+Up".action."focus-workspace-up" = [];
        "Mod+K".action."focus-workspace-up" = [];
        "Mod+Right".action."focus-column-right" = [];
        "Mod+L".action."focus-column-right" = [];
        "Mod+Down".action."focus-workspace-down" = [];
        "Mod+J".action."focus-workspace-down" = [];
        
        # --- Move focused window to workspace N ---
        "Mod+Shift+1".action."move-window-to-workspace" = [ 1 ];
        "Mod+Shift+2".action."move-window-to-workspace" = [ 2 ];
        "Mod+Shift+3".action."move-window-to-workspace" = [ 3 ];
        "Mod+Shift+4".action."move-window-to-workspace" = [ 4 ];
        "Mod+Shift+5".action."move-window-to-workspace" = [ 5 ];
        "Mod+Shift+6".action."move-window-to-workspace" = [ 6 ];
        "Mod+Shift+7".action."move-window-to-workspace" = [ 7 ];
        "Mod+Shift+8".action."move-window-to-workspace" = [ 8 ];  
      
        # --- Overview ---
        "Mod+O".action."toggle-overview" = [];

        # --- Window management ---
        "Mod+Q".action."close-window" = [];   
        "Mod+Shift+F".action."fullscreen-window" = [];

        # --- Floating ---
        "Mod+Shift+Z".action."toggle-window-floating" = [];
        "Mod+Z".action."switch-focus-between-floating-and-tiling" = [];

        # --- Optional: mouse wheel to cycle things (keep if you like this UX) ---
        # Current column windows:
        "Mod+WheelScrollDown".action."focus-window-down" = [];
        "Mod+WheelScrollUp".action."focus-window-up"     = [];
        # Adjacent columns:
        "Mod+WheelScrollRight".action."focus-column-right" = [];
        "Mod+WheelScrollLeft".action."focus-column-left"   = [];       

        # --- Quit compositor (clean exit) ---
        "Mod+Shift+E".action."quit" = [];         
      };
    };  
  };
}