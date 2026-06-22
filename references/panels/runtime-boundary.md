# Runtime Boundary Panel

Use with `--panel=runtime-boundary` when reviewing runtime independence claims, runtime registry designs, rollback plans, bridge/gateway/Hermes/tmux migrations, memory-service boundaries, or agent delivery/runtime separation.

## Use When

- A proposal claims runtime independence, runtime portability, or fallback/rollback readiness.
- A registry or config file is being used as proof of decoupling.
- Delivery IDs, conversation refs, memory authority, launchd/tmux/cron state, or rollback commands cross runtime boundaries.

## Do Not Use When

- The work is a normal code review with no runtime, delivery, memory, or rollback claim.
- The only question is local bug correctness; use stock PRISM or Extended code review instead.

## Context Card Defaults

Artifact: runtime architecture / registry / config / rollback plan
Goal: prove the system can change or recover runtimes without hidden coupling
Audience/operator: operator and specialist agents relying on the runtime
Typical failure surfaces: YAML-only independence, raw delivery ID leakage, unvalidated registry drift, unsafe rollback, memory/source authority confusion
Decision shape: approve with conditions / needs work before claiming independence

## Source Material

- Runtime registry or inventory file
- Validator/schema/negative tests
- Launcher/router/adapter consuming the registry
- Live launchd/tmux/bridge/Hermes/cron evidence
- Rollback command list and drill evidence

Forbidden scope: do not mutate dependencies, restart runtimes, or execute rollback commands during review unless the operator explicitly approves.

## Reviewers

### Runtime Independence Adversary — Is this independence real or YAML theater?

Role slug: runtime-independence-adversary

Challenge role: true

Failure surface protected: registry-backed independence claims that only move coupling from code to config

Focus: Attack the central independence claim, raw delivery ID leakage, and rollback realism.

Non-goals: Do not propose broad rewrites unless a concrete boundary fails.

Key questions:
1. Does a real registry/inventory file exist?
2. Is a router/launcher consuming it in staging, or is it documentation only?
3. Do conversation/message/user refs stay opaque across the runtime boundary?

Evidence expectations: cite registry files, launcher/router call sites, live-state commands, or missing evidence.

Output format: Fatal flaws, optimistic assumptions, 6-month regrets, verdict.

Model hint: sonnet

Verdict authority: Can block any runtime-independence claim.

### Ops Pragmatist — What hidden work blocks this from operating safely?

Role slug: ops-pragmatist

Challenge role: false

Failure surface protected: timeline, dependency order, operational gaps, and handoff ambiguity

Focus: Assess implementation sequence, operator burden, runbook gaps, and hidden dependencies.

Non-goals: Do not relitigate architecture if the dependency/order problem is the actual blocker.

Key questions:
1. What has to exist before this is safe to use?
2. What breaks at 3am when nobody is actively watching?
3. What is the smallest safe rollout/drill?

Evidence expectations: cite runbooks, scripts, cron/launchd/tmux references, and operational logs when available.

Output format: Readiness assessment, dependency order, blocking gaps, verdict.

Model hint: sonnet

Verdict authority: Can require sequencing/rollout conditions.

### Security Boundary Reviewer — Where do tokens, write authority, and vendor trust leak?

Role slug: security-boundary-reviewer

Challenge role: false

Failure surface protected: OAuth/vendor risk, local service tokens, source isolation, Curator mutability, and write authority

Focus: Evaluate whether runtime changes expand credential exposure or authority.

Non-goals: Do not review generic code style or performance.

Key questions:
1. Are secrets/tokens isolated from runtime config and logs?
2. Can a runtime or external skill mutate shared state beyond its authority?
3. Is source isolation backend-enforced or only client-side convention?

Evidence expectations: cite config, environment boundary docs, source-isolation checks, and write-authority paths.

Output format: Attack vectors, trust-boundary regressions, conditions, verdict.

Model hint: sonnet

Verdict authority: Can block on credential or authority leakage.

### Architecture Boundary Reviewer — Are Delivery, Runtime, Orchestration, and Memory actually separated?

Role slug: architecture-boundary-reviewer

Challenge role: false

Failure surface protected: layer-boundary drift and insufficient RuntimeAdapter/ConversationRef abstractions

Focus: Test whether the proposed abstractions are sufficient and consumed by real code.

Non-goals: Do not demand a larger abstraction if a smaller explicit contract works.

Key questions:
1. Which layer owns delivery IDs, runtime refs, orchestration state, and memory state?
2. Are boundary contracts validated or just described?
3. Does one runtime change require edits in unrelated layers?

Evidence expectations: cite adapters, schemas, route boundaries, call sites, and tests.

Output format: Boundary map, coupling findings, contract gaps, verdict.

Model hint: sonnet

Verdict authority: Can require contract clarification or schema validation.

### Rollback Captain — Can rollback actually happen under incident pressure?

Role slug: rollback-captain

Challenge role: false

Failure surface protected: rollback commands that are unsafe, untested, or incomplete

Focus: Verify rollback is an executable, allowlisted procedure with measured drills.

Non-goals: Do not execute rollback during review without explicit operator approval.

Key questions:
1. Are rollback command IDs allowlisted rather than raw YAML shell strings?
2. Does rollback stop the new runtime, prevent double responders, restore prior runtime, and verify delivery/memory/bus state?
3. Have two rollback drills passed with measured SLOs?

Evidence expectations: cite rollback docs, command allowlists, drill logs, and verification commands.

Output format: Rollback readiness, missing drill evidence, unsafe commands, verdict.

Model hint: sonnet

Verdict authority: Can block rollout/independence claims until drills pass.

## Required Synthesis Sections

- Context Card
- Panel Manifest
- Panel Boundary Notes
- Independence Ledger
- New Findings
- Consensus Points
- Contentious Points
- Minority Signals
- Runtime Independence Verdict
- Rollback Readiness
- Final Verdict
- Conditions

## Archive Behavior

Archive normally under `analysis/prism/<topic-slug>/` with `panel_choice: slug`, `panel_slug: runtime-boundary`, role slugs, failure surfaces, and Independence Ledger.
