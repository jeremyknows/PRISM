## v3.0.0 (2026-04-20)

**"PRISM Wiki Mode"** — adds a dedicated 3-reviewer mode for documentation quality review.

### New Features
- **Wiki mode:** `"PRISM this wiki"` invokes Technical Accuracy + Completeness + DA reviewers
- **Typed modes:** First step toward mode-based reviewer selection (wiki vs standard vs budget)
- **Post-verdict actions:** Defined APPROVE/AWC/NEEDS WORK/REJECT behavior for autonomous pipeline
- **File access constraints:** Reviewer prompts now scope reads to `~/atlas/` and `~/projects/` only
- **DA isolation hardening:** Wiki DA explicitly blocked from reading `analysis/prism/` archives
- **Atlas Fitness questions:** DA now checks actionability in current Atlas phase + QMD safety
- **Semantic prior-review search:** Step 2 now runs QMD search as a mandatory second pass (catches adjacent topics with different slugs)
- **Archive path clarification:** Current convention is `analysis/prism/<slug>/` (no `archive/` subdirectory)

### Breaking Changes
- Archive path corrected from `analysis/prism/archive/<slug>/` (v2.0.0 docs) to `analysis/prism/<slug>/` — skill-doctor archive path needs updating to match

### Internal
- Prose consistency: "v2 Flow" heading renamed to "Orchestrator Checklist"
- Version intro line updated to reflect both v3 and v2 additions

## v2.0.1 (2026-03-13)

### Fixes
- Removed internal `SKILL-v1.md` archive from published package

## v2.0.0 (2026-03-08)

**"PRISM That Remembers"** — validated through 19 PRISM reviews across 3 rounds (eating our own cooking).

### New Features
- **Memory:** Prior Review Search — reviewers see what previous reviews found
- **Evidence rules:** Mandatory file citations in every finding (inline in each prompt)
- **Devil's Advocate independence:** Structurally blind to prior findings; spawns first
- **New verdict:** NEEDS WORK — between AWC and REJECT
- **Evidence hierarchy:** Tier 1/2/3 ranking (cross-validated > cited > uncited)
- **Actionability requirement:** Shell command or file path required per finding
- **Synthesis upgrade:** New Findings first, conditional history sections, Limitations section
- **Archive protocol:** Searchable review history in `analysis/prism/archive/<slug>/`
- **Governance mode:** `--governance` flag for stuck findings tracking
- **Verification Auditor:** New Extended mode role — verifies claims exist on disk
- **Orchestrator Checklist:** Mechanical step-by-step, no ambiguity
- **Timeout policy:** 10-minute reviewer timeout with partial synthesis
- **Archive safety:** `mkdir -p` + write-failure warning
- **Brief injection delimiters:** `--- BEGIN/END PRIOR FINDINGS ---` for prompt injection protection
- **DA early spawn:** Step 3b spawns DA immediately, saves 25-90s per review

### Breaking Changes
- Synthesis template format changed (new sections, conditional rendering)
- Archive path convention: `analysis/prism/archive/<kebab-slug>/YYYY-MM-DD-review.md`

### Validation
- Round 1: 5 specialists on the plan (4 AWC, 1 NEEDS WORK)
- Round 2: 5 specialists reframed for "just works" UX (2 NEEDS WORK, 2 AWC, 1 AWC upgraded from NW)
- Round 3: 9-agent Extended PRISM on the implementation (3 NEEDS WORK, 1 SIMPLIFY, 4 AWC, 7/7 verification pass)
- All findings applied before release

## v1.0.0

- Initial release: parallel subagent spawning, 5 specialist roles, synthesis protocol
- Severity normalization, cost estimates, model selection
- Two-round audit workflow
