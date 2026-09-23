#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$project_dir/tools/godot.sh"
engine="$(find_godot)"
lab_dir="$project_dir/experiments/movement"
import_log="$(mktemp)"
trap 'rm -f "$import_log"' EXIT
if ! "$engine" --headless --path "$lab_dir" --editor --import --quit >"$import_log" 2>&1; then
  cat "$import_log" >&2
  exit 1
fi
if grep -Eq 'SCRIPT ERROR|Parse Error|ERROR:' "$import_log"; then
  cat "$import_log" >&2
  exit 1
fi
rm -f "$import_log"
exec "$engine" --path "$lab_dir" "$@"
