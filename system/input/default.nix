{ pkgs, ... }:

{
  # Install logiops package
  environment.systemPackages = [ pkgs.logiops ];

  # Create systemd service
  systemd.services.logiops = {
    description = "An unofficial userspace driver for HID++ Logitech devices";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.logiops}/bin/logid";
    };
  };

  # Configuration for logiops
  environment.etc."logid.cfg".text = ''
    devices: ({
      name: "MX Vertical Advanced Ergonomic Mouse";

      dpi: 1500;

      buttons: (
      // Forward button
      {
        cid: 0x56;
        action = {
          type: "Gestures";
          gestures: (
            {
              direction: "None";
              mode: "OnRelease";
              action = {
                type: "Keypress";
                keys: [ "KEY_FORWARD" ];
              }
            },

            {
              direction: "Up";
              mode: "OnRelease";
              action = {
                type: "Keypress";
                keys: [ "KEY_PLAYPAUSE" ];
              }
            },

            {
              direction: "Down";
              mode: "OnRelease";
              action = {
                type: "Keypress";
                keys: [ "KEY_LEFTMETA" ];
              }
            },

            {
              direction: "Right";
              mode: "OnRelease";
              action = {
                type: "Keypress";
                keys: [ "KEY_NEXTSONG" ];
              }
            },

            {
              direction: "Left";
              mode: "OnRelease";
              action = {
                type: "Keypress";
                keys: [ "KEY_PREVIOUSSONG" ];
              }
            }
          );
        };
      },

      // Back button
      {
        cid: 0x53;
        action = {
          type: "Gestures";
          gestures: (
            {
              direction: "None";
              mode: "OnRelease";
              action = {
                type: "Keypress";
                keys: [ "KEY_BACK" ];
              }
            }
          );
        };
      },

    // Gesture button (hold and move)
    {
      cid: 0xc3;
      action = {
        type: "Gestures";
        gestures: (
          {
            direction: "None";
            mode: "OnRelease";
            action = {
              type: "Keypress";
              keys: [ "KEY_LEFTMETA" ]; // open activities overview
            }
          },

          {
            direction: "Right";
            mode: "OnRelease";
            action = {
              type: "Keypress";
              keys: [ "KEY_LEFTMETA", "KEY_RIGHT" ]; // snap window to right
            }
          },

          {
            direction: "Left";
            mode: "OnRelease";
            action = {
              type: "Keypress";
              keys: [ "KEY_LEFTMETA", "KEY_LEFT" ];
            }
		  },

		  {
            direction: "Up";
            mode: "onRelease";
            action = {
              type: "Keypress";
              keys: [ "KEY_LEFTMETA", "KEY_UP" ]; // maximize window
            }
		  },
		  
		  {
            direction: "Down";
            mode: "OnRelease";
            action = {
              type: "Keypress";
              keys: [ "KEY_LEFTMETA", "KEY_DOWN" ]; // minimize window
            }
          }
        );
      };
    },
	
    // Top button
    {
      cid: 0xfd;
      action = {
        type: "Gestures";
        gestures: (
          {
            direction: "Up";
            mode: "OnRelease";
            action = {
              type: "ChangeDPI";
              inc: 1000,
            }
          },

          {
            direction: "Down";
            mode: "OnRelease";
            action = {
              type: "ChangeDPI";
              inc: -1000,
            }
          }
        );
      };
    }
  );      
    });
  '';
}