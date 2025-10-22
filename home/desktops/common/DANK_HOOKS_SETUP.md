# Dank Hooks Setup Guide

This configuration integrates with the **Dank Hooks** plugin for DankMaterialShell to automatically update system components when wallpaper/theme changes.

## How It Works

DankMaterialShell uses **matugen** to generate theme colors from your wallpaper. When you change wallpaper:
1. DMS changes the wallpaper → matugen generates new colors
2. Dank Hooks detects wallpaper change via `onWallpaperChanged`
3. Our script runs and handles both:
   - Wallpaper blur generation for Niri overview
   - VSCode Material Code theme color update

## Installation

Scripts are automatically installed to `~/scripts/` when you rebuild your configuration.

## Configuration

### In DankMaterialShell Settings:

1. Open DankMaterialShell settings
2. Navigate to **Dank Hooks** plugin settings
3. Configure this hook:

**Wallpaper Changed**  
**Script Path:** `/home/keith/scripts/wallpaper-changed.sh`

This single hook handles everything since wallpaper changes trigger matugen color generation.

## What Gets Updated

### wallpaper-changed.sh
- **Triggered by:** `onWallpaperChanged` hook
- **Receives:** Wallpaper file path
- **Actions:**
  1. Generates blurred version at `~/.cache/niri/overview-blur.jpg`
  2. Restarts swaybg with the blurred wallpaper
  3. Triggers VSCode Material Code theme update with new colors

### update-material-code-theme.sh
- **Called by:** `wallpaper-changed.sh`
- **Purpose:** Regenerates VSCode theme from current system colors
- **Requirements:** `~/.config/material-code-theme/` must exist

## Testing

Test the complete workflow:

```bash
# Test with a wallpaper
~/scripts/wallpaper-changed.sh "onWallpaperChanged" "/path/to/wallpaper.jpg"
```

This will:
- Generate blurred wallpaper
- Update swaybg
- Regenerate VSCode theme with current colors

## Why Only onWallpaperChanged?

The `onThemeChanged` hook only fires when you manually select a theme color (blue, red, green) in DMS settings. It does NOT fire when matugen generates colors from wallpaper.

Since matugen runs when wallpaper changes, we hook into wallpaper changes to catch the color updates.

## Troubleshooting

**Hook not triggering:**
1. Verify Dank Hooks plugin is enabled in DankMaterialShell
2. Check plugin settings has correct script path
3. Monitor logs: `journalctl --user -u dankMaterialShell -f`

**Blurred background not appearing:**
1. Check that `~/.cache/niri/overview-blur.jpg` exists
2. Verify ImageMagick is installed: `which magick`
3. Test manually with command above
4. Check that swaybg is running: `ps aux | grep swaybg`

**VSCode theme not updating:**
1. Verify `~/.config/material-code-theme/` directory exists
2. Check script output when running manually
3. Ensure bun is installed

**Scripts not found:**
- Run `home-manager switch` to deploy scripts
- Check: `ls -la ~/scripts/`

## How Colors Flow

```
Wallpaper Change → matugen generates colors → Colors saved to system
                ↓
    onWallpaperChanged hook fires
                ↓
    wallpaper-changed.sh runs
                ↓
    ├─ Blur wallpaper for overview
    └─ update-material-code-theme.sh reads new system colors
```
