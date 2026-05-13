# Operational State PRISM

Use this reference when PRISM reviews an active operational posture rather than a code diff: runtime gates, live safety constraints, supply-chain incidents, canary readiness, or production-route decisions.

## Trigger examples

- User asks to PRISM “the state of our operations.”
- A gate/canary/production migration is about to advance.
- External incident changes what commands are safe, e.g. dependency supply-chain compromise.
- Docs, live runtime, and evidence disagree about current posture.

## Review stance

1. Separate **directional architecture** from **current implemented state**.
   - Good: “Shadow is the reference certification lane candidate.”
   - Risky: “Shadow is universal” before multiple provider/delivery routes pass.
2. Prefer precise gate states over optimistic closure:
   - `reviewed_hold`
   - `provider_matrix_design_pending`
   - `design_only`
   - `staging_only`
   - `canary_candidate`
   - Avoid unqualified “accepted,” “closed,” or “implemented” unless implementation evidence exists.
3. Treat active incident constraints as part of the review scope.
   - If npm/package supply chain is under investigation, “no package mutation” is not enough; also check whether package scripts (`npm run build`, `npm run typecheck`, `npm run dev`) would execute local dependency code or auto-build paths.
4. Archive the synthesis and update governing docs if the verdict changes posture.

## Evidence to collect

Use read-only/static checks unless execution is explicitly safe.

- Git branch/HEAD/status for each relevant worktree.
- Live health/port state for runtime processes.
- Gate scorecard current status and blocker language.
- Twin Anchors / master baton / vision doc current terminology.
- Launcher/preflight scripts for hidden execution paths.
- Executable mode flags / environment knobs that imply later gates (for example `canary`, `production`, `cutover`, `write`, `publish`). Verify they fail closed until the corresponding rollback/abort/approval semantics exist; do not rely on docs that say “do not use” if code still accepts the mode.
- Config fixtures for current provider/model/access assumptions.
- Prior PRISM reviews only as context for non-Devil’s-Advocate reviewers.

## Reviewer prompts to emphasize

Ask reviewers to answer:

- What is safe to do **now**?
- What is directionally right but overclaimed?
- What command/path could accidentally execute risky work?
- What mode flag, env var, route state, or CLI option still accepts a future-gate behavior before the gate exists?
- What wording prevents future sessions from closing gates prematurely?
- What documentation or scorecard state must change before proceeding?

## Supply-chain incident checks

During an active dependency supply-chain caution, require explicit status for:

- dependency mutation: `npm install`, `npm update`, `npm audit fix`, `yarn`, `pnpm`
- package script execution: `npm run build`, `npm run typecheck`, `npm run dev`
- lockfile mutation
- provider SDK addition
- runtime launcher auto-build behavior
- live provider calls / OAuth refreshes

Safe default: docs/design/read-only only until the operator or designated incident owner clears execution.

## Synthesis language pattern

Use a two-part verdict when appropriate:

> APPROVE WITH CONDITIONS for design-only work. NEEDS WORK for gate closure or live execution.

Then define the next safe action narrowly, e.g.:

> Create a non-executing provider matrix spec and keep Gate 2 as reviewed-hold; do not run live provider tests or package scripts.

## Output requirements

- Final verdict with separate design/live statuses.
- Tiered findings with file/line or command-output citations.
- Explicit “do not run” list when incident constraints exist.
- Recommended gate/status wording.
- Explicit fail-closed requirements for any executable future-gate toggles discovered during review.
- Archive path under `analysis/prism/<topic-slug>/...`.
- If posture changes, update Twin Anchors/gate scorecard in the same scoped docs change.
