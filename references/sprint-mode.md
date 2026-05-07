# PRISM Sprint Mode

*Load this file when invoked with: `"sprint PRISM"` / `"PRISM sprint on <repo>"` / `"code review sprint"`*

---

Sequential PRISM code reviews across a codebase's PRD slices/issues in build order. Each review runs the standard PRISM protocol, then Watson applies quick fixes inline and delegates the rest to a designated agent (default: Builder). The confirmation gate between issues is intentional — not just synchronization.

**Production-validated:** VibetownFM 2026-05-07 (7 issues, 9 PRISM reviews including one re-review after Jeremy challenged Budget mode on the primary user-facing issue).

---

## When to use Sprint mode

- A codebase has been built slice-by-slice and you want each slice reviewed in build order
- You want fixes applied as you go, not a report to act on later
- You have a delegatable agent who can receive conditions and confirm completion

**Not for:** single-file reviews (use Budget/Standard), open-ended "find what's wrong" with no issue structure (scope first with prd-to-issues).

---

## Scope setup

When issue criticality or fix ownership isn't obvious, define scope before starting (analogous to Sprint skill's G0 premise check):

```
Premise check:
- git log --oneline          — confirm actual build order
- git show --stat <commit>   — confirm actual files per issue
- Note any issues partially fixed by later commits
```

Post scope to Jeremy before starting if: (a) criticality is ambiguous on 2+ issues, or (b) fix ownership is unclear.

**Criticality → reviewer depth:**
| Signal | Reviewer depth |
|--------|----------------|
| User-facing UI (primary page, onboarding) | Standard (6) |
| Auth, billing, session management | Standard (6) |
| Background pipelines, data layer | Budget (3) |
| Infrastructure, KV setup, config | Budget (3) |
| CSS, animations, scene props | Budget (3) |
| Utility scripts, one-off tools | Budget (3) |

Jeremy can always override with "isn't this the most important part?" — escalate without re-justifying.

---

## Per-issue loop

**1. Read current state** — `git show --stat <commit>`. Note if later commits already patched issues here.

**2. Spawn reviewers (parallel)** — Budget (3) or Standard (6) based on criticality. Each reviewer gets: files list (absolute paths), Evidence Rules, focus areas tuned to issue type.

**3. Synthesize** — Tier by cross-validation: T1 (2+ reviewers cited) → P0/P1; T2 (single cited) → P1/P2; T3 (no citation) → deprioritize.

Assign owner per finding:
- **Watson applies directly:** < 5 lines, non-architectural, no layout impact. Examples: silent `catch {}`, type mismatch in a single KV call, missing `aria-*`, module-level throw moved inside handler.
- **Delegate to agent:** Architectural (component wiring, file restructuring), requires build verification, changes multiple files in concert.

**4. Apply Watson's quick fixes** — Edit → build check → commit.

Commit format: `<area>: PRISM #N <label> — <what + why>`

**5. Dispatch conditions** — Via `dispatch-send.sh`. Keep message < 2000 chars (Discord limit — split if needed). Format:

```
**PRISM #N — [verdict]** (<slug>, commit <hash>)

Watson applied: <list + commit>

P0 — [agent] owns:
1. <file:line — concrete fix>

P1 — same pass:
2. ...

Full findings: ~/atlas/agents/watson/analysis/prism/<slug>/YYYY-MM-DD-review.md
```

**6. Confirmation gate** — Wait for agent to post status with ✅ per condition + test count + commit hash. This is the primary signal — **don't advance until you have it**.

The gate produces value beyond synchronization: the agent may discover the fix requires upstream changes, or find the same bug in 3 places. Catching that before you move on preserves context.

**Timeout fallback:** 15 minutes → advance, note `"timeout advance"` in archive, check agent channel for errors first.

**7. Archive** — `analysis/prism/<issue-slug>/YYYY-MM-DD-review.md` — then advance.

---

## Sprint completion

Post summary table to the channel:

```
| Issue | Verdict | Fix commits | Open conditions |
|-------|---------|-------------|-----------------|
| #N slug | ✅ AWC→Fixed | abc1234 | None |
```

Note any remaining Jeremy-only items (domain setup, production credentials, launch QA).
