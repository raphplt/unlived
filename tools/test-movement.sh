#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$project_dir/tools/godot.sh"
engine="$(find_godot)"
mkdir -p "$project_dir/artifacts/movement"
"$engine" --headless --path "$project_dir/experiments/movement" --editor --import --quit >"$project_dir/artifacts/movement/import.log" 2>&1
if grep -En 'SCRIPT ERROR|Parse Error|ERROR:' "$project_dir/artifacts/movement/import.log"; then exit 1; fi
timeout 60 "$engine" --headless --path "$project_dir/experiments/movement" --fixed-fps 120 -- --smoke 2>&1 | tee "$project_dir/artifacts/movement/smoke.log"
if grep -En 'SCRIPT ERROR|ERROR:|WARNING:|FAIL:' "$project_dir/artifacts/movement/smoke.log"; then exit 1; fi
grep -Eq 'MOVEMENT: [0-9]+ checks, 0 failures' "$project_dir/artifacts/movement/smoke.log"
if [[ "${1:-}" == "--display" ]]; then
  timeout 45 "$engine" --path "$project_dir/experiments/movement" -- --display-smoke 2>&1 | tee "$project_dir/artifacts/movement/display.log"
  if grep -En 'SCRIPT ERROR|ERROR:|WARNING:|FAIL:' "$project_dir/artifacts/movement/display.log"; then exit 1; fi
  grep -Eq 'MOVEMENT DISPLAY: [0-9]+ checks, 0 failures' "$project_dir/artifacts/movement/display.log"
fi
