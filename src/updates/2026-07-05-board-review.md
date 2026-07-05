# Board review — 2026-07-05

_First review since the pipeline moved to archiving Done cards off the board.
Counts below are distinct **issues**; the "landed" figure is a catch-up total
since the [2026-06-15 review](./2026-06-15-board-review.md), so it reads as a
milestone summary rather than a two-week diff. Per-repo detail now lives in each
project's changelog (newly published to its site — see below)._

## Snapshot

- Open items tracked: 117
- Backlog: 115
- In progress: 2
- In review: 0

## By project

| Project | Backlog | In progress | In review |
|---------|---------|-------------|-----------|
| caliban | 87 | 0 | 0 |
| caliban-operator | 1 | 0 | 0 |
| gonzalo | 12 | 1 | 0 |
| helm-charts | 0 | 0 | 0 |
| prospero | 15 | 1 | 0 |

## Landed since last review (186 issues)

**caliban shipped [0.5.0](https://caliban-ai.github.io/caliban/changelog.html).**
The headline release turns caliban from a single-process CLI into the base of a
distributed, self-hostable agent supervisor: `caliband` gains a networked
control plane (gRPC/TLS transport, workspace-scoped multi-repo supervision),
config/data relocate to XDG-first locations, caliban consumes gonzalo's
code-graph over MCP, and a broad reliability + OAuth + security-hardening pass
lands (compaction correctness, model-router circuit breakers, permission/sandbox
fencing, atomic file writes). See the changelog for the full list and the
upgrade notes.

**Kubernetes deployment (epic caliban#274) came together end to end.** Two new
repos were stood up — `caliban-operator` (kube-rs operator + `CalibanTask` CRD,
reconciling to agent-sandbox) and `helm-charts` (umbrella chart with a live
`k3s` integration gate). Multi-arch, non-root container images now publish to
GHCR for caliban, gonzalo, and prospero, all built on native arm64 runners
(QEMU dropped).

**gonzalo advanced the code-graph capability and its HA service.** Language
breadth landed across Python, JS/TS, Go, Java, C#, and C/C++ grammars behind a
crash-isolated parser pool; a persistent SQLite `GraphStore` backs path-agnostic
slices, impact queries, and graph diffing, exposed over gRPC/HTTP and the
`gonzalo-mcp` server. The storage foundation (content-addressed slice store,
manifest sync, mark-sweep GC, incremental git-diff sync) and the `gonzalod`
service (health/readiness probes, fs|s3 substrate selection) shipped alongside
its [0.1.0](https://caliban-ai.github.io/gonzalo/changelog.html) container image.

**prospero reached its first release.** The control plane gained a
`FleetProvider` seam with Local and `K8sFleet` backends (CRUD + watch over
`CalibanTask`), workspace-scoped caliband discovery, and a network transport
dialing caliband over TCP+TLS — plus a sweep of clustered-mode correctness fixes
(failover, cross-replica registry propagation, per-stream sequencing, event
de-duplication). Published as
[0.1.0](https://caliban-ai.github.io/prospero/changelog.html) with its own
container image and Helm chart.

**Docs pipeline:** each project now publishes its `CHANGELOG.md` to its Pages
site, and this board-review generator was reworked to source "what landed" from
closed issues (archiving-proof) rather than the board's Done column.

## Backlog by kind

- kind/bug: 1
- kind/cleanup: 11
- kind/design: 3
- kind/documentation: 8
- kind/epic: 16
- kind/feature: 54
- kind/flake: 1
