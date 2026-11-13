---
name: no-comments
description: 'Spawn Comment Sicko, fix accepted findings, and offer encodings for claimed constraints.'
disable-model-invocation: true
---

# No comments

Ported from Lauren Tan's [pstack](https://github.com/cursor/plugins/tree/main/pstack/skills/no-comments) (MIT, see `LICENSE`).

Spawn Comment Sicko. Act on accepted findings.

Defer to Comment Sicko's fresh perspective.

## Scope

Use the caller's files or diff. Otherwise use the current diff against the repo's default branch, including the working tree.

## Steps

1. Spawn one general-purpose subagent. Its brief is the full text of [`comment-sicko.md`](comment-sicko.md) plus the scope. Do not restate its rules.
2. Inspect its report and diff. Reject application-code edits, scope escapes, exception-protected deletions, misstated `MUST KILL` reasons, and flags that treat kept intentional code as guilty. Reshape flags on our-code surprises stay actionable. Do not restore those comments. A keep survives only with proof it is about something we cannot change. Audit missed scoped lint and TypeScript suppressions. Correctness or safety suppressions stay actionable `MUST KILL`s. Restore deletions only with exact exceptions and scoped proof. For each `NEEDS PROOF` item, and before accepting any other thin `IMPORTANT` or `do not remove` kill or keep, read and follow `~/.agents/skills/how/SKILL.md` (is the claim true on a live path today?) or `~/.agents/skills/why/SKILL.md` (what forced this shape?) on its symbol. If a kill is ambiguous, do not restore. If a keep is refuted or still ambiguous, delete it. Revert and rerun one rejected report with the failure named. Reject a second, report it open, and fail `/no-comments`.
3. Fix trivial accepted flags directly by deleting a dead path, dropping a parameter, or using the real API. If any fix needs a new shape, sketch the types, signatures, and module boundaries once for the accepted set and surrounding code. Stop at the sketch. Step 4 implements.
4. Implement the smallest root-cause fix in scope. Remove every named workaround. If the root cause is out of scope, land the smallest in-scope fix and report the rest open. Fix the fault at the first place the code went wrong, not where it surfaced, and shape the code as if the constraint had been a day-one assumption. Neither rule authorizes widening the fence nor fixing instances outside it. Never bolt on symptom guards.
5. Constraint comments say `do not remove`, `do not change wording`, or `talk to X before changing`. Leave keeps about things we cannot change. Offer the cheapest in-scope type, runtime, test, or CI lint. Wait for interactive approval. Unattended and eval require caller pre-approval. If approved, encode then delete. Otherwise delete, report the constraint open, and sketch out-of-scope work.
6. Report the deletion count, `NEEDS PROOF` outcomes, restored comments, reruns, shape sketch, fixes, encoding offers, encodings, unenforced constraints, and other open work.
