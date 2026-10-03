# caliban-operator

The Kubernetes operator for caliban agent workloads: a `CalibanTask` CRD
composed with agent-sandbox.

- **Repo:** <https://github.com/caliban-ai/caliban-operator>
- **Issues:** <https://github.com/caliban-ai/caliban-operator/issues>
- **Board:** <https://github.com/orgs/caliban-ai/projects/1>

Written in Rust on [kube-rs](https://kube.rs), the operator composes the
Kubernetes SIG [agent-sandbox](https://agent-sandbox.sigs.k8s.io) project and
reconciles a `Workspace` + `CalibanTask` pair of custom resources into a
sandboxed agent pod.

A namespaced `Workspace` holds the durable config: git sources and named model
providers, each able to name a Secret. The operator is the sole reader of those
Secret values, so [prospero](./prospero.md) only ever handles a reference by
name. A `CalibanTask` points at a `Workspace`, and the provider it resolves is
pinned into its status at admission, so a running task's config cannot shift
underneath it. The operator owns the sandbox pod lifecycle, RBAC, and
NetworkPolicy; live agent streaming goes straight to `caliband` instead of
through the operator.

The CRDs and their reconcile loops are implemented. The accepted decisions live
in the repo's [ADR log](https://github.com/caliban-ai/caliban-operator/tree/main/docs/adr).
