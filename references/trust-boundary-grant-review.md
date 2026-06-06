# Trust-Boundary Grant Review

Use this reference when a PRISM target changes grants, descriptor allowlists, source registration, capability matrices, provider trust boundaries, or any policy surface that decides which context/data can be exposed.

## Core rule

A clean diff, passing tests, and `MERGEABLE/CLEAN` GitHub state do **not** make a trust-boundary PR merge-ready. Treat semantic policy blockers as release blockers even when command verification passes.

## Review checklist

1. **Fail closed, not open.**
   - Missing grants, disabled grants, empty matrices, or unresolved source identity must deny by default.
   - Watch for helper APIs where `None`, `{}`, or omitted grant data silently means "allow all".

2. **Preserve denial semantics.**
   - Distinguish source-registration failures from explicit policy/grant denials.
   - Do not collapse "grant missing/disabled" into "source not registered" if operators need audit evidence for why access was denied.

3. **Audit reportable fields.**
   - Any denial reason, grant reason, source note, or descriptor note that can appear in receipts/logs/user-visible context must be safe to report.
   - Prefer enum/code fields or sanitized reason strings over arbitrary operator-authored free text.

4. **Test the negative path.**
   - Include fixture or unit coverage for: no grants; disabled grant; source registered but not granted; unknown source; allowed descriptor subset; disallowed descriptor.
   - Verify both returned data and the reason/status emitted in receipts.
   - If one authority resolver is wired into multiple public surfaces (for example several read tools backed by the same resolver), test each surface's allow path plus forged/widened denial path; do not let a proof on one surface stand in for the others.
   - Treat caller-selectable fixture authority as a policy surface. A `fixture_case` or similar selector that builds trusted authority must prove it cannot reach real backends/files/providers unless explicitly classified as live/backend-capable.
   - Distinguish process-owned authority from caller-selected fixture authority. If a process-owned env packet is route-narrowed, do not report that as applying to all synthetic fixture authority unless tests prove it.
   - For approval-gated receipt paths, verify missing/wrong approval denies before evaluating the protected operation or any helper that simulates it. Use monkeypatch/call counters when needed; output counters alone are not enough.
   - For subprocess/server tests, scrub authority opt-in env vars by default so “default-off” tests cannot inherit a developer/CI shell grant.
   - Unknown env/config authority values should fail closed into a structured denial/unverified envelope where possible, not raw tool errors.

5. **Watch self-servable approval surfaces.**
   - A surface that both returns an approval phrase/nonce and accepts that phrase/nonce is not proof of operator approval; it is an echo check.
   - If the same tool family emits the exact phrase and another CLI/MCP action accepts it, describe it as a mechanical acknowledgment unless there is out-of-band operator provenance.
   - Keep privileged approval-consumption paths off broadly exposed MCP/API surfaces unless an out-of-band or process-owned authority is present.
   - Do not let adjacent convenience endpoints (for example a runner tool with boolean opt-in args) bypass the newly gated path.
   - Do not publish README/runbook examples that derive an approval phrase and immediately feed it into the protected action; show denial examples or require a pasted external approval instead.

6. **Separate receipt permission from execution permission.**
   - For no-live metadata-only proof paths, broad fields like `execution_allowed: true` can be misread by downstream automation.
   - Prefer narrow fields such as `receipt_emission_allowed`, `local_metadata_tick_receipt_allowed`, or equivalent while keeping real execution flags false.

7. **Separate command PASS from semantic PASS.**
   - If tests pass but PRISM finds any fail-open path, ambiguous denial semantics, or unsafe reportable text, final verdict is `NEEDS WORK` until fixed.

## Synthesis language

When blockers are present, say plainly:

> Verification passed, but this is a trust-boundary semantic hold. Do not merge until [specific policy blocker] is fixed and negative-path tests prove the denial behavior.

## Origin

Extracted from a descriptor grant-matrix PR review where the PR was open, mergeable, clean, and tests passed, but Devil's Advocate identified semantic blockers: optional grant enforcement allowed all descriptors, missing/disabled grants collapsed to source-registration errors, and arbitrary grant reason text was reportable.
