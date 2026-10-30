# Adversarial referee audit: JSP-000632 / Erdős 771

**Applicant clarification:** The applicant has since stated that they are the original contributor and requested submission. The active decision is GO for application preparation and attribution verification; see `../REPORT.md` and `../submission/STATUS.md`. Earlier personal-attribution assumptions below are historical, not an independent finding that the applicant is unrelated to the public source. The source, mathematical and build findings remain unchanged.

**Final verification addendum (12:17 HKT, 30 October 2026):** The pinned public target compiled successfully, and a separate audit printed only `propext`, `Classical.choice`, and `Quot.sound` for both final declarations. `FaithfulnessAudit.lean` also compiled, proving its explicit original predicate/maximum equal the prior proof's definitions and restating the full limit via that proof. See `../REPORT.md` and `../logs/reproduction-axiom-audit.log`. Earlier pending statements below describe the source-review checkpoint and are superseded by these executed results. This establishes no new authorship, official prize acceptance, or payment.


Review snapshot: **2026-10-30 04:05 UTC**. This is an independent, read-only mathematical and reporting review. No proof source was changed by this referee.

Reviewed:

- `research/mathematical-audit.md`, SHA-256 `31adce90450c1de99b8c143f3096ee5c8069475ecc65805f2653ab1a91af03f6`.
- `reproduction/lean-proofs/src/latest/StatementAudit.lean`, SHA-256 `7ae5dab0ae5183d5ef45b90b096a51285649d04366409a3da2de06a3e03b41b3`.
- `research/eligibility/Erdos771-pinned.lean`, SHA-256 `87c8f7c7a8aad46d1d6e1bb8a2b17a3b9f67fb6a4a4502e6ae1705002d9f6717`, corresponding to `plby/lean-proofs` commit `8822f7ddef30fadbd92e1c6ab4ed897af356af5e`.
- Actual pinned Mathlib definition `Combinatorics/Additive/SubsetSum.lean:37–50`.
- The original Erdős #771 HTML snapshot and paper page images 298 and 305, including Theorem 1.2 and Lemma 4.3.
- The user's mission and stop conditions in `research/mission.txt`.

## Referee verdict

**No mathematical defect was found in the stated #771 target, the elementary statement experiment, or the independent deduction of the asymptotic from the published fixed-target theorem plus PNT.** The proposed decision can be **NO-GO for a fresh original prize submission within the initial investigation budget**. It cannot yet be justified by saying that this session has independently verified a complete prior proof.

The report already labels the prior artifact a candidate and conditions completeness on successful checking. Preserve those qualifications in the final report. The concrete findings below concern what has actually been established, rather than hypothetical proof-system risks.

## Concrete reporting findings

### 1. The local experiment is not a proof of the asymptotic, nor a whole-target equivalence bridge

`StatementAudit.lean` imports only Mathlib. Its `ExactTarget` is a proposition definition, deliberately without a proof. Its new `avoids_iff_not_mem_subsetSum` theorem checks the finite-sum predicate, and `admissibleCard_le` justifies bounding admissible cardinalities by n. These are useful checks.

However, the file does not import the pinned `ErdosProblems.Erdos771` solution or prove equality of `JSP000632Audit.extremal` and `Erdos771.erdosF`. It does not prove `ExactTarget` equivalent to the imported endpoint in Lean. The equivalence of the whole target remains the source-level mathematical review, with the elementary predicate equivalence as supporting formal evidence.

Consequently, even if this file compiles, avoid formulations such as “the original asymptotic was verified,” “the prior theorem's statement equivalence was kernel checked,” or “the main theorem compiled” based on this experiment. Correct description: **the exact target was encoded as a proposition, and specified supporting lemmas compiled with their reported axiom dependencies**. The actual prior target needs its own build result.

### 2. A prior endpoint is a novelty conflict; its kernel validity is still an independent question

