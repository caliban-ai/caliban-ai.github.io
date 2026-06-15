#!/usr/bin/env bash
# Draft a board-review development-update post for the caliban-ai hub.
#
# Diffs the board's current "Done" set against the saved snapshot, so the post
# reports exactly what landed since the previous review. Leaves the post as an
# uncommitted draft for a human to edit before publishing.
#
# Usage:
#   tools/board-update/generate.sh [--since-snapshot]   # live: query the board
#   tools/board-update/generate.sh --input board.json --dry-run   # test/preview
set -euo pipefail

OWNER="caliban-ai"
PROJECT=1
SRC_DIR="src"
SUMMARY=""
STATE_FILE="tools/board-update/state/done-snapshot.json"
INPUT=""
DATE=""
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input)   INPUT="$2"; shift 2;;
    --state)   STATE_FILE="$2"; shift 2;;
    --date)    DATE="$2"; shift 2;;
    --out-dir) SRC_DIR="$2"; shift 2;;
    --summary) SUMMARY="$2"; shift 2;;
    --dry-run) DRY_RUN=1; shift;;
    *) echo "unknown arg: $1" >&2; exit 2;;
  esac
done

[[ -n "$DATE" ]] || DATE="$(date +%F)"
[[ -n "$SUMMARY" ]] || SUMMARY="$SRC_DIR/SUMMARY.md"

if [[ -n "$INPUT" ]]; then
  BOARD="$(cat "$INPUT")"
else
  BOARD="$(gh project item-list "$PROJECT" --owner "$OWNER" --format json --limit 300)"
fi

if [[ -f "$STATE_FILE" ]]; then PREV="$(cat "$STATE_FILE")"; else PREV="[]"; fi

total=$(jaq '.items | length' <<<"$BOARD")
done_n=$(jaq '[.items[] | select(.status=="Done")] | length' <<<"$BOARD")
backlog_n=$(jaq '[.items[] | select(.status=="Backlog")] | length' <<<"$BOARD")

newly=$(jaq --argjson prev "$PREV" '
  [.items[] | select(.status=="Done")]
  | map(select((.content.url) as $u | ($prev | index($u)) | not))' <<<"$BOARD")
newly_n=$(jaq 'length' <<<"$newly")

project_rows=$(jaq -r '
  [.items[] | {repo: (.content.repository | sub("caliban-ai/";"")), status}]
  | group_by(.repo)
  | map({repo: .[0].repo,
         done: ([.[] | select(.status=="Done")] | length),
         backlog: ([.[] | select(.status=="Backlog")] | length)})
  | sort_by(.repo)
  | .[] | "| \(.repo) | \(.done) | \(.backlog) |"' <<<"$BOARD")

if [[ "$newly_n" -eq 0 ]]; then
  newly_body="_No new items reached Done since the last review._"
else
  newly_body=$(jaq -r '
    group_by(.content.repository)
    | map({repo: (.[0].content.repository | sub("caliban-ai/";"")), items: .})
    | sort_by(.repo)
    | .[] | "### \(.repo)\n" + ([.items[]
        | "- #\(.content.number) \(.content.title) (\(((.labels // []) | map(select(startswith("kind/"))) | .[0]) // "—"))"]
        | join("\n"))' <<<"$newly")
fi

backlog_kind=$(jaq -r '
  [.items[] | select(.status=="Backlog") | (.labels // [])[] | select(startswith("kind/"))]
  | group_by(.) | map("- \(.[0]): \(length)") | sort | .[]' <<<"$BOARD")

emit_post() {
cat <<EOF
# Board review — ${DATE}

_Auto-generated draft. Review and edit before publishing._

## Snapshot

- Total tracked: ${total}
- Done: ${done_n}
- Backlog: ${backlog_n}

## By project

| Project | Done | Backlog |
|---------|------|---------|
${project_rows}

## Landed since last review (${newly_n})

${newly_body}

## Backlog by kind

${backlog_kind}
EOF
}

if [[ "$DRY_RUN" -eq 1 ]]; then
  emit_post
  exit 0
fi

# Write the post.
mkdir -p "$SRC_DIR/updates"
post="$SRC_DIR/updates/${DATE}-board-review.md"
emit_post > "$post"

# Insert the nested SUMMARY entry right after the marker (newest first).
entry="  - [${DATE} — Board review](./updates/${DATE}-board-review.md)"
awk -v e="$entry" '{print} /<!-- updates -->/{print e}' "$SUMMARY" > "$SUMMARY.tmp"
mv "$SUMMARY.tmp" "$SUMMARY"

# Rewrite the snapshot to the current full Done set.
mkdir -p "$(dirname "$STATE_FILE")"
jaq '[.items[] | select(.status=="Done") | .content.url]' <<<"$BOARD" > "$STATE_FILE"

echo "Draft written: $post" >&2
echo "Review and edit it, then: git add -A && git commit && git push" >&2
