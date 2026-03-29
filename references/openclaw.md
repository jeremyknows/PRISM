# PRISM — OpenClaw-Specific Reference

This file contains OpenClaw-specific configuration and autoresearch data.
It is not needed when running PRISM in Claude Code or Cowork.

## Autoresearch Baseline

**Baseline:** 6.5/12 (Phase 1 audit, 2026-03-18 — first formal audit)
**Post-improvement:** 10/12 (v2.1.0, 2026-03-18)

**Mutation candidates:**
1. Add single-haiku pre-checker mode (sub-$0.002 for <50 line changes)
2. Empirically validate evidence tier system — do Tier 1 findings get resolved faster?
3. Add DA-First scheduling mode: DA runs, reports, then all 5 run with DA brief injected (vs current: DA blind always)

**Improvement log:**

| Date | Version | Change | Score |
|------|---------|--------|-------|
| 2026-03-18 | v2.0.1 | Existing published version | 6.5/12 |
| 2026-03-18 | v2.1.0 | PRISM self-audit: trigger conditions, gotchas, dependencies, model guide, archive retention, Extended mode batching, Evidence Rules deduplication, orchestration extraction | 10/12 |

## Completion Routing

Archive completion via:
```bash
bash ~/.openclaw/scripts/sub-agent-complete.sh "prism-<slug>" "na" "PRISM review of <slug> complete" "<originating_thread_or_channel_id>"
```

The 4th argument routes the notice back to the Discord thread/channel where PRISM was initiated.

## Skill Logging

After a PRISM run, log outcome:
```bash
bash ~/.openclaw/agents/main/workspace/scripts/log-skill-run.sh "prism" "<outcome>"
```