The pinned source has the correct unconditional endpoint and substantive supporting definitions. That rules out a responsible *claim of established novelty* for an implementation begun today. It does not, before the build and transitive axiom checks finish, prove the user's stronger stop condition “a verified complete formalization already exists.”

The current mathematical audit's conditional statement at line 94 is appropriately qualified. Keep the final verdict similarly bounded. Do not replace “prior full-scope proof candidate” with “verified complete prior proof” unless the separate reproduction evidence supports that exact statement. Also, a failed local dependency setup would not by itself prove the mathematics or public proof is invalid.

### 3. The catalog discrepancy is real, but it does not make Erdős #771 mathematically ambiguous

The user supplied #771 expressly as a related original source. That source and the paper's p.298 consequence identify a precise interval problem. The official catalog's phrase “an arbitrary finite integer set” does not specify the same host or its parameters. It is sound to flag an official-target mismatch for prize submission.

Do not say “we could not identify the original problem” or imply that the paper's #771 asymptotic is unresolved or ambiguous. A precise distinction is: **#771 is identified and well posed; the catalog's arbitrary-host phrasing does not itself authoritatively specify that same formal target**.

The two local examples `{1,2}` and `{2,4}` at target 3 correctly show that equal host cardinality does not determine the fixed-target optimum. They do not disprove every possible theorem quantifying uniformly over arbitrary hosts. Use them only for the dependence they actually demonstrate.

### 4. The optional shorter route must remain labeled as a route, not a new completed formal proof

The “Optional shorter mathematical route” observes that a suitable progression theorem plus a divisible lcm target avoids a prime-power endpoint argument. This is mathematically sensible and is closely related to the role of Lemma 4.3. It has not been implemented in the local experiment, and the reviewed candidate uses a different, explicit route that includes prime-power correction.

Do not present that observation as a compiled shortcut or as evidence that a new proof is a small remaining task. No change to the current cautiously worded paragraph is required.

## Detailed mathematical checks

### Quantifiers and maximum

Both local and pinned definitions use

```
∀ positive m, ∃ S ⊆ {1,...,n}, |S| = k and m is not a subset sum of S.
```

The set may depend on m. Exact cardinality is legitimate: avoidance is hereditary under passing to subsets, and any finite set of size at least k has a k-element subset. The local quantifier-swap theorem correctly proves that a single positive-element set avoiding every positive target must be empty.

The finite maximum is justified even at n=0: the empty set works for every positive target, so admissible cardinalities are nonempty; all admissible k are at most n. `Nat.findGreatest` therefore selects an actual feasible maximum. The pinned `erdosF_spec` and downward-closure lemma provide its specification. The local file now independently proves the cardinality bound and the same maximum properties.

### The identity f(n) = min over positive m of F(n,m)

The report's identity is correct, including the required attainment facts:

1. For fixed positive m, the avoiding family is a nonempty subfamily of the finite powerset of `[1,n]`, hence its maximum F(n,m) is attained.
2. The nonempty set of values F(n,m) lies in `{0,...,n}`, hence has a least attained value j.
3. Every universally admissible k satisfies k ≤ F(n,m) for each m, so f(n) ≤ j.
4. For each m, an optimizer of size F(n,m) has an avoiding j-element subset. Thus j is universally admissible, so j ≤ f(n).

There is no interchange of min and max without justification here. This also explains correctly why the upper bound needs one target, whereas the lower bound needs a construction uniform over all positive targets.

### Naturals, integers and empty sums

The actual Mathlib definition is `A.powerset.image (fun B => B.sum id)`; the empty subset is included and has sum zero. Since m>0, it causes no exception. A natural-number finite set contained in `Icc 1 n` is equivalent under casting to an integer set in the same positive interval. There is no loss of a negative-element case: such a case is absent from #771.

At n=0 and n=1 the normalized real expression uses Lean's total operations. These finitely many values do not affect convergence at `atTop`. The denominator is positive for every n≥2, which suffices for the asymptotic transformations.

