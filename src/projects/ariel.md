# ariel

The chat bridge for the caliban fleet: notifications, commands, approvals, and
conversation in Discord, Slack, and Teams.

- **Site:** <https://caliban-ai.github.io/ariel/>
- **Repo:** <https://github.com/caliban-ai/ariel>
- **Issues:** <https://github.com/caliban-ai/ariel/issues>
- **Board:** <https://github.com/orgs/caliban-ai/projects/1>

In *The Tempest*, Ariel is the spirit Prospero sends to carry messages. Here it
carries them between people in chat and the fleet that
[prospero](./prospero.md) runs.

ariel is a standalone service, `arield`, that keeps chat-platform SDKs, OAuth,
signature verification, and rate limiting behind one boundary. All fleet control
and events flow through prospero's public HTTP + SSE API. Identity, role grants,
channel configuration, and the audit trail are [gonzalo](./gonzalo.md) records,
so ariel stores nothing of its own. Chat platforms sit behind a single
`ChatProvider` trait, and each backend is a feature-gated crate.

The bridge is planned in four layers, each shippable on its own: notifications,
approvals, ChatOps slash commands, and full conversational sessions. Commands are
authorized on two keys, a person's role and a ceiling set on the channel, and
the lower of the two wins.

**Status: early implementation.** Several building blocks are on `main`:
- the prospero client, which polls the fleet and fans in each agent's SSE stream
- the `ChatProvider` trait, with an in-memory console provider
- the renderer that turns an agent's state into chat messages
- a Discord backend on twilight, passing the shared provider contract suite
- the `arield` daemon, with environment configuration, token files, a health
  endpoint, and a container image

The daemon does not yet wire the chat backend to prospero and gonzalo, so no
layer is usable end to end.

The guide, architecture decisions, and API reference live on the
[project site](https://caliban-ai.github.io/ariel/).
