# Users Module

Auto-discovery module for system user configurations.

## How It Works

This module automatically discovers and imports all user configuration files in this directory. Any `.nix` file (except `default.nix`) will be automatically imported when the system is built.

## Directory Structure

```
modules/users/
├── default.nix       # Auto-discovery logic (don't modify)
├── README.md         # This file
├── keith.nix         # Example user configuration
└── [username].nix    # Your user configurations
```

## Adding a New User

### Quick Start

1. **Copy the template from `README.md`** to a new file named after the username:
   ```bash
   # Create a new user file
   touch modules/users/alice.nix
   ```

2. **Edit the file** with user-specific information:
   ```nix
   { self, config, ... }:
   let
     username = "alice";
     fullName = "Alice Smith";
     email = "alice@example.com";
     homeDir = "/home/${username}";
   in
   {
     users.users.${username} = {
       isNormalUser = true;
       description = fullName;
       extraGroups = [ "networkmanager" "wheel" ];
     };

     home-manager.users.${username} = {
       home = {
         stateVersion = "24.05";
         homeDirectory = homeDir;
         username = username;
       };
       
       programs.git.settings.user = {
         name = fullName;
         email = email;
       };
     };
   }
   ```

3. **Rebuild the system**:
   ```bash
   sudo nixos-rebuild switch --flake .
   ```

That's it! The user will be automatically discovered and configured.

## What Goes in User Files

**Include:**
- Username and identifying information
- System groups and permissions
- Home directory path
- Git username and email
- User-specific paths (backgrounds, samba shares)
- Trusted user settings
- User-specific home-manager overrides

**Don't Include:**
- Shared application configurations (→ `home/common/`)
- Desktop environment configs (→ `home/desktops/`)
- Shell configurations (→ `home/common/terminal/`)
- Package lists (→ `home/common/apps.nix`)

## Examples

See `keith.nix` for a complete example with:
- Basic user account setup
- Home-manager integration
- Git configuration
- Samba shares
- Niri background customization
- Trusted user settings

## Auto-Discovery

The `default.nix` file automatically:
1. Scans this directory for `.nix` files
2. Filters out `default.nix` itself
3. Imports all user files
4. Configures home-manager with proper special args

No manual imports needed - just drop in a new user file and rebuild!

## Removing a User

To remove a user:
1. Delete their `.nix` file from this directory
2. Rebuild the system
3. Optionally clean up their home directory

## Best Practices

1. **One file per user** - Each user gets their own `.nix` file
2. **Use let bindings** - Define username, fullName, email at the top
3. **Keep it minimal** - Only user-specific data, not shared configs
4. **Follow the pattern** - Use existing user files as templates
5. **Document custom settings** - Add comments for non-standard configurations

## Troubleshooting

**User not created:**
- Check that the filename ends in `.nix`
- Ensure the file is in `modules/users/` directory
- Verify the file isn't named `default.nix`
- Check for syntax errors: `nix flake check`

**Home-manager errors:**
- Ensure `stateVersion` matches your NixOS version
- Check that username matches in both `users.users` and `home-manager.users`
- Verify home directory path is correct
