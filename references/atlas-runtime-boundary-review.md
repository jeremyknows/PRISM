# Atlas Runtime Boundary Review Pattern

Use this reference when reviewing Atlas OS-style runtime independence claims, especially migrations between atlas-bridge / Claude Code tmux / Hermes profiles / gateway-style runtimes.

## Core adversarial question

Does the runtime registry or runtime config actually create independence, or only move coupling from code to YAML?

A claim is not runtime independence until all of these are true:

1. A real registry/inventory file exists.
2. A schema and fail-closed validator exist.
3. A drift report compares registry intent against live launchd, tmux, bridge, Hermes, cron, delivery, memory, and bus state.
4. At least one router/launcher consumes the registry in staging.
5. Runtime invocation uses opaque conversation/message/user refs; raw delivery IDs stay outside the runtime boundary.
6. Rollback command IDs resolve through reviewed allowlisted commands, not raw YAML shell strings.
7. Two rollback drills pass with measured SLOs.

## Panels that worked well

For Atlas OS / runtime-boundary reviews, use a custom panel rather than only the stock PRISM roles:

- Devil's Advocate: attack registry-backed independence and rollback realism.
- Pragmatist: assess timeline, dependency order, and hidden implementation work.
- Security Reviewer: evaluate OAuth/vendor risk, local service tokens, Curator mutability, source isolation, and write authority.
- Architect: test layer boundaries, RuntimeAdapter / ConversationRef sufficiency, and Delivery/Runtime/Orchestration/Memory coupling.

Batch panels if the runtime has `delegation.max_concurrent_children` limits. Preserve independence: do not feed earlier panel outputs into later panel prompts unless doing final synthesis.

## Evidence checklist

Ask reviewers to inspect both docs and live state where available:

- Runtime registry file exists? If missing, independence is not implemented.
- Validator / schema / negative tests exist?
- Registry consumer exists?
- Delivery IDs leak into runtime session identity?
- Current runtime restart path vs true alternate-runtime rollback?
- Live launchd/tmux/script paths match docs?
- Cron dispatch target depends on current runtime?
- Memory Service exists or is only a stub?
- Backend role for memory is decided?
- Source isolation is backend-enforced or client-side workaround?
- Curator can mutate external shared skills?

## Atlas-specific findings from 2026-05-09 review

Archived synthesis:
`<home>/projects/system-pipes/analysis/prism/atlas-os-librarian-runtime-boundary/2026-05-09-hermes-session-synthesis.md`

Reusable lessons:

- Treat Runtime Registry v0 as inventory only until consumed by a validated staging path.
- Runtime-boundary shadow artifacts are useful evidence but not proof of independence.
- Rollback is never just "change YAML and restart"; it includes stopping the new runtime, preventing double responders, restoring the prior runtime, verifying delivery state, cron target, identity/context, memory recall, and bus events.- Memory Service v0 should stay read-mostly: `/context`, `/recall`, `/health`; no writes/confirm/publish without separate scoped-token and audit design.
- GBrain can back recall, but fleet MCP/source-isolation claims require Postgres migration and source-filter validation.
- External Atlas skills wired through Hermes `external_dirs` need Curator policy: default pinned/read-only, explicit mutable exceptions only.
