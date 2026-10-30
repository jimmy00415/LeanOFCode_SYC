# JSP-000632 contribution review

This draft links a successfully reproduced complete Lean proof of the Erdős #771 interval asymptotic and adds a separately compiled statement-equivalence audit. It requests review of the catalog correspondence and applicant attribution.

## Submission type

- [ ] Mathematical solver information
- [x] Lean proof or formalization author information

## Problem and formal statement

Problem: [JSP-000632](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0601-0700.md#JSP-000632), with precise source [Erdős #771](https://www.erdosproblems.com/771).

For each `n`, let `f(n)` be the greatest `k ≤ n` such that, for every positive natural target `m`, some `k`-element subset of `{1,...,n}` has no subset summing to `m`. The checked theorem proves `f(n)/(n/log n) → 1/2`, with the natural logarithm. The subset may depend on `m`.

The complete mathematical solution is Noga Alon and Gregory Freiman, [*On sums of subsets of a set of integers*](https://web.math.princeton.edu/~nalon/PDFS/Publications/On%20sums%20of%20subsets%20of%20a%20set%20of%20integers.pdf), Combinatorica 8 (1988), 297–306: Theorem 1.2 and the p.298 asymptotic consequence, together with the earlier Erdős–Graham lower bound.

**Statement review requested:** the catalog's “arbitrary finite integer set” wording differs from this precise interval formulation. The audit does not establish their equivalence. The diff only updates Lean-proof and attribution information; eligibility and mathematical status remain unchanged.

## Pinned proof and evidence

Original public source reproduced in this submission:

```json
[{"repository":"https://github.com/plby/lean-proofs","branch":"main","commit":"8822f7ddef30fadbd92e1c6ab4ed897af356af5e"}]
```

Target: [`src/latest/ErdosProblems/Erdos771.lean`, `Erdos771.erdos_771`](https://github.com/plby/lean-proofs/blob/8822f7ddef30fadbd92e1c6ab4ed897af356af5e/src/latest/ErdosProblems/Erdos771.lean#L4547). The preceding full result is `Erdos771.erdosF_asymptotic`. Main-file blob: `dfce72438c4182f8a234ef899a5b173538ab2358`. The selected commit belongs to the observed `main` branch.

Applicant-selected publication repository, including the pinned complete proof as a submodule and the additional audit modules:

```json
[{"repository":"https://github.com/jimmy00415/LeanOFCode_SYC","branch":"main","commit":"EVIDENCE_COMMIT"}]
```

[Report](https://github.com/jimmy00415/LeanOFCode_SYC/blob/EVIDENCE_COMMIT/REPORT.md) · [setup and commands](https://github.com/jimmy00415/LeanOFCode_SYC/blob/EVIDENCE_COMMIT/README.md) · [reproduction record](https://github.com/jimmy00415/LeanOFCode_SYC/blob/EVIDENCE_COMMIT/research/lean-reproduction.md) · [explicit-statement bridge](https://github.com/jimmy00415/LeanOFCode_SYC/blob/EVIDENCE_COMMIT/lean/FaithfulnessAudit.lean).

## Verification

Lean 4.33.0 (runtime commit `d8b18978322de05a8f3dba51ef03cf5461676c17`); Mathlib `db584cd6d46c92f209a44c0f1c829460d327499d`; all other dependencies pinned by the original manifest. The project's nine supplied compatibility patches were applied to dependencies, without changing the main proof or project configuration.

The fresh custom-target build against the pinned Mathlib cache completed on 30 October 2026 at 04:16:11 UTC, exit 0, 9018 jobs:

```text
lake build +ErdosProblems.Erdos771:olean
lake env lean AxiomAudit.lean
lake env lean StatementAudit.lean
lake env lean FaithfulnessAudit.lean
```

All four checks exited 0. The axiom audit executes `#print axioms` for both final declarations and reports:

```text
'Erdos771.erdosF_asymptotic' depends on axioms: [propext, Classical.choice, Quot.sound]
'Erdos771.erdos_771' depends on axioms: [propext, Classical.choice, Quot.sound]
```

The statement bridge separately proves `originalPredicate_eq`, `originalF_eq`, and `original_statement_from_prior_proof`; all have the same standard axiom list. No `sorryAx` or additional mathematical axiom appears in these final results. Mathlib was cached, rather than rebuilt from source; no Nanoda or Comparator replay is claimed.

Actual logs: [target build](https://github.com/jimmy00415/LeanOFCode_SYC/blob/EVIDENCE_COMMIT/logs/reproduction-erdos771-build.log), [axiom audit](https://github.com/jimmy00415/LeanOFCode_SYC/blob/EVIDENCE_COMMIT/logs/reproduction-axiom-audit.log), [statement audit](https://github.com/jimmy00415/LeanOFCode_SYC/blob/EVIDENCE_COMMIT/logs/reproduction-statement-audit-fixed.log), [faithfulness bridge](https://github.com/jimmy00415/LeanOFCode_SYC/blob/EVIDENCE_COMMIT/logs/reproduction-faithfulness-audit.log). An earlier failed experiment is labeled separately and is not counted as verification.

## Attribution and related submissions

The original proof's [header](https://github.com/plby/lean-proofs/blob/8822f7ddef30fadbd92e1c6ab4ed897af356af5e/src/latest/ErdosProblems/Erdos771.lean#L6-L12) credits **Codex; GPT-5.6 Sol**. These credits and source history are preserved. Jimmy (`jimmy00415`), with Codex assistance, supplies the reproduction, explicit-statement bridge, and audit bundle.

The applicant identifies the local proof as their original contribution. Public evidence linking that claim to the earlier source attribution remains for review. The new repository establishes publication of this audit; it does not itself establish first priority or authorship of the earlier full proof. The bridge derives its limit from the pinned theorem, and `StatementAudit.ExactTarget` is a proposition definition, not an independent proof.

Related submissions: #1050, #1146, #1669, #1854, #2854, #4049, #4573, #5357, all unmerged at the audit snapshot. Several cite the same complete proof. The additional material here is the actual reproduced build, final axiom audit and explicit-statement bridge. Original-contribution requirements, including the attribution concern raised in #1146, remain applicable.

## Checklist

- [x] Only permitted Lean-proof and attribution catalog fields are changed.
- [x] Complete mathematical source, pinned proof, reproducible commands and actual final axiom outputs are linked.
- [x] Original mathematical and formalization credits are preserved; no Lean sources or build artifacts are added to the awards repository.
- [ ] Exact catalog-statement correspondence has maintainer approval — review requested.
- [ ] Applicant's own contribution to the earlier complete formalization has corroborating public attribution evidence — review requested.

This PR is a draft pending those reviews. The later Lean award claim requires a merged contribution PR and the remaining official attribution, identity and award-review steps.
