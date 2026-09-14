# caliban

A from-scratch Rust agent harness that puts the operator in control of model
routing, memory, skills, and prompt context.

- **Site:** <https://caliban-ai.github.io/caliban/>
- **Repo:** <https://github.com/caliban-ai/caliban>
- **Issues:** <https://github.com/caliban-ai/caliban/issues>
- **Board:** <https://github.com/orgs/caliban-ai/projects/1>

caliban is daily-usable on `main`. It speaks to Anthropic (direct, Bedrock,
Vertex), OpenAI (direct, Azure), Google Gemini, and local models through one
internal representation. You can drive it from a ratatui TUI, headless
`--print` mode, or as an ACP, HTTP, or MCP server. Sessions, checkpoints,
auto-memory, sub-agents, hooks, skills, plugins, permissions, and an OS sandbox
all ship today. Its per-repo supervisor daemon, `caliband`, is what
[prospero](./prospero.md) orchestrates.

The full user guide, architecture decisions, and API reference live on the
[project site](https://caliban-ai.github.io/caliban/).
