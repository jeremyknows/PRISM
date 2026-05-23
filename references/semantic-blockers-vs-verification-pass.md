# Semantic blockers vs verification PASS

Use this reference when an Extended PRISM run has a clean command/verification panel but specialist panels identify contract or semantic failures.

## Pattern

A Verification Auditor PASS means the declared commands ran and artifacts exist. It does **not** mean the change is packageable if another panel proves a contract violation with executable evidence.

Treat these as blockers even when tests/checks pass:

- Narrow-only/auth semantics violated by a reproducible call (for example an explicit empty allowlist widening to defaults).
- Degraded/fallback contract violated by a backend exception escaping instead of returning a shaped degraded envelope.
- Direct adapter proof being described as wrapper/service/runtime proof when the route path does not exercise that adapter.
- Future real-source safety claims relying on synthetic-only fixtures or blocklist-only path hygiene.

## Synthesis rule

If Code Review, Security, or Devil's Advocate produces a concrete repro or file:line evidence of a contract violation, final verdict should be `NEEDS_WORK` even if Verification Auditor reports `PASS`.

Write this plainly:

```md
Verification commands passed, but semantic PRISM blockers override a package-ready verdict.
```

## Minimal final report shape

- Lead with `NEEDS_WORK / NO PACKAGE YET`.
- List exact blockers first, not panel summaries.
- Include command evidence separately under “Verification passed.”
- Distinguish current no-live/default-off safety from package/contract readiness.
- Preserve holds explicitly; do not let “tests pass” become Gate/package movement.

## Example blocker classification

```md
Tier 1 blocker — empty auth ceilings widen private scope access
Evidence: `_policy()` uses `allowed_scopes or default_scopes`; fresh repro shows `allowed_scopes=[]` still authorizes private context.
Fix: distinguish `None` from empty iterable and add regression tests.
```

```md
Tier 1 blocker — backend exceptions escape instead of returning degraded envelopes
Evidence: backend call raises `RuntimeError`; no degraded response is returned.
Fix: wrap each backend independently and preserve partial results where possible.
```
