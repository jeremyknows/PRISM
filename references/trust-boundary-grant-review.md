# Trust-Boundary Grant Review

Use this reference when a PRISM target changes grants, descriptor allowlists, Memory Seam source registration, capability matrices, provider trust boundaries, or any policy surface that decides which context/data can be exposed.

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

5. **Separate command PASS from semantic PASS.**
   - If tests pass but PRISM finds any fail-open path, ambiguous denial semantics, or unsafe reportable text, final verdict is `NEEDS WORK` until fixed.

## Synthesis language

When blockers are present, say plainly:

> Verification passed, but this is a trust-boundary semantic hold. Do not merge until [specific policy blocker] is fixed and negative-path tests prove the denial behavior.

## Origin

Extracted from a Memory Seam descriptor grant-matrix PR review where the PR was open, mergeable, clean, and tests passed, but Devil's Advocate identified semantic blockers: optional grant enforcement allowed all descriptors, missing/disabled grants collapsed to source-registration errors, and arbitrary grant reason text was reportable.
