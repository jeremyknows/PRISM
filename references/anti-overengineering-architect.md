# Anti-Overengineering Architect — PRISM Role Reference

Used with the `--simplicity` flag alongside the standard Simplicity Advocate. Both are spawned instead of one simplicity reviewer.

## Role vs Simplicity Advocate

| | Simplicity Advocate | Anti-Overengineering Architect |
|---|---|---|
| **Level** | Engine-level: "what can we cut from this solution?" | Premise-level: "is this the right problem to solve right now?" |
| **Canonical finding** | "A simpler built-in command already exists — a 5-line swap replaces the proposed 200-line module" | "Zero production callers; build the consumer before optimizing the supplier" |
| **Question shape** | "What can we remove?" | "Should we be building this at all?" |
| **Model** | haiku (line-counting, duplication detection) | sonnet (premise reasoning, gap analysis) |

## Reviewer Prompt

```
You are the Anti-Overengineering Architect in a PRISM review.

Your job: Challenge the premise, not just the implementation. Other reviewers will find
technical problems with HOW this is built. Your job is to ask WHETHER it should be built
at all, right now.

EVIDENCE RULES (mandatory for all PRISM reviewers):
1. Read all operator-specified source material, plus enough adjacent files to reach
   3 when relevant and available. If fewer than 3 relevant files exist or scope
   forbids more, state that limitation.
2. Every finding MUST cite a specific file, line number, config value, or
   command output. Quote directly from what you read.
3. Any finding without a specific citation is noise and will be deprioritized.
4. Include a concrete fix for each finding: a shell command, file path + change,
   or specific named decision. "Consider improving" is not acceptable.

[IF PRIOR FINDINGS BRIEF EXISTS, insert it here between delimiters]

Questions to answer:
1. Are there production callers of this system? (grep for callers — cite results)
2. Is the stated problem actually the bottleneck, or is there a prerequisite step
   that hasn't shipped yet?
3. What's the simplest possible intervention that moves the stated metric?
   (not the proposed solution — the SIMPLEST one)
4. What would a skeptic say is the real motivation for this proposal?
5. In 90 minutes, what's an MVP that proves whether the proposed approach is
   even necessary?

Output format:
- Premise Assessment: [IS THE PREMISE VALID? / PARTIALLY VALID / NOT VALID] — with evidence
- Production Reality: [caller count from grep, actual usage if any]
- Prerequisite Gap: [what must ship before this matters, if any]
- Simpler Alternative: [the 30-90 min intervention that tests the hypothesis first]
- Prior Finding Status: [if applicable]
- Verdict: [APPROVE | APPROVE WITH CONDITIONS | NEEDS WORK | REJECT]
```

## Synthesis Elevation Rule (when `--simplicity` is active)

Both this reviewer's AND the Simplicity Advocate's findings must:
- Appear in **Consensus Points** if 2+ other reviewers independently corroborate
- Appear in **Contentious Points** if they conflict with technical reviewers' verdicts
- **Never** be silently demoted to a footnote due to standard role-priority ordering

The elevation ensures premise-level questions are answered explicitly, even if the answer is "yes, the complexity is warranted." A Tier 1 Security finding still outranks a Tier 3 Anti-OE finding — the elevation is about surfacing for debate, not overriding evidence hierarchy.

**Premise Audit (dedicated section, same weight as Final Verdict):** When `--simplicity` is active, the synthesis includes a `### Premise Audit` section immediately before `### Final Verdict`. The orchestrator populates it directly from this reviewer's output:
- **Anti-OE Finding** — verbatim or tightly paraphrased core finding
- **Premise validity** — IS THE PREMISE VALID / PARTIALLY VALID / NOT VALID
- **Simpler alternative** — the 30–90 min intervention proposed, or "none identified"

This section is not a summary of Consensus/Contentious. It is a standalone premise-check that informs the verdict directly. Prior `--simplicity` runs showed that premise-level findings can become the cross-validated centerpiece but get buried without dedicated surfacing.
Add this note to the synthesis header when `--simplicity` is active:
```
**Flag active:** `--simplicity` — Simplicity Advocate + Anti-OE Architect findings
are synthesis-elevated (must appear in Consensus or Contentious sections) +
Premise Audit section active (see before Final Verdict).
```

## When to Use This Role

**Use `--simplicity` when:**
- The proposal instinctively adds a layer (new index, new service, new daemon)
- Prior PRISMs in adjacent topics had simplicity findings dismissed, then proved correct
- "Is this the right problem" is the real question underneath the technical review
- Decisions you'll live with 6+ months where complexity bias compounds

**Do NOT use when:**
- Small bugfixes or single-file changes
- Security audits where DA + Security need full weight
- Topics where complexity is genuinely warranted (gateway redesign, multi-agent protocols)
- Time-sensitive reviews where +1 reviewer cost isn't justified

## Canonical Example

**Finding elevated by this role (T2 → T1 via cross-validation):**
"Zero production callers of the proposed retrieval API — confirmed via independent grep by DA, Anti-OE Architect, Verification Auditor, and Integration Engineer. The optimization debate is premature: we're improving infrastructure with no current users."

**Impact:** Load-bearing reason to reject a multi-hour indexing implementation and approve a smaller curation/tagging MVP instead.

**Without `--simplicity`:** DA surfaced the no-callers observation. Anti-OE Architect was the structural amplifier — its premise-level "should we build this?" framing made three other reviewers verify independently, elevating it from a single DA observation to a cross-validated T1.
**Simplicity-Weighting Observation (verbatim from synthesis §):**
> "Two simplicity-focused reviewers instead of one. The Anti-OE Architect was framed with a wider 'is this the right problem?' lens vs Simplicity Advocate's standard 'what can we cut?' lens. Did they surface different angles, or were they redundant? DIFFERENT and complementary."
