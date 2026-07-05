# Board-update generator

Drafts a development-update post for the hub's Updates section at board-review
time.

**"Landed since last review"** comes from **REST closed issues** across the
repos on the board, diffed against the URL set in `state/done-snapshot.json`.
This is archiving-proof: `cai-fast-track` archives Done cards off the board on
landing, so the board's live Done column is not a reliable record of what
shipped. **Live column counts** (Backlog / In progress / In review) come from
the `board.sh` cache.

## Run a real draft

```bash
tools/board-update/generate.sh
```

Needs your `gh` auth (for the REST closed-issue queries) and `board.sh` (for the
live board snapshot; override its path with `CAI_BOARD_SH`). It writes
`src/updates/<today>-board-review.md`, inserts a SUMMARY entry, and rewrites the
snapshot to the full current closed-issue set. **The post is a draft** — edit it
(add narrative, highlight notable work), then:

```bash
git add -A && git commit -m "docs(updates): board review <date>" && git push
```

The push triggers the `docs` workflow and publishes the post.

## Preview without writing

```bash
tools/board-update/generate.sh --dry-run
```

## Offline / test with fixtures

Inject data instead of hitting the network:

```bash
tools/board-update/generate.sh \
  --board-input fixtures/board.json \
  --issues-input fixtures/closed-issues.json \
  --dry-run
```

- `--board-input <file>` — a `board.sh raw`-shaped **array** of board items.
- `--issues-input <file>` — an aggregated **array** of closed issues, each
  element `{number,title,url,closedAt,labels:[{name}],repo}`.

## Tests

```bash
tools/board-update/test.sh
```
