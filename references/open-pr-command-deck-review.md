# Open PR command-deck PRISM pattern

Use when an operator asks to open a PR and run an extended PRISM while the current agent must stay in command-deck posture.

## Pattern

1. Verify before push/PR:
   - `git status --short --branch`
   - `git diff --name-status origin/main...HEAD`
   - `git diff --check origin/main...HEAD`
   - confirm expected docs/code scope and no dirty worktree.
2. Open the PR with an explicit authority boundary in the body:
   - what changed;
   - what is not authorized;
   - verification run;
   - what was not tested.
3. Run Extended PRISM as independent lanes, not inline implementation:
   - Security Auditor;
   - Devil's Advocate;
   - Integration Engineer;
   - Performance Analyst;
   - Simplicity Advocate;
   - Blast Radius Reviewer;
   - Verification Auditor;
   - Code/Docs Reviewer.
4. Synthesize to a durable artifact and post a concise PR comment:
   - reviewer verdict table;
   - must-fix before merge;
   - should-fix / implementation-handoff conditions;
   - held authority boundary.
5. If verdict is changes requested, dispatch patch and re-review lanes rather than fixing inline when the current agent is acting as command deck.

## Evidence discipline

- Verification Auditor should prove PR state, changed files, diff hygiene, no implementation drift, no secret/token-shaped leaks, and no unauthorized gate/status closure.
- Blast Radius must search stale authority surfaces, not just changed files: README, vision docs, CLI help, artifact maps, master batons, and any docs that cold-start future agents.
- Devil's Advocate should stay fresh-eyed and avoid prior PRISM archives.
- When synthesizing reviewer findings, re-check every finding against the actual PR comparison base (`origin/<base>..HEAD` or `gh pr diff --name-only`), not stale local `main...HEAD`. Local `main` can lag behind `origin/main`, causing reviewers to flag unrelated already-merged or base-branch changes as PR blockers. Discard or correct any finding that only appears against stale local base truth before posting the synthesis.

## Authority boundary wording

For docs-contract PRs, include explicit negative claims:

- no service implementation;
- no endpoint smoke claim if no service exists;
- no write surfaces;
- no provider/live/runtime-registry/canary/prod movement;
- no gate closure.

If PRISM finds contradictions, the safe next slice is patch + focused re-review, not merge.