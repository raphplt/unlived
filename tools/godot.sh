#!/usr/bin/env bash
# Shared engine discovery. Override with GODOT_BIN=/absolute/path/to/Godot.
set -euo pipefail
find_godot() {
  if [[ -n "${GODOT_BIN:-}" ]]; then
    command -v "$GODOT_BIN"
    return
  fi
  local candidate
  for candidate in godot godot-mono godot4 /opt/godot-mono/Godot_v4.6.1-stable_mono_linux.x86_64; do
    if command -v "$candidate" >/dev/null 2>&1; then
      command -v "$candidate"
      return
    fi
  done
  echo 'Godot 4.6 est requis. Définissez GODOT_BIN ou ajoutez Godot au PATH.' >&2
  return 1
}
