# Supply-chain incident review mode

Use when PRISMing JavaScript/npm, Python package, or provider-runtime work while an active supply-chain compromise is being triaged.

## Principle

A review can remain useful without executing package-manager or package-script code. During an active incident, prefer source reads, lockfile inspection, config inspection, existing artifact review, and non-mutating system probes.

## Default freeze

Until the operator or security owner clears exposure, do not run:

- dependency mutation: `npm install`, `npm update`, `npm audit fix`, `yarn`, `pnpm`, equivalent package-manager writes;
- lockfile mutation or provider SDK addition;
- package scripts that execute local dependency binaries, unless explicitly approved: `npm run build`, `npm run typecheck`, `npm run dev`, `pnpm test`, etc.;
- live provider/credential/OAuth tests that are not necessary for the review.

Package scripts are not dependency mutation, but they are still code execution through the local dependency tree. Treat them as a separate approval gate during incident windows.

## Safe review actions

- Read source/config/docs directly.
- Use `git status`, `git log`, `git diff --check`, `date`, `curl` to local health endpoints, and targeted `python3`/shell parsing.
- Run project-owned preflight scripts only when they explicitly document that they do not read secrets, connect to external services, start daemons, or invoke package scripts.
- If a preflight script has an auto-build fallback, treat that path as unsafe until patched or explicitly approved.

## Findings to look for

1. Auto-build or auto-install paths in launchers.
2. Stale build artifacts that would trigger package scripts.
3. Caret/range dependencies and lockfile mutation risk.
4. Provider SDK additions hidden inside “certification” or “matrix” work.
5. Gate language that turns doc/design review into live execution pressure.

## Recommended output language

- “APPROVE WITH CONDITIONS for design-only work; NEEDS WORK for live execution.”
- “Do not run package scripts or live provider tests until exposure triage clears.”
- “Keep status as reviewed/held/pending, not closed, when verification commands are intentionally skipped for safety.”

## Concrete mitigation pattern

If a supervised launcher auto-builds when dist is stale, prefer fail-closed behavior during incident windows:

```bash
if [ "$DIST_STATUS" != "current" ]; then
  echo "[fatal] dist not current; refusing package-script build during supply-chain freeze" >&2
  exit 1
fi
```
