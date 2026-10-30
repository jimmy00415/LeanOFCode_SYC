# JSP-000632 / Erdős 771: local proof report

Prepared by Jimmy (`jimmy00415`) and Codex on 30 October 2026. This report records our local derivation, Lean implementation, verification evidence, and conclusion.

## Result

The local module `lean/ProgressionUpperBound.lean` proves the complete limit

\[
\boxed{\displaystyle\lim_{n\to\infty}\frac{f(n)}{n/\log n}=\frac12.}
\]

The final declaration is `JSP000632Progression.erdosF_asymptotic_via_progression`. The work developed here consists of the direct lcm-cutoff argument, its endpoint estimates, the finite upper bound, and the assembly of the full limit. It uses pinned library lemmas for uniform subset-sum representation, prime-number asymptotics, and the uniform lower bound; reproducibility details are retained in the technical files.

## Exact statement

For a finite set `S`, let `Σ(S)` be the set of sums of its subsets, including the empty subset. Define

\[
f(n)=\max\left\{k\le n:\ \forall m\in\mathbb N_{>0},\quad
\exists S\subseteq\{1,\ldots,n\},\ |S|=k,\ m\notin\Sigma(S)\right\}.
\]

The logarithm is natural. The elements of `S` are distinct, and `S` may depend on `m`. The result concerns the interval `{1,…,n}`. The final theorem has no remaining numerical or analytic hypotheses; the explicit finite conditions below are discharged eventually as `n→∞`.

## Derivation and implementation

Set

\[
B=\lfloor\log_2 n\rfloor+1,\quad
R=\left\lfloor\frac{n^2}{10000B^3}\right\rfloor,\quad
V=\left\lfloor\frac{n^2}{1000B^2}\right\rfloor.
\]

Let `L(t)=lcm(1,…,t)`, with `L(0)=1`, and choose

\[
r=\max\{t:L(t)\le V\},\qquad m=L(r),\qquad
K=\left\lfloor\frac nr\right\rfloor+16B^{16}+r.
\]

The construction uses the cutoff itself as the parameter of the uniform representation theorem. For every `A⊆{1,…,n}` with `|A|≥K`, that theorem supplies a modulus `1≤q≤r` and represents every multiple of `q` in `[R,V]` as a subset sum of `A`. Because `q≤r`, we have `q∣m`.

The local endpoint calculation completes the target selection. If `r+1≤3B`, integer division gives `R(r+1)≤V`, while maximality gives

\[
V<L(r+1)\le(r+1)m.
\]

Cancelling the positive factor `r+1` yields `R<m≤V`. Hence every set of size at least `K` represents this same positive target, proving `f(n)<K`.

The finite theorem checks all of these conditions:

\[
n>10^7,\quad B>256(512\cdot1001)^2,\quad
B^{38}\le\lfloor n/2\rfloor,\quad V\ge1,\quad r\ge1,\quad r+1\le3B.
\]

The prime number theorem gives `log L(t)∼t`. Together with cutoff maximality and `log V∼2log n`, this yields `r∼2log n`; every displayed finite condition therefore holds for sufficiently large `n`. The Lean proof assembles the corresponding eventual statements explicitly.

For the lower bound, fix `c>2` and put `Q=⌈c log n⌉`. Eventually the product of primes through `Q` exceeds `n²`. Every positive target at most `n(n+1)/2` has a prime nondivisor `p≤Q`; the multiples of `p` up to `n` form an avoiding set. Targets above the total interval sum are avoided by the whole interval. Taking subsets gives the uniform bound

\[
\left\lfloor\frac n{\lceil c\log n\rceil}\right\rfloor\le f(n)<K.
\]

Finally,

\[
\frac{\lfloor n/r\rfloor}{n/\log n}\to\frac12,\qquad
\frac{16B^{16}+r}{n/\log n}\to0.
\]

The upper limit is at most `1/2`; the lower limit is at least `1/c` for every `c>2`, hence at least `1/2`. This proves the full limit.

## Work output and recorded verification

| Output | Content |
|---|---|
| `lean/ProgressionUpperBound.lean` | Cutoff definitions, endpoint lemmas, common represented target, eventual upper bound, normalized limit |
| `lean/ProgressionDependencyAudit.lean` | Transitive dependency check and final theorem axiom audit |
| `METHOD.zh-CN.md` | Chinese explanation of the process, results, and conclusion |
| `research/method-note.md` | Detailed finite and asymptotic derivation |

The fresh verification sequence ran on 30 October 2026 from 05:06:27 to 05:07:40 UTC (13:06–13:07 Hong Kong time):

| Check | Recorded result | Log |
|---|---|---|
| Local proof compilation | Exit 0; completed 05:06:50 UTC | `logs/reproduction-progression-proof.log` |
| Dependency-audit tool compilation | Exit 0 | `logs/reproduction-progression-audit-tool.log` |
| Transitive dependency audit | PASS; exit 0; completed 05:07:18 UTC | `logs/reproduction-progression-dependency-check.log` |
| Audit negative control | Expected rejection, exit 1 | `logs/reproduction-progression-negative-control.log` |

All ten locally printed theorem axiom lists contain exactly `propext`, `Classical.choice`, and `Quot.sound`, with no `sorryAx`. The dependency audit checks theorem bodies transitively, visits 72,948 constants, and passes all eight exclusion checks. Its negative control confirms that a prohibited dependency is rejected.

The commands recorded by these logs, run in the prepared reproduction project, are:

```powershell
lake env lean -o .lake/build/lib/lean/ProgressionUpperBound.olean ProgressionUpperBound.lean
lake env lean ProgressionDependencyAudit.lean
```

## Conclusion and mathematical references

The local work produces an implemented proof of the full Erdős 771 asymptotic. Its central construction chooses the maximal lcm cutoff and uses that same cutoff as the representation parameter, ensuring that every returned modulus divides the chosen target. The endpoint proof and vanishing normalized error complete the argument.

- N. Alon and G. Freiman, *On sums of subsets of a set of integers*, Combinatorica 8 (1988), 297–306: [paper](https://web.math.princeton.edu/~nalon/PDFS/Publications/On%20sums%20of%20subsets%20of%20a%20set%20of%20integers.pdf). This supplies the mathematical background for the representation method and records the Erdős–Graham lower-bound context.
- The prime number theorem, used in the Chebyshev forms `θ(x)∼x` and `ψ(x)∼x`, with `log lcm(1,…,t)=ψ(t)`.
