# Multi-Cycle Roadmap PRISM Pattern

Use this reference when the operator asks for multiple PRISM cycles over a roadmap, gate ladder, canary sequence, or final-leg promotion plan — especially when the work spans security boundaries, runtime activation, provider/service rollout, and writes.

## Trigger signals

- User asks for “triple PRISM”, “series of PRISM cycles”, “validate the remaining phases”, or “shore up the shape before promotion”.
- The roadmap has already completed early phases but still has high-blast-radius later phases.
- The user emphasizes simplicity, sequencing, final-leg validation, avoiding gaps, or not overbuilding.

## Orchestration shape

1. **Create separate threads/artifacts per cycle.**
   - Cycle 1: holistic roadmap / sequence / premise audit.
   - Cycle 2: next trust boundary or highest-risk near-term crossing.
   - Cycle 3: downstream promotion surfaces: fleet, provider, service, writes, Gate.
   - Add more cycles only when a remaining phase has independent blast radius; do not run one PRISM per phase by default.

2. **Use reviewers that build across cycles without collapsing independence.**
   - Per cycle, use 5-ish roles when warranted: Security/Blast Radius, Devil’s Advocate, Simplicity/Anti-OE, Integration, Verification.
   - Devil’s Advocate should stay blind or blind-ish; do not feed it prior synthesis unless explicitly intended.
   - Later-cycle non-DA reviewers should receive concise prior-cycle consensus, not raw transcripts.

3. **Maintain evidence-class discipline.**
   Distinguish:
   - `fixture_only`
   - `local_no_live`
   - `supervised_real_read`
   - `unsupervised_live_canary`
   - `selected_fleet_read`
   - `service_auth_boundary`
   - `private_provider`
   - `write_custody_propose`

   Static/no-live proof is valuable, but it must not be promoted as live/canary/fleet proof.

4. **Force source-floor rebaseline when reviewers find drift.**
   If roadmap/docs/fixtures cite older SHAs or status anchors than the live repo floor, treat this as a blocker for acceptance authority, not documentation polish.

5. **Elevate simplicity as a first-class output.**
   In roadmap PRISMs, the most useful outcome may be “do less next”: one bounded proof, one rollback, one artifact hygiene scan. Capture this as the recommended next lane, not just as a low-priority concern.

## Useful cycle prompts

### Cycle 1 — Holistic / premise

Ask reviewers to validate the full roadmap journey, sequence, status vocabulary, and whether the roadmap can be simplified without losing safety. Require them to identify stale anchors, overclaiming PASS labels, and the smallest next real proof.

### Cycle 2 — Near-term trust boundary

Ask reviewers to focus on the next actual crossing: descriptor/grant/source allowlists, process-owned authority, denial-before-read semantics, counters, rollback, final artifact hygiene, and whether current CLI/MCP/service routes are suitable.

### Cycle 3 — Promotion surfaces

Ask reviewers to focus on downstream blast radius: selected fleet rollout, provider preference, persistent service/SLOs, write custody, autonomous writes, and Gate promotion. Require an explicit dependency order and hold list.

## Synthesis pattern

For each cycle, write a short artifact with:

- source floor checked;
- reviewer table with verdicts;
- Tier 1 findings;
- Tier 2 findings;
- recommended next packet;
- held surfaces.

Then write a cross-cycle synthesis with:

- executive verdict;
- consensus across cycles;
- revised roadmap/gate shape;
- exact next execution lane;
- explicit holds.

## Common conclusions to watch for

- “Do not build more scaffolding; cross the next real boundary once, safely.”
- “Provider/service/write/Gate must not be bundled into the next execution slice.”
- “For any live provider path, service/auth boundary should precede provider preference.”
- “Writes are a separate roadmap unless read-side usefulness and rollback are already boring.”
- “Gate promotion should be incremental and evidence-classed, not broad.”
- “For issue-railed overnight/autopilot work, do not create a 60–80 issue backlog just because the roadmap has that many possible slices. Prefer a small active tranche (often 6–10 issues) plus a planning artifact for later waves; later waves should be created only after the verifier for the current tranche passes.”
- “If an existing cron/autopilot prompt is hard-coded to a current issue range, new issues outside that range are not automatically safe for it to consume. Require an updated/restarted successor prompt with the exact next issue list before claiming the rail is ready.”

## Pitfalls

- **Over-parallelizing without synthesis:** many agents produce noise unless each cycle has a clear thesis and artifact.
- **Feeding DA too much prior consensus:** this destroys the value of blind adversarial review.
- **Reusing a non-starting same-cycle artifact as closure:** if an orchestrator corrects a handoff and says the lane must start from the orchestrator's message, treat any earlier same-cycle synthesis as orientation only. Resolve the kickoff task/correlation IDs, re-run or independently verify the cycle against source, write a new scoped artifact, then close with an acknowledgment-back plus raw completion proof.
- **Treating tests as status authority:** command PASS does not override semantic blockers or stale source-floor anchors.
- **Confusing no-live with canary:** default-off/static observer receipts are not proof of unsupervised real-source behavior.
- **Leaving the user with raw reviewer output:** always synthesize to the exact next lane and explicit hold list.
