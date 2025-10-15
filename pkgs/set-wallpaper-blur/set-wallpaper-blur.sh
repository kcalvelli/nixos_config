#!/usr/bin/env bash
set -e

# Input: $1 is the path to the new wallpaper
WALLPAPER="$1"
CACHE_DIR="$HOME/.cache/niri"
BLURRED="$CACHE_DIR/overview-blur.jpg"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Create blurred version using ImageMagick
magick "$WALLPAPER" -filter Gaussian -blur 0x18 "$BLURRED" 2>/dev/null

# Kill any existing swaybg process
pkill swaybg 2>/dev/null || true

# Wait a moment for the old process to die
sleep 0.1

# Start swaybg with the blurred wallpaper
exec swaybg --mode stretch --image "$BLURRED" & 2>/dev/null

