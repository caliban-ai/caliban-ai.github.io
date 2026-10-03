# caliban

A from-scratch Rust agent harness that puts the operator in control of model
routing, memory, skills, and prompt context.

- **Site:** <https://caliban-ai.github.io/caliban/>
- **Repo:** <https://github.com/caliban-ai/caliban>
- **Issues:** <https://github.com/caliban-ai/caliban/issues>
- **Board:** <https://github.com/orgs/caliban-ai/projects/1>

caliban is daily-usable on `main`. The binary speaks to Anthropic, OpenAI, and
Google Gemini through one internal representation. Bedrock, Vertex, and Azure
adapters are available through the library. You can drive it from a ratatui TUI,
headless `--print` mode, or as an ACP, HTTP, or MCP server. Sessions,
checkpoints and forking, auto-memory, sub-agents, a background agent fleet,
hooks, skills, permissions, and an OS sandbox all ship today. Recent releases
gave the agent loop model-adaptive turn, time, and cost budgets, and folded
configuration into one layered settings system with provenance, so router
config and `CALIBAN_*` environment overrides no longer sit outside it. Its per-repo supervisor daemon, `caliband`, is what
[prospero](./prospero.md) orchestrates.

The full user guide, architecture decisions, and API reference live on the
[project site](https://caliban-ai.github.io/caliban/).
