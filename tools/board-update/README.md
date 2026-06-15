# Board-update generator

Drafts a development-update post for the hub's Updates section at board-review
time. It diffs the board's current **Done** set against
`state/done-snapshot.json` and reports what landed since the last review.

## Run a real draft

```bash
tools/board-update/generate.sh
```

This queries Project #1 with your `gh` auth, writes
`src/updates/<today>-board-review.md`, inserts a SUMMARY entry, and rewrites the
snapshot. **The post is a draft** — edit it (add narrative, highlight notable
work), then:

```bash
git add -A && git commit -m "docs(updates): board review <date>" && git push
```

The push triggers the `docs` workflow and publishes the post.

## Preview without writing

```bash
tools/board-update/generate.sh --dry-run
```

## Tests

```bash
tools/board-update/test.sh
```
