# Draft — JSP-000632 complete Lean contribution

Status: prepared locally; not filed. Resolve the original-source and attribution fields before submission.

## Problem and mathematical solution

- Problem: [JSP-000632](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0601-0700.md#JSP-000632), intended precise formulation [Erdős #771](https://www.erdosproblems.com/latex/771).
- Mathematical authors: Noga Alon and Gregory Freiman, with the earlier Erdős–Graham lower-bound contribution credited in the explanatory report.
- Paper: *On sums of subsets of a set of integers*, Combinatorica 8 (1988), 297–306; Theorem 1.2 and its p.298 asymptotic consequence.
- Target: the maximal common cardinality of a subset of `{1,...,n}` avoiding each prescribed positive target has normalized limit `1/2` after division by `n/log n`.
- Scope note: the catalogue's arbitrary-host wording differs from the precise interval formulation and requires statement review.

## Original Lean contribution and attribution

- Applicant: `jimmy00415`.
- Applicant-declared role: original Lean formalization contributor.
- Original applicant repository, branch and full SHA: **awaiting applicant source reference**.
- Account-to-contribution evidence: **awaiting applicant source reference**.
- Existing verified public source: `plby/lean-proofs@8822f7ddef30fadbd92e1c6ab4ed897af356af5e`, `src/latest/ErdosProblems/Erdos771.lean`.
- The existing source credits Codex and GPT-5.6 Sol as formal contributors. The applicant-to-source relationship must be documented; this draft does not replace those credits.

## Verification

Lean 4.33.0, Mathlib `db584cd6d46c92f209a44c0f1c829460d327499d`. The full selected public proof compiled with exit 0. Both `Erdos771.erdosF_asymptotic` and `Erdos771.erdos_771` report `[propext, Classical.choice, Quot.sound]`. A separate explicit-predicate and maximum-equivalence audit also passed.

Exact commands, logs and source integrity records are in the accompanying audit bundle. A public permalink to that bundle must be added after the authorized destination has been selected and pushed.

## Related public submissions

Earlier public references include official PRs #1050, #1669, #4049 and #5357. Their existence and the selected source's public history are disclosed for maintainer review. No statement that this is the first PR or first public proof is made without supporting evidence.

Only permitted catalogue fields should be changed. Maintainers retain control of eligibility flags, candidate records, claim statuses and award decisions.
