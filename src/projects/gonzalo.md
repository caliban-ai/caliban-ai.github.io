# gonzalo

A robust, shareable persistence layer for caliban.

- **Site:** <https://caliban-ai.github.io/gonzalo/>
- **Repo:** <https://github.com/caliban-ai/gonzalo>
- **Issues:** <https://github.com/caliban-ai/gonzalo/issues>
- **Board:** <https://github.com/orgs/caliban-ai/projects/1>

gonzalo lifts caliban's local-first state (memory tiers, auto-memory topics,
sessions, and checkpoints) into a layer many systems and contributors can
share. A versioned, conflict-aware `Record`/`Store` core sits over pluggable
substrates: filesystem, git, S3-compatible object storage, or a remote daemon.
Capability layers add vector search, a tree-sitter code graph with an MCP
server, a knowledge store, and normalized ticket connectors for GitHub, Jira,
Linear, GitLab, and Asana. The `gonzalod` daemon serves all of it over gRPC and
HTTP/JSON. gonzalo also holds [ariel](./ariel.md)'s identity, channel
configuration, and audit records.

The full guide, architecture decisions, and API reference live on the
[project site](https://caliban-ai.github.io/gonzalo/).
