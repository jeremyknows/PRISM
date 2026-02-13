# PRISM 🔮

**Parallel Review by Independent Specialist Models**

Multi-agent review protocol that eliminates confirmation bias through structured adversarial analysis.

## What It Does

- 🔒 Deploys 5+ specialist reviewers in parallel (Security, Performance, Simplicity, Integration, Devil's Advocate)
- 🎯 Surfaces disagreements as the most valuable signal
- 😈 Uses Devil's Advocate to catch assumptions and "6-month regrets"
- 📊 Synthesizes findings into actionable decisions with confidence levels
- ⚡ Works with parallel subagents OR sequential single-agent review

## The Core Insight

> "Disagreements are MORE valuable than consensus."

When 4/5 reviewers agree and 1 dissents, pay attention to that dissent. The tension is where truth lives.

## Install

### Claude Code / OpenClaw

```bash
# Clone to your skills directory
git clone https://github.com/jeremyknows/PRISM.git ~/.openclaw/skills/prism

# Or add to CLAUDE.md
echo "Skill: ~/.openclaw/skills/prism/SKILL.md" >> CLAUDE.md
```

### Cursor / Other Agents

```bash
git clone https://github.com/jeremyknows/PRISM.git
# Reference SKILL.md from your agent's configuration
```

## Usage

### Quick Start

Just ask your agent:

| Want This | Say This |
|-----------|----------|
| Budget check (3 agents) | "Budget PRISM" or "PRISM lite" |
| Standard review (5 agents) | "Run PRISM" or "PRISM review" |
| Deep audit (9 agents) | "Full PRISM audit" or "Extended PRISM" |

**Model override:** Add `--opus` for critical decisions, `--haiku` for fast checks (default: Sonnet)

### Examples

```
"Budget PRISM on this API change"

"PRISM review on this architecture decision"

"Full PRISM audit — we're about to ship this to production"

"PRISM --opus on this auth flow" (uses Opus for extra rigor)
```

### Structured Request

For complex reviews, provide context:

```markdown
## PRISM Review Request

**Mode:** Standard
**Subject:** REST to GraphQL migration
**Context:** Currently serving 10K req/day, team has GraphQL experience
**Focus:** Performance implications and migration complexity
```

## The Reviewers

| Reviewer | Focus | Key Question |
|----------|-------|--------------|
| 🔒 Security Auditor | Attack vectors, trust boundaries | "How could this be exploited?" |
| ⚡ Performance Analyst | Metrics, benchmarks | "Show me the numbers" |
| 🎯 Simplicity Advocate | Complexity reduction | "What can we remove?" |
| 🔧 Integration Engineer | Compatibility, migration | "How does this fit?" |
| 😈 Devil's Advocate | Assumptions, risks | "What are we missing?" |

## Pro Tips

1. **Devil's Advocate is the most valuable reviewer.** If they approve with no conditions, you probably haven't thought it through.

2. **"6-month regrets" is the killer question.** Forces thinking beyond immediate benefits.

3. **Numbers beat vibes.** Performance Analyst grounds the discussion in reality.

4. **Technical controls > Process controls.** Devil's Advocate catches when you're trading enforcement for trust.

## When to Use PRISM

**High value:**
- Architecture decisions (irreversible, high stakes)
- Security-sensitive changes
- Major refactors (>1000 lines)
- Policy/role card validation
- Open source releases
- Decisions you'll live with for 6+ months

**When NOT to use PRISM:**
- ❌ Minor bug fixes (overkill)
- ❌ Documentation typos (just fix them)
- ❌ Cosmetic/UI tweaks (unless user-facing and high-traffic)
- ❌ Urgent hotfixes (time matters more than thoroughness)
- ❌ Decisions that are easily reversible (just try it)
- ❌ When you already know the answer (don't seek validation theater)

**The "reversibility test":** If you can easily undo this decision in a week, skip PRISM. If undoing it requires significant effort or causes user pain, run PRISM.

## Cost Estimate

| Approach | Sonnet (default) | Opus (--opus) |
|----------|------------------|---------------|
| **Budget** (3 specialists) | ~$0.30-0.50 | ~$1.00-1.50 |
| **Standard** (5 specialists) | ~$0.50-1.00 | ~$2.00-3.00 |
| **Extended** (9 agents) | ~$1.50-2.00 | ~$5.00-7.00 |

**Budget Mode** runs Security + UX/Accessibility + Performance only — catches ~80% of high-impact issues at 60% cost. Security is MANDATORY and cannot be skipped.

**Two-round audit** (recommended): Double the time, 3x the coverage. Round 2 finds issues Round 1 misses.

The cost of a missed security flaw is 10-100x higher.

## Done Criteria

Stop auditing when:
- ✅ No CRITICAL or HIGH issues remaining
- ✅ Re-audit finds < 3 new issues
- ✅ Remaining items are all LOW priority

## Example Output

```markdown
## PRISM Synthesis

### Consensus Points
- All reviewers agree the simplification is valuable
- Security model is acceptable with mitigations

### Contentious Points  
- Devil's Advocate: "We're replacing technical control with process control"
- Simplicity vs Security tension on audit logging

### Conflict Resolution
Security Auditor approved with conditions; Devil's Advocate raised concerns
but no REJECT. Siding with majority, incorporating Devil's concerns as
condition #1 (automated scanning addresses their "process control" worry).

### Final Verdict
APPROVE WITH CONDITIONS (75% confidence)

Conditions:
1. Add automated security scanning (addresses Devil's Advocate concern)
2. Document the trust model explicitly
3. Plan for future audit logging if needed
```

## File Structure

```
prism/
├── SKILL.md        # Main skill instructions
├── LICENSE.txt     # MIT license
├── README.md       # This file
└── references/
    └── example-review.md  # Full review transcript
```

## Security

PRISM is a review protocol, not a code execution tool. It:
- Does not execute arbitrary code
- Does not access external systems
- Only reads what you provide for review

## Limitations

- Requires agent with sufficient context window for full review
- Parallel execution requires subagent spawning capability
- Quality depends on reviewer prompts (provided in SKILL.md)
- Not a replacement for human review — an enhancement

## Anti-Patterns

**Don't:**
- ❌ Let reviewers see each other's findings (groupthink)
- ❌ Ask reviewers to "find everything" (noise)
- ❌ Skip synthesis (raw findings aren't actionable)

**Do:**
- ✅ Spawn reviewers in parallel (independent perspectives)
- ✅ Give each reviewer narrow focus (depth > breadth)
- ✅ Iterate if >50 issues found (refine scope)

## Red Flags

| Sign | Problem | Fix |
|------|---------|-----|
| All reviewers find same issues | Not diverse enough | Sharpen role distinctions |
| >100 issues found | Scope too broad | Narrow review target |
| Vague findings | Prompts too generic | Add specific focus questions |
| Zero disagreements | Possible groupthink | Check reviewer independence |

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| Reviews too shallow | Insufficient context | Provide more background in request |
| All reviewers agree | Topic too simple | PRISM may be overkill for this |
| Devil's Advocate has no concerns | Suspiciously perfect | Re-run with "find something wrong" |
| Takes too long | Sequential execution | Use parallel subagents if available |

## Contributing

PRs welcome! Especially:
- New reviewer perspectives
- Example reviews from real usage
- Integration guides for other agents

## License

MIT — See [LICENSE.txt](LICENSE.txt)

---

*"The specialists optimize. The Devil protects you from yourself."*
