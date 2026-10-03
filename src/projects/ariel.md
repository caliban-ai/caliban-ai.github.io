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

The bridge is built in four layers, each shippable on its own: notifications,
ChatOps slash commands, approvals, and full conversational sessions. Commands
are authorized on two keys, a person's role and a ceiling set on the channel,
and the lower of the two wins.

**Status: released and running.** Every release is the multi-arch container
image `ghcr.io/caliban-ai/ariel`.

Working today, on Discord:
- **Notifications.** One live message per agent, paced per channel.
- **ChatOps.** `/ariel status` and `/ariel spawn` act on the fleet; `/ariel kill`
  and `/ariel respawn` deal with a stray agent; `/ariel channel`,
  `/ariel configure`, and `/ariel invite` handle channel administration and
  onboarding from chat.
- **Authorization and audit.** Every command is authorized on the person's role
  and the channel's ceiling, and audited in gonzalo. Nobody can invite above the
  role they act with.
- **Operations.** Channel configuration is picked up while the daemon runs, and
  `arield` speaks TLS, so it can reach a prosperod through an ingress.

Still to come: approvals with buttons, a chat thread as a full agent session,
and the Slack and Teams backends.

The guide, architecture decisions, and API reference live on the
[project site](https://caliban-ai.github.io/ariel/).
