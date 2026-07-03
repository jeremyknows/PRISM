# Panel: client-deliverable

Use for reviewing an **outward-facing deliverable before it reaches a client/stakeholder** — a demo, a walkthrough video, a handoff packet, a pitch, a shared artifact. Distinct from a code/architecture review: the failure mode here is not "the code is wrong," it's "this misfires with the person receiving it, or over/under-claims and burns trust." Reviews the thing as the recipient will experience it.

**When to pick this panel:** the work is a deliverable a specific external person will see, react to, and judge; the stakes are relationship/trust/first-impression, not just correctness. Especially for a first-client deliverable, a demo, or anything delivered async (video, doc) where you don't get to narrate live.

**Reviewers (5) — spawn all; the DA is blind:**

1. **Client-Fit Reviewer — "does this deliver what THEY asked for?"** Advocates for the recipient. Maps the deliverable against the client's own spec / stated needs / acceptance tests. Finds: explicit asks that are missing, thin, or misrepresented; over/under-selling vs. what they'd expect; whether the demo visibly satisfies their success criteria. Reads their brief/spec + the deliverable + the surfaces. Opus (judgment-heavy).

2. **Narrative-Consistency Reviewer — "does the story hold across every surface?"** Cross-checks claims, names, numbers, voice, and terminology across all surfaces the recipient encounters (UI copy, narration/video, handoff doc, walkthrough script). Finds contradictions (one surface says X, another denies it), voice/brand drift, number/entity mismatches, a concept renamed across surfaces. Sonnet.

3. **Trust/Honesty-Calibration Reviewer — "are the claims defensible; is the gap list honest?"** Hunts every superlative/certainty and checks it's literally true and would survive a skeptical technical friend of the recipient. Verifies the "what's not there yet" disclosure is complete against their own acceptance tests. Both over-claiming (burns trust when caught) and under-claiming (undersells real work) are failures. Spot-checks reality (run the tests, read the code behind a claim). Sonnet.

4. **Demo-Credibility Realist — "would it survive them actually clicking around / reading closely?"** The skeptic inspecting the real thing. Finds numbers that don't reconcile across one screen, placeholder/scaffolding text still visible, a thin/half-built persona or path, stale data, anything that reads "demo scaffolding." Reads the actual data + surfaces, not just the docs. Sonnet.

5. **Devil's Advocate (blind) — "strongest reason this misfires."** No prior findings; fresh eyes. Names the single strongest case the recipient reacts with less enthusiasm than hoped; challenges whether the team optimized for what's impressive-to-them vs. what moves the recipient's actual goal; 6-month regrets; what's missing entirely that this class of deliverable needs. Opus.

**Failure-surface → reviewer map (fill before spawning):**

| Failure surface | Reviewer |
|---|---|
| Doesn't deliver the recipient's stated asks | Client-Fit |
| Story contradicts itself across surfaces | Narrative-Consistency |
| Over/under-claims; dishonest gap list | Trust/Honesty |
| Cracks under real inspection (data, personas, stale bits) | Demo-Credibility |
| Misfires with the actual human receiving it | Devil's Advocate (blind) |

**Output-safety note:** if the deliverable touches auth/security/compliance, keep reviewer findings as neutral one-line engineering statements (filter-cascade discipline).

**Origin:** MOAB first-client demo-shell review, 2026-07-02 — this 5-lens panel caught, before delivery: a falsely-"connected" integration label, a CEO screen byte-identical to the CFO's, the client's flagship number missing, her #1 acceptance test demoed as the *failure* path, an AR figure contradicting itself on one screen, an over-labeled compliance alert, toy-scale numbers for a national brand, and a "learns from you" claim that didn't close the loop in code. Verdict converged on ADJUST-BEFORE-SHOWING; every finding was a fixable pre-delivery gap.
