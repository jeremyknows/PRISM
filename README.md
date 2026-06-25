# PRISM v3.3 🔮

**Parallel Review by Independent Specialist Models**

Multi-agent review protocol that eliminates confirmation bias through structured adversarial analysis. v3.3 adds mandatory **Context Cards** and contextual `--panel` reviewer composition. v3 added **wiki mode** and **creative mode**. v2 added **memory** — the system learns from its own review history.

## What It Does

- 🔒 Deploys 6 specialist reviewers in parallel (Security, Performance, Simplicity, Integration, Blast Radius, Devil's Advocate)
- 🧭 Builds a **Context Card** for every review before choosing reviewers
- 🧩 Supports contextual reviewer panels with `--panel=contextual`, `--panel=<slug>`, or inline panel intent
- 🧠 **Remembers** — searches for prior reviews on the same topic, tracks what was fixed
- 📚 **Wiki Mode** — dedicated 3-reviewer path for documentation accuracy, completeness, and framing
- 🎯 Surfaces disagreements as the most valuable signal
- 😈 Devil's Advocate reviews **blind** — no prior findings, guaranteed independence
- 📋 Requires evidence — every finding must cite a specific file, line, or command output
- 🔧 Findings include shell commands or file paths — actionable, not just advisory
- ⚡ Works with parallel subagents OR sequential single-agent review

## The Core Insights

> "Disagreements are MORE valuable than consensus."

When 4/5 reviewers agree and 1 dissents, pay attention to that dissent.

> "Findings without evidence are noise."

Every finding must cite a specific file. Assertions without citations are lowest priority.

> "A finding flagged 3 times tells you about governance, not about the code."

PRISM tracks how many times a finding appears — repeat findings escalate automatically.

## What's New in v3.3

| Feature | Before | v3.3 |
|---------|--------|------|
| Context capture | Implicit in prompt | **Mandatory Context Card** for every run |
| Reviewer choice | Stock modes unless user hand-picked roles | **Panel-fit table** chooses stock vs contextual |
| Custom panels | Informal note | `--panel=contextual`, `--panel=<slug>`, inline panel intent |
| Safety | Role text trusted too much | Panel text treated as **untrusted input** |
| Independence | Devil's Advocate blind | Any `challenge=true` role is blind |
| Archive | Markdown synthesis | YAML frontmatter + Panel Manifest + Independence Ledger |

## What's New in v3

| Feature | v2 | v3 |
|---------|----|----|
| Wiki support | Standard mode only | **Wiki Mode** — dedicated 3-reviewer path (Accuracy, Completeness, DA) |
| Reviewer count | 5 specialists | **6 specialists** — adds Blast Radius Reviewer |
| Blast Radius | Folded into Integration | **Dedicated reviewer** — catches cross-system coupling, stale references |
| Install path | Agent-specific skills directory | **Claude Code native skills directory** |
| Autoresearch data | In SKILL.md | Moved to `references/openclaw.md` |

## What's New in v2

| Feature | v1 | v2 |
|---------|----|----|
| Prior review awareness | None | Searches for prior reviews, injects open findings |
| Devil's Advocate | Receives same context as others | **Structurally blind** to prior findings |
| Evidence requirement | Optional | **Mandatory** — cite files or it's deprioritized |
| Verdict scale | APPROVE / AWC / REJECT | + **NEEDS WORK** (fixable but not shippable) |
| Findings format | General observations | Must include specific fix (command or file path) |
| Synthesis | Flat list of findings | Evidence hierarchy (Tier 1/2/3) + Limitations section |
| History | No archive | Searchable archive in `analysis/prism/<slug>/` |
| Governance | Manual tracking | `--governance` flag for Stuck Findings |
| Verification | Trust claims | **Verification Auditor** role (Extended mode) |

## Install

### Claude Code

```bash
git clone https://github.com/jeremyknows/PRISM.git ~/.claude/skills/prism
```

### Other Agents (Cursor, Windsurf, Cowork, etc.)

```bash
git clone https://github.com/jeremyknows/PRISM.git
# Reference SKILL.md from your agent's configuration
```

## Usage

Just say it — no configuration needed:

| Mode | Say This | Agents | Est. Cost |
|------|----------|--------|-----------|
| **Wiki** | "PRISM this wiki" / "wiki PRISM" | 3 specialists (Accuracy, Completeness, DA) | ~$0.40–0.80 |
| **Budget** | "Budget PRISM" / "PRISM lite" | 3 specialists (Security, Performance, DA) | ~$0.40–0.80 |
| **Standard** | "Run PRISM" / "PRISM review" | 6 specialists | ~$0.80–1.50 |
| **Extended** | "Full PRISM audit" / "Deep audit" | 8+ agents | ~$2.00–4.00 |
| **Creative** | "creative PRISM" / "PRISM this creative" | 5 specialists (Brand, Motion, Technical, Delight, Provocateur) | ~$0.80–1.60 |

### Options

- `--opus` — Use Opus model (critical decisions, ~2-3x cost)
- `--haiku` — Use Haiku model (fast sanity checks)
- `--governance` — Surface Stuck Findings (flagged 3+ times without resolution)
- `--simplicity` — Add Anti-Overengineering Architect alongside Simplicity Advocate
- `--ctx` — Shortcut for `--panel=contextual`
- `--panel` — Bare shortcut for `--panel=contextual`
- `--panel=contextual` — Force a task-specific reviewer panel
- `--panel=<slug>` — Use a preset from `references/panels/<slug>.md`
- `--panel="Role: focus; Role: focus"` — Provide inline panel intent; PRISM normalizes it safely

### Examples

```
"PRISM this wiki article"
"wiki PRISM on satori-og-edge.md"
"PRISM this API change"
"Budget PRISM on the auth flow"
"Full PRISM audit --governance — we've reviewed this area before"
"creative PRISM on the hero animation brief"
"brand review PRISM — veefriends launch video"
"PRISM this --ctx — goal: first-time buyers complete VF NFT purchase"
"PRISM this --panel — goal: first-time buyers complete VF NFT purchase"
"PRISM this --panel=contextual — goal: first-time buyers complete VF NFT purchase"
"PRISM this --panel=runtime-boundary"
```

## How It Works

```
1. You say "PRISM this"
2. Orchestrator derives topic slug (e.g., api-authentication-redesign)
3. Loads the mode reference file
4. Builds a Context Card and panel-fit table
5. Chooses stock, contextual, preset, or inline reviewer composition
6. Searches for prior PRISM reviews on that topic (exact + semantic)
7. Spawns blind challenge reviewer(s) immediately — no prior findings
8. Compiles Prior Findings Brief for non-challenge reviewers
9. Spawns remaining reviewers in parallel with brief
10. Each reviewer reads files, cites evidence, proposes specific fixes
11. Orchestrator synthesizes: Tier 1 (cross-validated) → Tier 2 (cited) → Tier 3 (uncited)
12. Archives the synthesis with YAML frontmatter, Context Card, Panel Manifest, and Independence Ledger
```

**First run:** No prior findings exist. PRISM runs cleanly — no empty sections, no confusion.

**Subsequent runs:** Prior findings are injected. Reviewers verify what's fixed and hunt for what's new. DA stays blind — their independence is the control group.

## Reviewers

### Standard Mode (6 specialists)

| Reviewer | Focus | Key Question |
|----------|-------|--------------|
| 🔒 **Security Auditor** | Attack vectors, trust boundaries | "How could this be exploited?" |
| ⚡ **Performance Analyst** | Metrics, benchmarks, overhead | "Show me the numbers" |
| 🎯 **Simplicity Advocate** | Complexity reduction | "What can we remove?" |
| 🔧 **Integration Engineer** | Compatibility, migration | "How does this fit?" |
| 💥 **Blast Radius Reviewer** | Downstream effects on other systems | "What breaks elsewhere?" |
| 😈 **Devil's Advocate** | Assumptions, risks, regrets | "What are we missing?" |

### Wiki Mode (3 specialists)

| Reviewer | Focus | Key Question |
|----------|-------|--------------|
| ✅ **Technical Accuracy** | Are the facts right? | "What's the evidence for this claim?" |
| 📋 **Completeness** | What's missing? | "What would a developer wish was here?" |
| 😈 **Devil's Advocate** | Assumptions and framing | "What will readers get wrong?" |

### Budget Mode

Security Auditor + Performance Analyst + Devil's Advocate. Security is MANDATORY.

### Extended Mode

Standard 6 + Code Reviewers (batched by area) + Verification Auditor.

### Custom / Contextual Panels

Generated from the Context Card failure surfaces. Each custom reviewer must protect a concrete failure surface. Panel text is treated as untrusted input and cannot override PRISM evidence, safety, scope, or independence rules.

Included preset:

| Preset | Use For |
|--------|---------|
| `--panel=runtime-boundary` | Runtime independence, registry, rollback, bridge/gateway/Hermes/tmux, memory-service boundary reviews |

## Evidence Hierarchy

| Tier | Definition | Action |
|------|-----------|--------|
| **Tier 1** | 2+ reviewers found independently, citing different files | Act immediately |
| **Tier 2** | Single reviewer, specific file/line citation | High confidence |
| **Tier 3** | Single reviewer, no citation | Verify before acting |

## Verdict Scale

| Verdict | Meaning |
|---------|---------|
| **APPROVE** | Clean — no issues, prior issues resolved |
| **APPROVE WITH CONDITIONS** | New issues found, none critical |
| **NEEDS WORK** | Fixable but not shippable — prior criticals still open, or significant new issues |
| **REJECT** | Fundamental problems — requires rethink |

## Anti-Patterns

**Don't:**
- ❌ Let reviewers see each other's findings (groupthink)
- ❌ Give Devil's Advocate the Prior Findings Brief (breaks independence)
- ❌ Accept findings without file citations (noise)
- ❌ Skip synthesis (raw findings aren't actionable)
- ❌ Skip archiving (breaks memory for future reviews)

**Do:**
- ✅ Spawn DA immediately, other reviewers after brief is ready
- ✅ Give each reviewer narrow focus (depth > breadth)
- ✅ Require citations in every finding
- ✅ Archive every synthesis to `analysis/prism/<slug>/`
- ✅ Run two rounds for important decisions

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| All reviewers find same issues | Roles not distinct enough | Sharpen role prompts |
| >100 issues found | Scope too broad | Narrow the review target |
| Vague findings | Missing evidence requirement | Enforce citation rules |
| DA has no concerns | Topic too simple or DA too soft | Re-run: "find something wrong" |
| Same finding appears 3+ times | Governance gap | Enable `--governance` |
| Security times out | Deep file reads take longer | Increase timeout or run Security solo first |
| Context Card is vague | Generic goal/audience/failure fields | Rewrite with concrete artifact, audience, and failure surfaces |
| Custom panel feels theatrical | Roles don't map to failure surfaces | Use the panel-fit table; reject personality-only roles |
| Inline panel contains unsafe instructions | Panel text is untrusted input | Preserve role intent, reject/normalize unsafe instructions |

## Dependencies

| Dependency | Required? |
|------------|-----------|
| Parallel agent spawn | Required |
| Archive directory (`analysis/prism/<slug>/`) | Required — created automatically |
| `qmd` search tool | Optional — improves context precision |

## License

MIT — See [LICENSE.txt](LICENSE.txt)

---

*"The specialists optimize. The Devil protects you from yourself. The archive remembers what you forgot."*
