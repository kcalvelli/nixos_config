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
      screenshot-path = "~/Pictures/Screenshots/Screenshot-from-%Y-%m-%d-%H-%M-%S.png";
      hotkey-overlay.skip-at-startup = true;
      
      spawn-at-startup = [
        {command = ["wl-paste" "--watch" "cliphist" "store"];}
        {command = ["wl-paste" "--type text" "--watch" "cliphist" "store"];}
      ];

      layout = {
        # Kill borders around all windows
        border = {
          enable = false;
        };
        focus-ring = {
          enable = true;
        };
        default-column-width = {proportion = 0.5;};
        tab-indicator = {
          hide-when-single-tab = true;
          place-within-column = true;
          position = "left";
          corner-radius = 20.0;
          gap = -12.0;
          gaps-between-tabs = 10.0;
          width = 4.0;
          length.total-proportion = 0.1;
        };        
      };

      input = {

        touchpad = {
          natural-scroll = false;
          tap = true;
          tap-button-map = "left-right-middle";
          middle-emulation = true;
          accel-profile = "adaptive";
        };

        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "90%";
        };
        warp-mouse-to-focus.enable = true;
        workspace-auto-back-and-forth = true;
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
        "Mod+E".action.spawn = [ "nautilus" ];
        "Mod+T".action.spawn = [ "ghostty" ];
        "Mod+Return".action.spawn = "ghostty";
        
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
        "Mod+H".action.focus-column-left = [];
        "Mod+J".action.focus-window-down = [];
        "Mod+K".action.focus-window-up = [];
        "Mod+L".action.focus-column-right = [];
    
        "Mod+Ctrl+Left".action.move-column-left = [];
        "Mod+Ctrl+Down".action.move-window-down = [];
        "Mod+Ctrl+Up".action.move-window-up = [];
        "Mod+Ctrl+Right".action.move-column-right = [];
        "Mod+Shift+H".action.move-column-left = [];
        "Mod+Shift+J".action.move-window-down = [];
        "Mod+Shift+K".action.move-window-up = [];
        "Mod+Shift+L".action.move-column-right = [];
        
        # --- Move focused window to workspace N ---
        "Mod+Shift+1".action."move-window-to-workspace" = [ 1 ];
        "Mod+Shift+2".action."move-window-to-workspace" = [ 2 ];
        "Mod+Shift+3".action."move-window-to-workspace" = [ 3 ];
        "Mod+Shift+4".action."move-window-to-workspace" = [ 4 ];
        "Mod+Shift+5".action."move-window-to-workspace" = [ 5 ];
        "Mod+Shift+6".action."move-window-to-workspace" = [ 6 ];
        "Mod+Shift+7".action."move-window-to-workspace" = [ 7 ];
        "Mod+Shift+8".action."move-window-to-workspace" = [ 8 ];  

        # --- Move focused column to workspace N ---
        "Mod+Ctrl+Shift+1".action.move-column-to-workspace = "1";
        "Mod+Ctrl+Shift+2".action.move-column-to-workspace = "2";
        "Mod+Ctrl+Shift+3".action.move-column-to-workspace = "3";
        "Mod+Ctrl+Shift+4".action.move-column-to-workspace = "4";
        "Mod+Ctrl+Shift+5".action.move-column-to-workspace = "5";
        "Mod+Ctrl+Shift+6".action.move-column-to-workspace = "6";
        "Mod+Ctrl+Shift+7".action.move-column-to-workspace = "7";
        "Mod+Ctrl+Shift+8".action.move-column-to-workspace = "8";

        # --- Column width adjustment ---
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";

        # --- Window consume/expel within columns ---
        "Mod+Shift+Comma".action.consume-window-into-column = {};
        "Mod+Shift+Period".action.expel-window-from-column = {};        

        # --- Consume/expel window left/right ---
        "Mod+BracketLeft".action.consume-or-expel-window-left = [];
        "Mod+BracketRight".action.consume-or-expel-window-right = [];        
       
      
        # --- Overview ---
        "Mod+O".action."toggle-overview" = [];

        # --- Window management ---
        "Mod+Q".action."close-window" = [];   
        "Mod+Shift+F".action."fullscreen-window" = [];

        # --- Column management ---
        "Mod+backslash".action.maximize-column = [];
        "Mod+Shift+T".action.toggle-column-tabbed-display = [];

        # --- Floating ---
        "Mod+Shift+Z".action."toggle-window-floating" = [];
        "Mod+Z".action."switch-focus-between-floating-and-tiling" = [];

        # Wheel scroll:
        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-workspace-down = { };
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-workspace-up = { };
        };
        "Mod+Ctrl+WheelScrollDown" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-down = { };
        };
        "Mod+Ctrl+WheelScrollUp" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-up = { };
        };
        
        "Mod+WheelScrollRight".action.focus-column-or-monitor-right = { };
        "Mod+WheelScrollLeft".action.focus-column-or-monitor-left = { };
        "Mod+Ctrl+WheelScrollRight".action.move-column-right-or-to-monitor-right = { };
        "Mod+Ctrl+WheelScrollLeft".action.move-column-left-or-to-monitor-left = { };    

        # --- Volume control with thumb wheel ---
        "Mod+Shift+WheelScrollLeft".action.spawn = [
            "dms" "ipc" "audio" "increment" "3" 
        ];        
        "Mod+Shift+WheelScrollRight".action.spawn = [
            "dms" "ipc" "audio" "decrement" "3" 
        ];
        "Mod+Shift+M".action.spawn = [
           "dms" "ipc" "audio" "mute"
        ];          

        # --- Quit compositor (clean exit) ---
        "Mod+Shift+E".action."quit" = [];         

        # Screenshot
        "Mod+Ctrl+S".action.screenshot-screen = {write-to-disk = true;};
        "Mod+Alt+S".action.screenshot-screen = {};
        "Mod+Shift+S".action.screenshot = {};        
      };
    };  
  };
}