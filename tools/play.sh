#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$project_dir/tools/godot.sh"
engine="$(find_godot)"
# A fresh checkout needs imports and global script class registration once.
import_log="$(mktemp)"
trap 'rm -f "$import_log"' EXIT
if ! "$engine" --headless --path "$project_dir/game" --editor --import --quit >"$import_log" 2>&1; then
  cat "$import_log" >&2
  exit 1
fi
if grep -Eq 'SCRIPT ERROR|Parse Error|ERROR:' "$import_log"; then
  cat "$import_log" >&2
  exit 1
fi
rm -f "$import_log"
if [[ "${1:-}" == "--legacy" ]]; then
  shift
  exec "$engine" --path "$project_dir/game" res://scenes/main.tscn "$@"
fi
exec "$engine" --path "$project_dir/game" "$@"
