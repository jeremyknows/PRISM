# Contract Semantics Decision Notes

Use this reference when a PRISM/architecture task touches a load-bearing contract field, enum, routing scope, provider boundary, identity boundary, or persisted schema whose meaning may be ambiguous.

## Pattern

When the obvious next implementation step is to add or rename an enum value, pause and ask whether the field's *semantic axis* is settled.

Examples of competing axes:
- topology: `dm`, `channel`, `thread`, `room`, `external`
- delivery/provider class: `discord`, `synthetic`, `cli`, `imessage`
- identity/authority: human-authored, bot-authored, shadow/synthetic, delegated
- transport vs runtime vs UI surface

If two plausible axes exist, do not let a quick enum addition silently decide the contract. Create a small decision note first.

## Minimum decision-note contents

1. **Current contract meaning** — cite files/docs/tests that imply the existing semantics.
2. **Ambiguity** — name the competing interpretations in plain language.
3. **Near-term rule** — what agents should and should not change yet.
4. **Future implementation gate** — the evidence required before changing code:
   - explicit semantic choice: topology-only, delivery-class-only, or split fields;
   - consumer audit for every reader/writer of the field;
   - failing test proving current semantics are insufficient;
   - minimal implementation plan;
   - conservative gate/canary language if production routing is affected.
5. **Links** — connect the note from the matrix, baton, vision, or other active anchor docs so future sessions find it.

## Good bounded next step

For contract ambiguity, a decision note can be the correct next deliverable even when no code changes. It preserves momentum without prematurely freezing a bad semantic model.

## Pitfalls

- Do not encode a delivery-surface concept into a topology field just because it unblocks one provider test.
- Do not call documentation-only work “nothing happened” when it prevents contract drift.
- Do not advance gate language from “shadow evidence” to “production route ready” unless the semantic choice and consumer audit are complete.
