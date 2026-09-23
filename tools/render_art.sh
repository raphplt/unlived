#!/usr/bin/env bash
# Godot's SVG renderer does not render <text>; bake our SVG sources with librsvg.
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
command -v rsvg-convert >/dev/null || { echo 'Install librsvg to regenerate the illustrations.' >&2; exit 1; }
for artwork in cassette photograph letter score; do
  rsvg-convert "$project_dir/game/assets/art/$artwork.svg" -o "$project_dir/game/assets/art/$artwork.png"
done
