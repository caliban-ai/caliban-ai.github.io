#!/usr/bin/env bash
# Tests for the board-update generator. Run from the hub repo root.
set -euo pipefail
cd "$(dirname "$0")/../.."   # hub repo root
DIR="tools/board-update"
FIX="$DIR/fixtures"
fail=0

# Test 1: dry-run output matches the golden post exactly.
out="$("$DIR/generate.sh" --input "$FIX/board.json" --state "$FIX/prev-snapshot.json" --date 2026-06-14 --dry-run)"
if diff <(printf '%s\n' "$out") "$FIX/expected-post.md"; then
  echo "PASS: dry-run golden output"
else
  echo "FAIL: dry-run golden output"; fail=1
fi

# Test 2: a non-dry-run writes the post and rewrites the snapshot to the full Done set.
tmp="$(mktemp -d)"
mkdir -p "$tmp/src/updates" "$tmp/state"
cp src/SUMMARY.md "$tmp/src/SUMMARY.md"
state="$tmp/state/done-snapshot.json"
cp "$FIX/prev-snapshot.json" "$state"
"$DIR/generate.sh" --input "$FIX/board.json" --state "$state" --date 2026-06-14 --out-dir "$tmp/src" --summary "$tmp/src/SUMMARY.md" >/dev/null
if [[ -f "$tmp/src/updates/2026-06-14-board-review.md" ]]; then
  echo "PASS: post file written"
else
  echo "FAIL: post file written"; fail=1
fi
snap_n="$(jaq 'length' "$state")"
if [[ "$snap_n" -eq 3 ]]; then
  echo "PASS: snapshot rewritten to full Done set (3)"
else
  echo "FAIL: snapshot has $snap_n entries (expected 3)"; fail=1
fi
if grep -q '2026-06-14-board-review.md' "$tmp/src/SUMMARY.md"; then
  echo "PASS: SUMMARY updated"
else
  echo "FAIL: SUMMARY updated"; fail=1
fi
rm -rf "$tmp"

exit $fail
