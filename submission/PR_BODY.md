# JSP-000632: LCM-cutoff formalization

We submit our locally developed LCM-cutoff upper bound and complete Lean proof assembly for the Erdős #771 interval asymptotic. The work includes the mathematical derivation, implementation, complete-limit theorem and executable verification.

## Submission type

- [ ] Mathematical solver information
- [x] Lean proof or formalization author information

## Problem and formal statement

Problem: [JSP-000632](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0601-0700.md#JSP-000632), precise source [Erdős #771](https://www.erdosproblems.com/771).

Let `f(n)` be the greatest `k ≤ n` such that, for every positive integer `m`, there exists a `k`-element set `S ⊆ {1,...,n}` with no subset summing to `m`. The set may depend on `m`; elements are distinct and the empty subset is included. Our complete theorem proves `f(n)/(n/log n) → 1/2`, with the natural logarithm and no additional mathematical hypotheses.

Target: [`JSP000632Progression.erdosF_asymptotic_via_progression`](https://github.com/jimmy00415/LeanOFCode_SYC/blob/b556e9bc6f16fe86b4dc4de3b2f4b0cc8e1719f0/lean/ProgressionUpperBound.lean). Its statement and proof share that file.

The proposed correspondence is with the precise interval formulation. The catalog's short description refers to an arbitrary finite integer set; maintainer statement review is requested for that wording. This PR updates only the Lean-proof and attribution fields. Mathematical review and acceptance remain pending.

## Process

Set `B = floor(log₂ n)+1`, `R = floor(n²/(10000 B³))`, and `V = floor(n²/(1000 B²))`. Choose the largest `r` with `L(r) = lcm(1,...,r) ≤ V`, and take `m = L(r)`.

1. The uniform representation theorem at parameter `r` produces a modulus `1 ≤ q ≤ r`, so `q` divides `m`.
2. Direct integer inequalities give `R(r+1) ≤ V < (r+1)m`, hence `R < m ≤ V`.
3. Every sufficiently large set of cardinality at least `K = floor(n/r)+16B^16+r` represents `m`; consequently `f(n) < K`.
4. The cutoff satisfies `r ~ 2 log n`. Therefore `K/(n/log n) → 1/2`. Combining this upper estimate with the prime-nondivisor lower bound gives the complete limit.

The code supplies the exact finite hypotheses and proves they eventually hold. Our output comprises the endpoint estimates, target application, extremal bound, normalization and final limit, plus the executable checks. The uniform representation theorem, PNT estimates and lower bound are library inputs; their exact declarations and build pins are recorded with the source and reproduction instructions.

[Process, results and conclusion](https://github.com/jimmy00415/LeanOFCode_SYC/blob/b556e9bc6f16fe86b4dc4de3b2f4b0cc8e1719f0/REPORT.md) · [Detailed derivation](https://github.com/jimmy00415/LeanOFCode_SYC/blob/b556e9bc6f16fe86b4dc4de3b2f4b0cc8e1719f0/research/method-note.md) · [中文方法说明](https://github.com/jimmy00415/LeanOFCode_SYC/blob/b556e9bc6f16fe86b4dc4de3b2f4b0cc8e1719f0/METHOD.zh-CN.md).

## Results and verification

Verified locally on 30 October 2026, 13:06–13:07 HKT, with Lean 4.33.0. Proof compilation, audit-tool compilation and the transitive dependency check each exited 0. The negative control exited 1 with the expected rejection. The overall verification runner exited 0.

```text
'JSP000632Progression.erdosF_asymptotic_via_progression' depends on axioms: [propext, Classical.choice, Quot.sound]
```

All ten printed theorem audits have the same standard axiom set. The submitted result has no `sorryAx` or added unproved mathematical axiom. The transitive audit traversed 72,948 constants and passed its eight explicit exclusions; its expected-failure control verifies rejection behavior. The log lists actual library reuse. This checks the proof's dependency graph separately from the module import closure.

Logs: [proof and axioms](https://github.com/jimmy00415/LeanOFCode_SYC/blob/b556e9bc6f16fe86b4dc4de3b2f4b0cc8e1719f0/logs/reproduction-progression-proof.log), [audit tool](https://github.com/jimmy00415/LeanOFCode_SYC/blob/b556e9bc6f16fe86b4dc4de3b2f4b0cc8e1719f0/logs/reproduction-progression-audit-tool.log), [dependency check](https://github.com/jimmy00415/LeanOFCode_SYC/blob/b556e9bc6f16fe86b4dc4de3b2f4b0cc8e1719f0/logs/reproduction-progression-dependency-check.log), [expected negative control](https://github.com/jimmy00415/LeanOFCode_SYC/blob/b556e9bc6f16fe86b4dc4de3b2f4b0cc8e1719f0/logs/reproduction-progression-negative-control.log).

## Proof submission and reproduction

```json
[{"repository":"https://github.com/jimmy00415/LeanOFCode_SYC","branch":"main","commit":"b556e9bc6f16fe86b4dc4de3b2f4b0cc8e1719f0"}]
```

The original contribution is in `lean/ProgressionUpperBound.lean`, owned and published by the submitting account. [Complete setup and commands](https://github.com/jimmy00415/LeanOFCode_SYC/blob/b556e9bc6f16fe86b4dc4de3b2f4b0cc8e1719f0/research/progression-reproduction.md) include runtime verification, dependency setup, library build and target checks. Lean's toolchain and full dependency manifest are pinned in the repository; Mathlib is `db584cd6d46c92f209a44c0f1c829460d327499d`. The final recheck rebuilt our modules in the prepared environment; it did not rebuild all dependencies or Mathlib from scratch.

From the prepared repository root:

```powershell
& './tools/verify-progression.ps1'
```

## Attribution and mathematical sources

Jimmy (`jimmy00415`) with Codex: local cutoff derivation, the new proof module, complete-limit assembly, reports and executable verification. The selected commit provides the source and public contribution record. Library inputs retain their source credits and pinned history; they are not included in our authorship claim.

Mathematical source: Noga Alon and Gregory Freiman, [*On sums of subsets of a set of integers*](https://web.math.princeton.edu/~nalon/PDFS/Publications/On%20sums%20of%20subsets%20of%20a%20set%20of%20integers.pdf), Combinatorica 8 (1988), 297–306, Theorem 1.2 and the p. 298 asymptotic consequence, with the Erdős–Graham lower bound discussed there. This is a formalization submission of the stated mathematical result.

## Conclusion

The local implementation establishes the full interval asymptotic with limiting constant `1/2`. The proof, derivation and checks are supplied at the selected commit for mathematical and Lean review.

## Submission checklist

- [x] Only the relevant catalog's Lean-proof and attribution fields are changed.
- [x] The complete interval theorem, exact quantifiers and statement correspondence are provided for review.
- [x] Complete mathematical solution evidence is linked and mathematical authors are identified separately.
- [x] Our authored contribution is in the submitting account's repository, with a full commit contained in `main`, reproducible commands and axiom output.
- [x] No Lean source, binaries, archives or private identity/contact/payment information are added to the awards repository.
