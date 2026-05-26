# Pipeline Readiness PRISM

Use this reference when PRISMing an operational/data pipeline before a larger smoke, canary, or scale-up. This is a class-level pattern for pipelines where the immediate question is not just code correctness, but whether the next run is safe, reproducible, fair, and operator-clear.

## Trigger

Load alongside Standard/Extended PRISM when the subject includes:
- “pipeline review”, “larger smoke readiness”, “before scale”, “before larger live run”;
- data collection + scoring/ranking + operator handoff;
- privacy/report-safe artifacts;
- cost/rate-limit exposure;
- no-go boundaries such as no writes, no execution, no credential reads, or no private enrichment.

## Reviewer lens set

If full Standard PRISM would be too generic, preserve the user’s requested dimensions and map them to these independent lenses:

1. **Security / privacy / blast radius**
   - raw identifiers, public/private boundary, report-safe vs operator-private artifacts;
   - credential and secret handling by boolean/source-readiness only;
   - language that could be mistaken for authorization, winner selection, exclusion, or public action;
   - downstream artifacts that persist sensitive joins.

2. **Fairness / scoring / data quality**
   - sample representativeness and pagination/coverage bias;
   - eligibility unit (per-author, per-reply, per-wallet) and duplicate/collision policy;
   - calibrated vs uncalibrated thresholds;
   - confidence, hard holds, false positives/false negatives;
   - whether “missing data” is incorrectly labeled as “bad candidate.”

3. **Reliability / operator UX / cost**
   - runbook ↔ scripts ↔ actual artifact drift;
   - one-command/manifest reproducibility;
   - artifact checksums and evidence custody;
   - budget/rate-limit controls based on actual provider behavior, not just output cap;
   - dry-run/preflight checks for missing scripts, incompatible args, and forbidden fields.

## Synthesis shape

In addition to the normal PRISM synthesis template, include:

- **Larger smoke readiness recommendation:** explicit `PASS`, `HOLD`, or `PASS_FOR_NARROW_REHEARSAL_ONLY`.
- **Must-fix before larger smoke:** bounded, verifiable backlog.
- **Nice-to-have backlog:** useful later improvements that should not block the next safe gate.
- **Conditions by next-action type:** distinguish a larger *collection/candidate-extraction rehearsal* from a larger *scored/ranked smoke*. The latter needs stronger calibration and fairness gates.
- **No-go preservation:** restate live/write/private/credential/spend boundaries in the report header and completion relay.

## Common blockers

Treat these as likely blockers until disproven with evidence:

1. **Report-safe breach** — broad artifacts join raw handles/names/text/platform URLs with wallets, scores, labels, or recommendation language.
2. **Recommendation-language drift** — “top recommendations”, “backup candidates”, “winner”, “exclude”, or rank labels appear where the contract says human-review-only.
3. **Eligibility-unit drift** — implementation behaves per-reply while policy says per-author or per-wallet, or duplicate/collision holds are absent.
4. **Uncalibrated scoring** — scores/ranks are generated before labeled seed sets, false-positive/false-negative checks, or confidence thresholds exist.
5. **Runbook/script/artifact mismatch** — documented commands reference missing scripts, wrong args, or a different artifact tree than the actual run.
6. **Output cap mistaken for cost cap** — provider bills/reads by page or call even when local output is capped.
7. **Missing raw/summary split** — raw provider payloads and full review joins lack TTL/restricted naming while summary artifacts are meant for broad relay.

## Recommended report-safe artifact pattern

Prefer a split output tree:

```text
run-manifest.yaml                  # mode, cap, pages, budget, no-go booleans, versions
private_review/                    # restricted raw joins, full text, full IDs/wallets, TTL
report_safe/summary.{json,md}      # counts, local refs, masked wallets, reason-code distributions, caveats
checksums.sha256                   # all artifacts
```

Broad summaries should use local candidate refs and aggregates. Full raw joins stay restricted and TTL-bound.

## Dispatch / completion receipt

For Command Deck-style lanes, Dispatch-back should include:
- TASK_ID;
- verdict (`PASS`/`HOLD`);
- artifact path and archive path;
- top blockers (max 5);
- exact next action.

Then emit raw `task_completed` with the same TASK_ID and include `artifact_path`, `archive_path`, `dispatch_back_message_id`, and verdict in the payload. Verify raw JSONL bus proof before claiming closure.
