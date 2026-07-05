# Progress since the board was established

_The caliban-ai Kanban board ([Project #1](https://github.com/orgs/caliban-ai/projects/1)) launched 2026-06-06. This inaugural development update summarizes completed work across caliban, prospero, and gonzalo. Auto-drafted from the board, then edited; counts below reflect distinct **issues** — each issue's implementing PRs are tracked separately on the board and omitted here to avoid double-counting._

## Snapshot (issues)

- Issues tracked: 129
- Completed: 41
- Backlog: 88

## By project (issues)

| Project | Completed | Backlog |
|---------|-----------|---------|
| caliban | 30 | 60 |
| gonzalo | 5 | 12 |
| prospero | 6 | 16 |

## Completed work

### caliban
- #8 `/tui`: fullscreen alternate-screen toggle (kind/feature)
- #13 Flip eligible slash commands to immediate:true (kind/cleanup)
- #26 Add `--debug-file` flag (kind/feature)
- #27 `--verbose` headless flag for full tool I/O (—)
- #41 Fix flaky hooks_shell.rs stdout-drain race (kind/bug)
- #55 Permission "always allow" at project/user/local scope does not apply to the live session (re-prompts until restart) (kind/bug)
- #56 Loaded skills are never proactively invoked — model improvises instead of using a matching skill (kind/feature)
- #58 Permission Ask modal (and always-allow sub-prompt) clip the action row when input/pattern are long — Deny option hidden (kind/bug)
- #60 Ollama: detect real context window from /api/ps (context_length) instead of a static 32K fallback (kind/feature)
- #65 Set up test coverage tracking (local + CI) with a minimum-coverage gate (kind/feature)
- #68 Raise test coverage to 85% and bump the COVERAGE_MIN gate (kind/cleanup)
- #69 Flaky: caliban-images strict_routing_* tests race on CALIBAN_STRICT_ROUTING env var (kind/bug)
- #71 caliband daemon Spawn registers agents but never launches a worker (agents stuck in Spawning) (kind/bug)
- #75 Background sub-agent workers run unguarded — apply tool_allowlist + permission policy (kind/feature)
- #76 Rm --force on a Running agent orphans the worker process (should SIGTERM) (kind/bug)
- #77 Per-agent socket file is left on disk after Kill/Rm/worker-exit (kind/cleanup)
- #78 Derive Serialize on TurnEvent for full-fidelity worker event stream (kind/feature)
- #79 Live attach protocol: history replay + live TurnEvent streaming + inbound messages + agents attach client (kind/feature)
- #81 Inbound user messages to a running sub-agent (idle/await-input) — needs agent-core support + ADR 0037 amendment (kind/feature)
- #84 Serialize parent hook config into SpawnSpec for inherit_hooks=true (full hook inheritance) (kind/feature)
- #88 Flaky test: caliban-images strict_routing_default_is_strict races on CALIBAN_STRICT_ROUTING env var (kind/flake)
- #93 Daemon-spawned workers can't select a provider (SpawnSpec has no provider; CALIBAN_PROVIDER ignored) (kind/feature)
- #97 docs: remove resolved ADR conformance audit + make ADR citations self-sustaining (kind/documentation)
- #100 feat(model-router): user-facing extended-thinking toggle independent of effort (kind/feature)
- #106 feat(tools): SessionStart context-injection hook surface (kind/feature)
- #107 fix(tools): warn instead of silently skipping skills whose name mismatches their directory (kind/bug)
- #109 design(labels): agree a shared label taxonomy across caliban/gonzalo/prospero (kind/design)
- #112 fix(slash-commands): /memory delete should not be immediate (silent, unconfirmed data loss) (kind/bug)
- #121 feat(hooks): execute config-defined [[hooks.*]] handlers at runtime (kind/feature)
- #125 docs(adr): adopt docs/adr/ convention to match prospero + gonzalo (kind/cleanup)
### gonzalo
- #3 Structured-body merge (currently returns NeedsResolution) (kind/feature)
- #15 design: ticket-system capability layer over Record/Store core (kind/design)
- #16 design: knowledge-store capability over vector + domain layers (kind/design)
- #20 test(ticket): TicketSource conformance suite keyed on policy variants (kind/feature)
- #19 feat(ticket): provider connectors (GitHub, Jira, Linear, GitLab, Asana) (kind/feature)
### prospero
- #12 Set up test coverage tracking (local + CI) with a minimum-coverage gate (kind/feature)
- #13 Raise test coverage to 85% and bump the coverage gate (kind/cleanup)
- #19 docs(adr): adopt ADR practice under docs/adr/####-topic.md (kind/documentation)
- #28 fix(api): SSE silently drops lagged events with no gap signal to the client (kind/bug)
- #27 feat(cli): expose --tool-allowlist on spawn (kind/feature)
- #30 docs(adr): convert ADRs from Nygard to MADR-lite for sibling parity (kind/cleanup)

## Backlog by kind

- kind/bug: 8
- kind/cleanup: 9
- kind/epic: 10
- kind/feature: 42
