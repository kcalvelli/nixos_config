# Niri with DankMaterialShell Integration

## Overview

This configuration uses [Niri](https://github.com/YaLTeR/niri), a scrollable-tiling Wayland compositor, with [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) for enhanced functionality and aesthetics.

## DankMaterialShell Features

DankMaterialShell provides:
- Material Design-inspired theming
- Custom keybindings and shortcuts
- Plugin system for extended functionality
- Enhanced overview mode with visual effects

## Wallpaper Blur for Overview Mode

### What It Does

The wallpaper blur script automatically generates a blurred version of your wallpaper for use in Niri's overview mode. This creates a nice visual effect where your wallpaper appears blurred in the background when you open the overview.

### How It Works

The system includes a simple script that:
1. Takes a wallpaper path as input
2. Generates a blurred version using ImageMagick (`magick` command)
3. Saves it to `~/.cache/niri/overview-blur.jpg`
4. Displays it using `swaybg` as the overview background

### Automatic Installation

**The wallpaper blur script is now automatically installed with your system!**

The script is deployed to `~/scripts/set-wallpaper-blur.sh` via home-manager and includes:
- ✅ Automatic script installation to your home directory
- ✅ Required dependencies (ImageMagick, swaybg)
- ✅ Proper permissions and executable bit set
- ✅ Cache directory creation

### Usage

To set a wallpaper with blur:

```bash
~/scripts/set-wallpaper-blur.sh /path/to/your/wallpaper.jpg
```

This will:
1. Generate a blurred version at `~/.cache/niri/overview-blur.jpg`
2. Kill any existing swaybg process
3. Start swaybg displaying the blurred wallpaper

### Configuration

The script uses these settings:
- **Blur strength**: `0x18` (Gaussian blur with sigma 18)
- **Display mode**: `stretch` (fits to screen)
- **Cache location**: `~/.cache/niri/overview-blur.jpg`

### Integration with DankMaterialShell

DankMaterialShell's WallpaperWatcherDaemon plugin can call this script automatically when you change wallpapers. The plugin is configured in `home/desktops/niri.nix`:

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

### Dependencies

All required dependencies are automatically installed:
- **ImageMagick** - Provides the `magick` command for image processing
- **swaybg** - For displaying the background

These are included in the Wayland desktop packages.

### Customization

To customize the blur effect, edit `~/scripts/set-wallpaper-blur.sh`:

```bash
# Change this line to adjust blur strength:
magick "$WALLPAPER" -filter Gaussian -blur 0x18 "$BLURRED"
#                                          ^^^^ 
#                                          Increase for more blur
```

### Troubleshooting

**Blurred background not appearing:**
1. Check that `~/.cache/niri/overview-blur.jpg` exists
2. Verify ImageMagick is installed: `which magick`
3. Run the script manually to test: `~/scripts/set-wallpaper-blur.sh /path/to/image.jpg`
4. Check that swaybg is running: `ps aux | grep swaybg`

**Script not found:**
- Run `home-manager switch` to ensure home files are deployed
- Check that the script exists: `ls -la ~/scripts/set-wallpaper-blur.sh`

**Permission denied:**
- The script should be automatically executable
- If needed, run: `chmod +x ~/scripts/set-wallpaper-blur.sh`

## Niri Overview Mode

To activate the overview mode and see the blurred background:
- Default keybind is usually `Super+Tab` or configured in your keybindings
- The blurred wallpaper appears as the backdrop
- All windows are shown in a grid layout

## Related Files

- **Wallpaper blur script**: `home/desktops/common/wallpaper-blur.sh`
- **Installation config**: `home/desktops/common/wallpaper-blur.nix`
- **DankMaterialShell config**: `home/desktops/niri.nix`
- **User-specific background**: `modules/users/[username].nix`

## Script Location in Repository

The script is stored at:
```
home/desktops/common/wallpaper-blur.sh
```

And deployed to your home directory by home-manager:
```
~/scripts/set-wallpaper-blur.sh
```

## References

- [Niri Compositor](https://github.com/YaLTeR/niri)
- [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)
- [swaybg](https://github.com/swaywm/swaybg)
- [ImageMagick](https://imagemagick.org/)

