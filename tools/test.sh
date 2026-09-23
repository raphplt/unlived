#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
source "$project_dir/tools/godot.sh"
engine="$(find_godot)"
mkdir -p "$project_dir/artifacts"
"$engine" --headless --path "$project_dir/game" --editor --import --quit >"$project_dir/artifacts/import.log" 2>&1
if grep -En 'SCRIPT ERROR|Parse Error|ERROR:' "$project_dir/artifacts/import.log"; then exit 1; fi
# The selected MVP is the inquiry scene. Historical A/D tests remain separate.
timeout 90 "$engine" --headless --path "$project_dir/game" -- --inquiry-smoke 2>&1 | tee "$project_dir/artifacts/inquiry-smoke.log"
if grep -En 'SCRIPT ERROR|ERROR:|WARNING:|FAIL:' "$project_dir/artifacts/inquiry-smoke.log"; then exit 1; fi
grep -Eq 'INQUIRY: [0-9]+ checks, 0 failures' "$project_dir/artifacts/inquiry-smoke.log"
# Timeout also makes script/scene errors that prevent the runner starting fail CI.
timeout 60 "$engine" --headless --path "$project_dir/game" res://scenes/main.tscn -- --smoke 2>&1 | tee "$project_dir/artifacts/smoke.log"
if grep -En 'SCRIPT ERROR|ERROR:|WARNING:|FAIL:' "$project_dir/artifacts/smoke.log"; then exit 1; fi
grep -Eq 'SMOKE: [0-9]+ checks, 0 failures' "$project_dir/artifacts/smoke.log"
if [[ "${1:-}" == "--display" ]]; then
  timeout 120 "$engine" --path "$project_dir/game" -- --inquiry-display 2>&1 | tee "$project_dir/artifacts/inquiry-display.log"
  if grep -En 'SCRIPT ERROR|ERROR:|WARNING:|FAIL:' "$project_dir/artifacts/inquiry-display.log"; then exit 1; fi
  grep -Eq 'INQUIRY: [0-9]+ checks, 0 failures' "$project_dir/artifacts/inquiry-display.log"
  timeout 60 "$engine" --path "$project_dir/game" res://scenes/main.tscn -- --display-smoke 2>&1 | tee "$project_dir/artifacts/display.log"
  if grep -En 'SCRIPT ERROR|ERROR:|WARNING:|FAIL:' "$project_dir/artifacts/display.log"; then exit 1; fi
  grep -Eq 'DISPLAY: [0-9]+ checks, 0 failures' "$project_dir/artifacts/display.log"
fi