### Uniform lower bound

The choice Q = ceil(c log n), with fixed c>2, gives θ(Q)/(log n) → c. Thus θ(Q)>2 log n eventually with a threshold depending on c, not on m. If every prime up to Q divided a positive m≤n(n+1)/2≤n², the squarefree primorial would divide m and exceed n², a contradiction.

Multiples of the obtained prime p≤Q avoid m and have size floor(n/p)≥floor(n/Q); shrinking gives the common cardinality. If m exceeds the total interval sum, the whole interval avoids it. Equality with the total sum is correctly placed in the prime-nondivisor branch, not the “whole interval avoids” branch.

The pinned interfaces at lines 477 and 600 express precisely this uniformity. No n-threshold depending on a moving m is hidden in the reviewed argument. Taking c arbitrarily close to 2 yields the claimed liminf.

### Maximal lcm and r+1

For sufficiently large n, X=floor(n²/(40(log n)²))≥1. The maximum r with L(r)≤X exists: L(t)≥t for positive t bounds the feasible indices, and the set is nonempty.

The key inequalities are valid:

```
L(r) ≤ X < L(r+1) ≤ (r+1)L(r).
```

If r+1 divided L(r), then L(r+1)=L(r)≤X, contradicting maximality. Every positive d≤r divides L(r). Therefore the least positive nondivisor of m=L(r) is exactly r+1. There is no off-by-one error from plateaus in the lcm sequence: choosing the **largest** feasible index is what makes the conclusion true.

The pinned code handles the bounded-search boundary r=X explicitly in `cutoff_next_lcm_gt`; it does not presume r+1 remains inside the `findGreatest` search interval. Its `cutoff_succ_not_dvd` and `leastNondivisor_lcmCutoff` then prove the intended facts.

### PNT, logarithm constants and range

The PNT relation ψ(t)~t, together with the lcm bracket, gives r~log X~2 log n. The lower estimate m>X/(r+1) is Ω(n²/(log n)³), which eventually exceeds 3n^(5/3+ε) for a fixed 0<ε<1/3. The factor 40 leaves strict room below n²/(20(log n)²). Rounding contributes no problem once X→∞.

The fixed-target formula then gives floor(n/(r+1))+r−1, whose normalized limit is 1/2; the error O(log n) becomes O((log n)²/n).

The candidate's separate binary scale B=floor(log₂n)+1 does not change the final constant. Its upper endpoint n²/(1000B²) still has natural logarithm asymptotic to 2log n, and hence its least nondivisor is asymptotic to 2log n. The additive 16B^16+s error normalizes to O((log n)^17/n)+O((log n)²/n), as reported.

### Paper endpoint repairs

Visual reading of p.305 confirms that Lemma 4.3's displayed lower target bound and its proof's factor-2 estimate need slack. The report's fixed smaller exponent ε'<ε repairs that issue eventually. The displayed sum bound in that proof is also too strong if read literally as summing to floor(n/2); the report's alternative uses the actual retained cardinality t. When s≤3log n, the triangular lower bound is asymptotically at least n²/(18(log n)²), leaving room for the required denominator 19. These are legitimate repairs of the deduction, not a refutation of Theorem 1.2.

## Recommended final-verdict wording

> **NO-GO for starting a fresh original prize formalization in this initial investigation.** Erdős #771 is mathematically precise and its known proof resolves the full asymptotic. We found an earlier public, full-scope Lean proof candidate, so novelty is not established, and the official catalog's arbitrary-host wording remains a submission-target discrepancy. Our local experiment checks the stated supporting lemmas; the existing candidate's complete build and transitive axiom audit are [state the actual observed result]. This does not establish prize eligibility or payment.

If reproduction succeeds, replace only the proof-status sentence with the exact target, pin, build result and observed axioms. If it remains incomplete, name the specific dependency/build obstruction. Neither outcome justifies claiming to have produced a new original proof of the main theorem.
