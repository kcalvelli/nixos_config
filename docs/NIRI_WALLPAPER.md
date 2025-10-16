# Niri with DankMaterialShell Integration

## Overview

This configuration uses [Niri](https://github.com/YaLTeR/niri), a scrollable-tiling Wayland compositor, with [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) for enhanced functionality and aesthetics.

## DankMaterialShell Features

DankMaterialShell provides:
- Material Design-inspired theming
- Custom keybindings and shortcuts
- Plugin system for extended functionality
- Enhanced overview mode with visual effects

## WallpaperWatcherDaemon Plugin

### What It Does

The WallpaperWatcherDaemon plugin watches for wallpaper changes and automatically generates a blurred version for the Niri overview mode. This creates a nice visual effect where your wallpaper appears blurred in the background when you open the overview.

### How It Works

1. **Plugin watches for wallpaper changes** in your home directory
2. **Automatically generates a blurred version** using ImageMagick
3. **Saves it to** `~/.cache/niri/overview-blur.jpg`
4. **Niri displays the blurred image** as background during overview mode

### Required Script

The WallpaperWatcherDaemon requires an external script to function properly. This script is maintained separately at:

**https://github.com/kcalvelli/scripts**

### Script Setup

1. **Clone the scripts repository**:
   ```bash
   git clone https://github.com/kcalvelli/scripts.git ~/scripts
   ```

2. **The wallpaper blur script** should be in the repository and needs to:
   - Watch for wallpaper changes
   - Generate blurred versions using ImageMagick
   - Save output to `~/.cache/niri/overview-blur.jpg`

3. **The WallpaperWatcherDaemon plugin** will call this script automatically

### Configuration

The plugin is configured in `home/desktops/wayland/niri.nix`:

```nix
programs.dankMaterialShell = {
  niri = {
    enableKeybinds = true;
    enableSpawn = true;
  };
  plugins = {
    WallpaperWatcherDaemon.src = "${inputs.dankMaterialShell}/PLUGINS/WallpaperWatcherDaemon";
  };
};
```

The background display is configured per-user in `modules/users/[username].nix`:

```nix
programs.niri.settings.spawn-at-startup = [
  { 
    command = [ 
      "swaybg" 
      "--mode" "stretch" 
      "--image" "${homeDir}/.cache/niri/overview-blur.jpg" 
    ]; 
  }
];
```

### Dependencies

The wallpaper blur functionality requires:
- **ImageMagick** - For image processing and blurring
- **swaybg** - For displaying the background (included in Wayland packages)
- **The external script** from https://github.com/kcalvelli/scripts

ImageMagick is included in the Wayland desktop packages at `home/desktops/wayland/packages.nix`.

### Customization

To customize the blur effect, modify the script in the kcalvelli/scripts repository. You can adjust:
- Blur radius and sigma
- Image quality
- Output format
- Watch patterns

### Troubleshooting

**Blurred background not appearing:**
1. Check that `~/.cache/niri/overview-blur.jpg` exists
2. Verify ImageMagick is installed: `which convert`
3. Check that the wallpaper script is running
4. Ensure the WallpaperWatcherDaemon plugin is loaded

**Script not running:**
1. Verify the scripts repository is cloned
2. Check script permissions (should be executable)
3. Look at DankMaterialShell plugin logs
4. Ensure the script path is correct

**Blur not updating:**
1. The script watches for wallpaper changes
2. Manually trigger by changing your wallpaper
3. Or regenerate manually: Run the blur script directly

## Niri Overview Mode

To activate the overview mode and see the blurred background:
- Default keybind is usually `Super+Tab` or configured in your keybindings
- The blurred wallpaper appears as the backdrop
- All windows are shown in a grid layout

## Related Files

- **DankMaterialShell config**: `home/desktops/wayland/niri.nix`
- **User-specific background**: `modules/users/[username].nix`
- **Wayland packages**: `home/desktops/wayland/packages.nix` (includes ImageMagick)
- **External scripts**: https://github.com/kcalvelli/scripts

## References

- [Niri Compositor](https://github.com/YaLTeR/niri)
- [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)
- [Scripts Repository](https://github.com/kcalvelli/scripts)
- [swaybg](https://github.com/swaywm/swaybg)
