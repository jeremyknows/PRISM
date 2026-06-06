# Trust-boundary MCP fixture authority review

Use this reference when reviewing MCP/local authority, no-live fixture cases, approval-gated local ticks, or shared read boundaries where tests pass but operator-facing claims may overstate the authority boundary.

## Pattern

A denied/default-off MCP tool can be safe in isolation while adjacent MCP fixture authority still creates a semantic trust-boundary blocker.

Watch for these shapes:

1. **Caller-selectable fixture authority.** If an MCP tool accepts a `fixture_case`, `mode`, `scope`, or similar selector that builds trusted authority, treat it as a policy surface, not just a test helper.
2. **Fixture authority reaching real backends.** A synthetic grant is not automatically no-live. Trace from the fixture grant to the endpoint implementation and prove real backends/files/providers cannot be reached, or classify the surface as live/backend-capable.
3. **Process-owned authority vs caller-selected fixture authority.** Do not collapse them in reports. A process-owned env packet may be route-narrowed (for example one read route only) while caller-selected fixture authority still permits a second read route for no-live metadata tests.
4. **Self-servable approval phrases.** If one MCP/CLI surface emits an exact approval phrase and another accepts it, that is a mechanical acknowledgment, not operator authority, unless an out-of-band human/operator proof exists.
5. **Current-floor drift.** If a new PR adds a receipt/control surface, but fixtures/docs still cite older source floors, command PASS does not make the docs execution authority. Either ratchet the floor or mark older floors historical.

## Evidence to require

- MCP tool schema for authority-bearing tool inputs.
- Fixture allowlist / grant construction lines.
- Endpoint dispatch lines from MCP wrapper to backend.
- Backend read path lines proving whether diary/wiki/file/provider calls can happen.
- Negative-path tests with counters/monkeypatches that prove denial before backend/file access.
- Operator-facing docs/README lines that describe available fixture families, compared against the actual allowlist constants/tests.
- Current `HEAD` / `origin/main` / open-PR state and the fixture/docs source-floor values.

## Verdict rule

Use `NEEDS_WORK` when a caller-selectable MCP fixture can authorize a real backend path while docs claim the surface is no-live/project-doc-only, even if focused tests pass. This is a semantic trust-boundary blocker, not a command-verification failure.

Use `AWC` when runtime authority is provably no-live/metadata-only by construction, but operator-facing docs under-name or stale-name the available fixture families (for example docs name only one fixture family while code also exposes additional metadata fixtures). Treat docs as part of the trust boundary, but do not escalate to `NEEDS_WORK` unless the mismatch can cause real backend/file/provider access, self-servable approval, or service/runtime authority overclaim.

Use `APPROVE` only when the potentially confusing authority is provably no-live by construction and the docs/test names label it as fixture-only.

## Remediation patterns

- Remove private/backend-capable fixture cases from MCP-callable allowlists.
- Replace backend-capable fixture cases with hard no-live stubs that cannot import/call real backend adapters.
- Add regression tests that denied fixture cases fail before backend access.
- Rename self-servable approval phrases to mechanical acknowledgments, or require out-of-band operator provenance.
- Remove README examples that obtain an approval phrase and immediately feed it back into the action command.
- Add source-floor ratchet tests or explicit `historical_floor` labels.

## Origin

Captured from an MCP-authority PRISM review. A narrow, default-off local-tick canary MCP tool was safe and denied-only, but adjacent MCP fixture authority and docs created overclaim risk: a fixture grant path was MCP-callable, the approval phrase was mechanically derivable, and active control-plane docs/fixtures were still anchored to older source floors.