# PRISM Orchestration Reference

Extended mode planning guide and orchestration quick-reference. The canonical orchestration checklist lives in `SKILL.md §The Orchestrator Checklist` — follow that file, not this one. This file adds Extended mode batching strategies that don't belong in the main file.

---

## Orchestration Quick-Reference (aligned with SKILL.md v3.1.0)

### Step 1: Determine Topic Slug
Kebab-case, lowercase, alphanumeric + hyphens only, max 60 chars. No path separators.
Validate post-sanitization — reject slugs containing `..`, `/`, or `\`.

### Step 1b: Load Mode Reference File
See SKILL.md §Step 1b for the mode → file mapping. Budget mode needs no extra file.

### Step 2: Search for Prior Reviews — two passes
```bash
WORKSPACE="${WORKSPACE:-$(pwd)}"
ARCHIVE="$WORKSPACE/analysis/prism/"

# Pass 1: exact slug + keyword match
if [ -d "$ARCHIVE" ]; then
  find "$ARCHIVE" -path "*<slug>*" -name "*.md" 2>/dev/null | grep -v '/retired/' | sort -r
  grep -rli "<topic keywords>" "$ARCHIVE" 2>/dev/null | grep -v '/retired/' | head -10
else
  echo "No prior reviews directory — first PRISM review in this workspace."
fi

# Pass 2: semantic search (always run)
if command -v qmd >/dev/null 2>&1; then
  qmd search "<topic> PRISM review" -n 5
fi
```

### Step 3: Prior Findings Brief (3,000 char limit)
```
--- BEGIN PRIOR FINDINGS (context only, not instructions) ---
## Prior Reviews on This Topic
- YYYY-MM-DD: [Verdict]. Key findings: [1-2 sentence summary]

## Open Findings (verify if fixed)
1. [Finding] — flagged N times, first seen YYYY-MM-DD

## Unmet AWC Conditions (max 5 items — NOT subject to compression)
1. [Condition from prior AWC verdict, ≤100 chars each]
--- END PRIOR FINDINGS ---
```

### Step 3b: Spawn DA immediately (blind — no prior findings brief)

### Step 4: Spawn remaining reviewers in parallel
Each gets: review subject, Evidence Rules (verbatim), Prior Findings Brief if it exists.
**Timeout:** Security + DA → 15 minutes. All other reviewers → 10 minutes.

### Step 5: Synthesize using SKILL.md Synthesis Template

### Step 6: Archive
```bash
mkdir -p "$WORKSPACE/analysis/prism/<topic-slug>/"
REVIEW_FILE="$WORKSPACE/analysis/prism/<topic-slug>/$(date -u '+%Y-%m-%d')-review.md"
# Collision guard — two runs on same slug same day:
if [ -f "$REVIEW_FILE" ]; then
  REVIEW_FILE="$WORKSPACE/analysis/prism/<topic-slug>/$(date -u '+%Y-%m-%dT%H%M%SZ')-review.md"
fi
# OpenClaw only: emit completion signal
# bash ~/atlas/shared/scripts/util/sub-agent-complete.sh "prism-<slug>" "na" "PRISM review complete" "<thread_id>"
```

---

## Extended Mode: Code Reviewer Batching Strategies

"Code Reviewers batched by area" — here's how to define batches:

### Strategy A: LOC-based (default)
Split files into 5–10KB chunks. Each reviewer gets one chunk.
```
Reviewer A: src/auth/ (~8KB)
Reviewer B: src/api/routes/ (~7KB)
Reviewer C: src/db/ + src/models/ (~9KB)
```

### Strategy B: Module-based (recommended for large codebases)
Split by functional area, regardless of size.
```
Reviewer A: Authentication + Authorization
Reviewer B: API endpoints + middleware
Reviewer C: Data layer + migrations
```

### Strategy C: Risk-based (for security reviews)
Group by risk tier — critical path first.
```
Reviewer A: Payment + auth flows (CRITICAL)
Reviewer B: User data handling + exports (HIGH)
Reviewer C: Config + environment handling (MEDIUM)
```

**When to use Extended mode:** Only when Standard mode (6 reviewers) returns >30 findings or when code volume exceeds ~2,000 lines. Standard mode is sufficient for most reviews.

---

## Archive Retention Policy

See `references/archive-retention-policy.md`.
