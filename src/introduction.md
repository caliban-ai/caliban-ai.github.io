# caliban-ai

caliban-ai is a small constellation of Rust projects for running AI agents on
your own terms:

- **[caliban](./projects/caliban.md)** — the agent harness: provider-agnostic,
  local-first, driven from a TUI or headless.
- **[prospero](./projects/prospero.md)** — the control plane that launches,
  manages, and observes fleets of caliban agents across repositories.
- **[gonzalo](./projects/gonzalo.md)** — the shareable persistence layer:
  versioned records over pluggable stores, plus vector search and a code graph.
- **[ariel](./projects/ariel.md)** — the chat bridge that brings the fleet into
  Discord, with Slack and Teams to follow.

## How they fit together

```
Discord / Slack / Teams
        │
      ariel ──── HTTP + SSE ───▶ prospero ── NDJSON ──▶ caliband ─▶ caliban agents
        │                           │                                   │
        └──────── records ───────▶ gonzalo ◀──────── memory, sessions ──┘
```

Each project couples to its neighbours only through a public wire format or API,
never through another project's crates, so each can be run and released on its own.

See **[Development Updates](./updates/index.md)** for board-review progress reports.
