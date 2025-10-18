#!/usr/bin/env bash
set -e

# Input: $1 is the path to the new wallpaper
WALLPAPER="$1"
CACHE_DIR="$HOME/.cache/niri"
BLURRED="$CACHE_DIR/overview-blur.jpg"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Create blurred version using ImageMagick
magick "$WALLPAPER" -filter Gaussian -blur 0x18 "$BLURRED"

# Kill any existing swaybg process
pkill swaybg || true

# Wait a moment for the old process to die
sleep 0.1

# Start swaybg with the blurred wallpaper
exec swaybg --mode stretch --image "$BLURRED" >/dev/null 2>&1 &

