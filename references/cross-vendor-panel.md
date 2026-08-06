# Cross-Vendor Panel — Optional Overlay

**Origin:** community-contributed fix for [PRISM issue #2](https://github.com/jeremyknows/PRISM/issues/2) (dustin/cogpros, 2026-07-03). Verified with a working test rig on a planted-bug fixture, a real production auth module, and PRISM's own reviewer script.

## The problem this solves

PRISM's synthesis is already the right shape for bug-hunting — fan-out to N reviewers, then **preserve every distinct finding verbatim** rather than blending into one judged answer (see SKILL.md §Known Limitations #2 on the telephone-game risk of paraphrased synthesis). That shape is correct. The gap is that every reviewer, in every mode, is a Claude subagent. If Claude has a blind spot, all N reviewers share it — cross-validation (Tier 1 in the Evidence Hierarchy) can't catch a blind spot every reviewer inherits from the same model family.

There are two ways to add more models to a panel, and only one fits PRISM:

- **Aggregator (Mixture-of-Agents / OpenRouter Fusion)**: N proposers → 1 judge → one blended answer. This is wrong for PRISM — the judge's "high confidence" is exactly where models agreed, which is where the minority-but-correct finding gets voted away.
- **Fan-out + union (what PRISM already does)**: N proposers, keep every distinct finding, dedup only on exact overlap, never blend through a judge.

Cross-Vendor Mode extends the *existing* fan-out+union shape across model vendors instead of extending it across model tiers (sonnet/haiku) as PRISM already does today.

## Evidence from the issue's test rig

- **Planted-bug fixture** (9 diverse known bugs, scored against ground truth): cross-vendor union caught 9/9; best single vendor (Claude sonnet) alone caught 7/9. The null-deref bug was caught **only by Gemini** — every other vendor missed it, including Claude. A consensus judge would have scored that 1-of-6 finding as low-confidence and dropped it exactly because it was true. Cost: ~$0.07 for a 6-vendor pass.
- **Real production auth module (~1000 LOC, unknown bugs):** the union surfaced a symptom cluster (session-clobber from two auth flows sharing one JWT cookie) that no single vendor pass named on its own. Honest caveat: raw union was 62 findings, ~5 verified real defects, 2 false positives, 1 hallucinated line number after human verification — verification is still required, same as any PRISM Tier 2/3 finding.
- **Self-review** (panel reviewing its own runner script): caught a live bug biting the tool in that same run — a JSON extractor silently dropping any vendor reply containing an unescaped regex like `\d` or `\s`, discarding whole responses. Two vendors plus some of Claude's own findings were being thrown away before the fix.

## When to use this overlay

Cross-Vendor Mode is an **overlay**, not a replacement mode — apply it on top of Standard, Extended, or a Contextual panel. Reach for it when:

- The decision is genuinely high-stakes (PRISM is already gated to that tier — see SKILL.md §When to Use PRISM) and a single-vendor blind spot would be expensive to miss.
- A prior single-vendor PRISM round produced a "clean" verdict you're not fully confident in — cross-vendor is a cheap independent check before shipping.
- Pre-open-source release reviews, security-critical changes, or supply-chain incident reviews (see `references/supply-chain-incident-review.md`) — anywhere the cost of a missed minority-but-correct finding is asymmetric.

Not needed for routine Budget-mode sanity checks — the cost/value ratio doesn't clear there.

## How to run it

1. **Keep the existing Claude reviewer roster as-is** for the chosen mode (Standard/Extended/Contextual). Don't drop Security Auditor or Devil's Advocate.
2. **Add 1–5 cross-vendor reviewers** as an additional batch, one per vendor, using direct-output (non-reasoning) model variants:

   | Vendor | OpenRouter model id | Notes |
   |--------|---------------------|-------|
   | xAI | `x-ai/grok-4` | |
   | Google | `google/gemini-2.5-pro` (or `-flash` for cheap/fast) | Caught the null-deref in the source test — don't skip Gemini |
   | DeepSeek | `deepseek/deepseek-chat` | Use `-chat`, not `-reasoner` |
   | Zhipu | `z-ai/glm-4.6` | |
   | Moonshot | `moonshotai/kimi-k2` | Use the direct-output variant, not `kimi-k2-thinking` |

   **Gotcha (confirmed in the source issue):** reasoning-heavy variants (`-thinking`, extended-reasoning `-pro` configs) can burn their entire token budget on hidden reasoning and return empty content. `scripts/cross-vendor-review.sh` treats empty content as a hard error rather than silently passing an empty finding through — if a vendor call errors this way, switch to its direct-output sibling, don't retry the same model.

3. **Invoke each cross-vendor reviewer** with the same reviewer prompt (Evidence Rules + Prior Findings Brief) used for the Claude reviewers, via:
   ```bash
   bash references/../scripts/cross-vendor-review.sh "<model-id>" <prompt-file> <output-file>
   ```
   Run vendors in parallel (background the curl calls / spawn as parallel Bash calls), same as Claude reviewers are spawned in parallel.
4. **Synthesize with the existing Synthesis Template — unchanged.** Add each cross-vendor reviewer to the Independence Ledger with `Model` = the OpenRouter model id (e.g. `google/gemini-2.5-pro`), same as a Claude reviewer's model tier is recorded today. Do **not** route cross-vendor outputs through a separate judge or blending pass — they go into the same New Findings / Consensus / Minority Signals sections as any other reviewer, ranked by the same Evidence Hierarchy tiers.
5. **Verify before acting**, same discipline as any PRISM finding — the source issue's own numbers (62 raw findings → ~5 verified real defects on the real-world test) show cross-vendor union raises recall, not precision. Tier 2/3 findings from a cross-vendor reviewer still need the same verification pass a Claude Tier 2/3 finding gets.

## Cost

Roughly Nx a single-vendor review pass for N cross-vendor reviewers added. On the source issue's fixture-scale test, 6 vendors cost ~$0.07 total — cheap enough that cost is not the gating factor for high-stakes reviews. Scales with artifact size like any PRISM pass; budget accordingly for Extended-mode-scale artifacts.

## Dependency

`OPENROUTER_API_KEY` — `scripts/cross-vendor-review.sh` reads it from the environment. The retired `openrouter-api-key-main` / `openrouter-api-main` 1Password aliases are not fallback sources. This is not a hard PRISM dependency: panels without the key skip the overlay and run single-vendor.
