# prospero

The agent orchestration control plane for caliban: launch, manage, and observe
fleets of agents across repositories.

- **Site:** <https://caliban-ai.github.io/prospero/>
- **Repo:** <https://github.com/caliban-ai/prospero>
- **Issues:** <https://github.com/caliban-ai/prospero/issues>
- **Board:** <https://github.com/orgs/caliban-ai/projects/1>

prospero sits above many per-repo `caliband` daemons. The `prosperod` daemon
serves a REST + SSE API and a dashboard, secured by scoped API tokens. Through
it you spawn agents (in isolated git worktrees by default), kill, respawn, and
remove them, and follow their normalized event streams live. Those events are
also persisted, so history outlives the agent. prospero couples to caliban only
through caliban's NDJSON wire format, and its public HTTP API is what
[ariel](./ariel.md) builds on.

The full guide, architecture decisions, and API reference live on the
[project site](https://caliban-ai.github.io/prospero/).
