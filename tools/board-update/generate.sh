#!/usr/bin/env bash
# Draft a board-review development-update post for the caliban-ai hub.
#
# "Landed since last review" comes from REST closed issues — archiving-proof,
# because cai-fast-track archives Done cards off the board on landing, so the
# board's live Done column is not a reliable record of what shipped. Live column
# counts (Backlog / In progress / In review) come from the board.sh cache.
# Leaves the post as an uncommitted draft for a human to edit before publishing.
#
# Usage:
#   tools/board-update/generate.sh                 # live: board.sh + REST
#   tools/board-update/generate.sh --dry-run
#   tools/board-update/generate.sh \
#     --board-input board.json --issues-input closed.json --dry-run   # tests
set -euo pipefail

SRC_DIR="src"
SUMMARY=""
STATE_FILE="tools/board-update/state/done-snapshot.json"
BOARD_INPUT=""
ISSUES_INPUT=""
DATE=""
DRY_RUN=0
BOARD_SH="${CAI_BOARD_SH:-$HOME/.claude/skills/cai-shared/board.sh}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --board-input)  BOARD_INPUT="$2"; shift 2;;
    --issues-input) ISSUES_INPUT="$2"; shift 2;;
    --state)        STATE_FILE="$2"; shift 2;;
    --date)         DATE="$2"; shift 2;;
    --out-dir)      SRC_DIR="$2"; shift 2;;
    --summary)      SUMMARY="$2"; shift 2;;
    --dry-run)      DRY_RUN=1; shift;;
    *) echo "unknown arg: $1" >&2; exit 2;;
  esac
done

[[ -n "$DATE" ]] || DATE="$(date +%F)"
[[ -n "$SUMMARY" ]] || SUMMARY="$SRC_DIR/SUMMARY.md"

# --- Live board snapshot (columns + repo set) ---
if [[ -n "$BOARD_INPUT" ]]; then
  BOARD="$(cat "$BOARD_INPUT")"
else
  BOARD="$("$BOARD_SH" raw)"
fi

# --- Closed issues (what landed), archiving-proof via REST ---
if [[ -n "$ISSUES_INPUT" ]]; then
  ISSUES="$(cat "$ISSUES_INPUT")"
else
  ISSUES="[]"
  while IFS= read -r repo; do
    [[ -n "$repo" ]] || continue
    r="$(gh issue list --repo "$repo" --state closed --limit 500 \
         --json number,title,url,closedAt,labels)"
    r="$(jaq --arg repo "$repo" 'map(. + {repo: $repo})' <<<"$r")"
    ISSUES="$(jaq -n --argjson a "$ISSUES" --argjson b "$r" '$a + $b')"
  done < <(jaq -r '[.[].content.repository] | unique | .[]' <<<"$BOARD")
fi

if [[ -f "$STATE_FILE" ]]; then PREV="$(cat "$STATE_FILE")"; else PREV="[]"; fi

# --- Live column counts ---
backlog_n=$(jaq '[.[]|select(.status=="Backlog")]|length' <<<"$BOARD")
inprog_n=$(jaq '[.[]|select(.status=="In progress")]|length' <<<"$BOARD")
inrev_n=$(jaq '[.[]|select(.status=="In review")]|length' <<<"$BOARD")
open_n=$((backlog_n + inprog_n + inrev_n))

project_rows=$(jaq -r '
  [ .[] | {repo: (.content.repository | sub("caliban-ai/";"")), status} ]
  | group_by(.repo)
  | map({repo: .[0].repo,
         backlog: ([.[]|select(.status=="Backlog")]|length),
         inprog:  ([.[]|select(.status=="In progress")]|length),
         inrev:   ([.[]|select(.status=="In review")]|length)})
  | sort_by(.repo)
  | .[] | "| \(.repo) | \(.backlog) | \(.inprog) | \(.inrev) |"' <<<"$BOARD")

backlog_kind=$(jaq -r '
  [ .[] | select(.status=="Backlog") | (.labels // [])[] | select(startswith("kind/")) ]
  | group_by(.) | map("- \(.[0]): \(length)") | sort | .[]' <<<"$BOARD")

# --- Newly landed = closed issues not yet in the snapshot ---
newly=$(jaq --argjson prev "$PREV" '
  [ .[] | select((.url) as $u | ($prev | index($u)) | not) ]' <<<"$ISSUES")
newly_n=$(jaq 'length' <<<"$newly")

if [[ "$newly_n" -eq 0 ]]; then
  newly_body="_No new items landed since the last review._"
else
  newly_body=$(jaq -r '
    group_by(.repo)
    | map({repo: (.[0].repo | sub("caliban-ai/";"")), items: .})
    | sort_by(.repo)
    | .[] | "### \(.repo)\n" + ([.items[]
        | "- #\(.number) \(.title) (\(((.labels // []) | map(.name) | map(select(startswith("kind/"))) | .[0]) // "—"))"]
        | join("\n"))' <<<"$newly")
fi

emit_post() {
cat <<EOF
# Board review — ${DATE}

_Auto-generated draft. Review and edit before publishing._

## Snapshot

- Open items tracked: ${open_n}
- Backlog: ${backlog_n}
- In progress: ${inprog_n}
- In review: ${inrev_n}

## By project

| Project | Backlog | In progress | In review |
|---------|---------|-------------|-----------|
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

# Insert the nested SUMMARY entry right after the marker (newest first), idempotently.
entry="  - [${DATE} — Board review](./updates/${DATE}-board-review.md)"
if ! grep -qF -- "<!-- updates -->" "$SUMMARY"; then
  echo "error: updates marker '<!-- updates -->' not found in $SUMMARY" >&2
  exit 1
fi
if ! grep -qF -- "$entry" "$SUMMARY"; then
  awk -v e="$entry" '{print} /<!-- updates -->/{print e}' "$SUMMARY" > "$SUMMARY.tmp"
  mv "$SUMMARY.tmp" "$SUMMARY"
fi

# Rewrite the snapshot to the full current closed-issue set.
mkdir -p "$(dirname "$STATE_FILE")"
jaq '[.[] | .url]' <<<"$ISSUES" > "$STATE_FILE"

echo "Draft written: $post" >&2
echo "Review and edit it, then: git add -A && git commit && git push" >&2
