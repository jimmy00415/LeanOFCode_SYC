# A direct lcm-cutoff upper bound for Erdős Problem 771

Prepared by Jimmy (`jimmy00415`) and Codex on 30 October 2026. This note records the derivation and local Lean implementation of a direct lcm-cutoff upper bound, its finite hypotheses, and its combination with the uniform lower bound to prove the complete Erdős 771 asymptotic.

## 中文摘要

本地工作完成了最大最小公倍数截断的证明路线及 Lean 实现。令 `V` 为二次规模除以对数平方的上端点，取最大的 `r` 使 `lcm(1,…,r)≤V`，并令 `m=lcm(1,…,r)`。将均匀表示定理的参数设为 **`s=r`**，便得到 `1≤q≤r`，因此 `q|m` 自动成立。

目标范围由整数端点估计确定。记 `B=⌊log₂n⌋+1`、`R=⌊n²/(10000B³)⌋`、`V=⌊n²/(1000B²)⌋`。当 `r+1≤3B` 时，整数除法给出 `R(r+1)≤V`；最大性给出 `V<lcm(1,…,r+1)≤(r+1)m`。故 `R<m≤V`，直接在表示定理覆盖的区间内。

得到的有限阈值为 `K(n,r)=⌊n/r⌋+16B¹⁶+r`。素数定理与截断最大性给出 `r∼2log n`；阈值除以 `n/log n` 后，主项趋于 `1/2`，其余两项趋于零。

下界对每一个正目标 `m` 都成立：当 `m` 不超过整个区间的总和时，对任意固定的 `δ>0`，素数定理保证充分大的 `n` 存在不超过 `⌈(2+δ)log n⌉` 且不整除 `m` 的素数，其倍数构成避免 `m` 的大集合；当 `m` 超过总和时，整个区间即可避免它。上界选取一个共同目标 `m=L(r)`。两个方向共同给出 `f(n)=(1/2+o(1))n/log n`。

实现文件为 `lean/ProgressionUpperBound.lean`，最终定理为 `JSP000632Progression.erdosF_asymptotic_via_progression`。实现使用固定版本库的表示定理、素数渐近和下界引理；技术复现信息保存在项目文件中。本文后半部分记录实际编译与依赖审计结果。

## 1. Exact problem and scope

Let `[n]={1,...,n}` and, for a finite set `S` of positive integers, define

\[
\Sigma(S)=\left\{\sum_{a\in T}a:T\subseteq S\right\}.
\]

The elements are distinct; the empty subset is allowed. Define

\[
P(n,k)\quad\Longleftrightarrow\quad
\forall m\in\mathbb N_{>0}\ \exists S\subseteq[n],
\qquad |S|=k\quad\hbox{and}\quad m\notin\Sigma(S),
\]

and

\[
f(n)=\max\{k\in\{0,\ldots,n\}:P(n,k)\}.
\tag{1}
\]

The exact target is

\[
\lim_{n\to\infty}\frac{f(n)}{n/\log n}=\frac12,
\tag{2}
\]

with the natural logarithm. The quantifier order matters: the avoiding set may depend on the prescribed positive target. The maximum exists since the empty set is admissible and every subset of `[n]` has at most `n` elements. Avoidance is inherited by subsets, so an avoiding set of size at least `k` can always be reduced to size exactly `k`.

This is the interval formulation of Erdős #771. Every occurrence of the host set below means the consecutive positive integers `[n]`.

## 2. Mathematical background and the representation interface

The mathematical background is the subset-sum representation method of Alon–Freiman and the Erdős–Graham lower bound, described in N. Alon and G. Freiman, *On sums of subsets of a set of integers*, Combinatorica 8 (1988), 297–306. Prime-number asymptotics enter through the Chebyshev functions `θ` and `ψ`. The precise quantitative representation statement used in the local proof is given below.

The Lean interface is `Erdos771.af_uniform_representation`.

All quotients defining natural-number parameters below are integer quotients. Put

\[
\begin{aligned}
B=B(n)&=\lfloor\log_2 n\rfloor+1,\\
R=R(n)&=\left\lfloor\frac{n^2}{10000B^3}\right\rfloor,\\
V=V(n)&=\left\lfloor\frac{n^2}{1000B^2}\right\rfloor,\\
K(n,s)&=\left\lfloor\frac ns\right\rfloor+16B^{16}+s.
\end{aligned}
\tag{3}
\]

For `n=0`, `B` is understood as the existing total natural-number definition `Nat.log 2 n + 1`. Only large positive `n` occur in the theorem below.

**Uniform representation input.** Suppose

\[
n>10^7,\qquad B>256(512\cdot1001)^2,
\qquad B^{38}\le\lfloor n/2\rfloor.
\tag{4}
\]

For every integer `s` with `1≤s≤3B`, and every `A⊆[n]` satisfying `|A|≥K(n,s)`, there are an integer `q` and a finite set `G` such that

\[
1\le q\le s,\qquad G=\{a\in A:q\mid a\},
\tag{5}
\]

and every integer `M` with

\[
R\le M\le V,\qquad q\mid M
\tag{6}
\]

belongs to `Σ(G)`, hence to `Σ(A)`.

This finite theorem is applied with all its hypotheses intact. Its mathematical ingredients include a Fourier coefficient identity for counting subsets, local positivity, rational approximation and residue estimates, divisor extraction, gcd refinement, and extension of an interval of represented multiples. The local cutoff construction uses the resulting interface (4)–(6).

## 3. Lcm cutoff: elementary facts and exact endpoints

Let

\[
L(t)=\operatorname{lcm}(1,\ldots,t),\qquad L(0)=1.
\]

For an integer `V≥1`, define

\[
r=\max\{t\in\mathbb N:L(t)\le V\},
\qquad m=L(r).
\tag{7}
\]

The implementation `lcmCutoff V` searches only `t≤V`, which gives the same maximum: `L(t)≥t` for every positive `t`, since `t|L(t)`. Also `r≥1`, because `L(1)=1≤V`.

Maximality and the elementary lcm product bound give

\[
1\le m\le V<L(r+1)\le(r+1)m.
\tag{8}
\]

The strict inequality is maximality, including across possible plateaus of the lcm sequence. The last inequality follows from

\[
L(r+1)=\operatorname{lcm}(L(r),r+1)\mid (r+1)L(r).
\]

In particular,

\[
q\in\mathbb N,\ 1\le q\le r\quad\Longrightarrow\quad q\mid m.
\tag{9}
\]

The target `m` depends on `n`, through `V(n)`, but does not depend on the set `A` against which the upper bound is tested.

**Endpoint lemma.** For any integers `n≥0`, `B≥1`, and `t≤3B`, the parameters in (3) satisfy

\[
Rt\le V.
\tag{10}
\]

**Proof.** Set `D=1000B²` and `E=10000B³=10BD`. The defining floor inequality is `RE≤n²`. Since `D>0` and `t≤3B`,

\[
(Rt)D\le R(3B)D=3000RB^3\le10000RB^3=RE\le n^2.
\]

Both `Rt` and `D` are integers, so division by the positive integer `D` yields `Rt≤floor(n²/D)=V`. This verifies the floor arithmetic without replacing a floor by a real quotient. ∎

In particular, if `r+1≤3B`, then (8) and (10) give

\[
R(r+1)\le V<(r+1)m.
\]

Cancelling the positive factor `r+1` proves

\[
R<m\le V.
\tag{11}
\]

The endpoint estimate is a statement about integer division throughout, including the cases where `R` is zero. In the finite theorem, `V≥1` ensures the selected target is positive.

## 4. Finite direct-target theorem

**Theorem 1 (finite upper bound).** Let `n` satisfy (4). Set `B,R,V` by (3), and suppose

\[
V\ge1,\qquad r+1\le3B,
\tag{12}
\]

where `r,m` are defined by (7). Then every `A⊆[n]` with

\[
|A|\ge K(n,r)=\left\lfloor\frac nr\right\rfloor+16B^{16}+r
\tag{13}
\]

satisfies `m∈Σ(A)`. Consequently,

\[
f(n)<K(n,r).
\tag{14}
\]

**Proof.** Since `V≥1`, Section 3 gives `r≥1`; (12) also gives `r≤3B`. Apply the uniform representation theorem with parameter **`s=r`**. There are `q,G` satisfying (5)–(6), now with `1≤q≤r`. Hence `q|m` by (9). Equation (11) puts `m` in `[R,V]`. Therefore the representation theorem directly gives `m∈Σ(G)⊆Σ(A)`.

For (14), assume `f(n)≥K(n,r)`. The definition of `f(n)`, applied to the single positive target `m`, supplies an avoiding set `A⊆[n]` of size `f(n)`. This contradicts the representation just proved. ∎

Every allowed modulus divides the selected target, so the cutoff target assembly applies the representation theorem directly. The target depends only on `n`; the modulus and its divisible subset may depend on `A`. This order of choices supplies one common target represented by every set at or above the cardinality threshold.

## 5. Why all finite hypotheses eventually hold

Here `log` is natural. For positive `n`,

\[
B\sim\frac{\log n}{\log2}.
\tag{15}
\]

Thus `B→∞` and every fixed power of `B` is `o(n)`. In particular, all three inequalities in (4) hold for sufficiently large `n`. Also

\[
V\sim\frac{n^2}{1000B^2}\longrightarrow\infty,
\qquad
\frac{\log V}{\log n}\longrightarrow2.
\tag{16}
\]

The floor changes `V` by less than one, and the real quantity being floored tends to infinity, so it does not alter either assertion.

The prime number theorem, in Chebyshev form, gives

\[
\psi(x)\sim x,\qquad \log L(t)=\psi(t)\quad(t\in\mathbb N).
\tag{17}
\]

First `r→∞`: for each fixed `T`, eventually `V≥L(T)`, so the maximal cutoff is at least `T`. From (8),

\[
\psi(r)\le\log V<\psi(r+1).
\tag{18}
\]

For a fully explicit asymptotic squeeze, fix `0<η<1`. Once `r` is sufficiently large, (17) gives

\[
(1-\eta)r\le\psi(r),\qquad
\psi(r+1)\le(1+\eta)(r+1).
\]

Combining with (18) yields

\[
\frac{\log V}{1+\eta}-1<r\le\frac{\log V}{1-\eta}.
\]

Letting `V→∞` and then `η↓0` proves `r/log V→1`. With (16),

\[
\frac r{\log n}\longrightarrow2,
\qquad
\frac{r+1}{B}\longrightarrow2\log2<3.
\tag{19}
\]

Consequently (12) also holds eventually. This checks every hypothesis of Theorem 1. No threshold is allowed to depend on the arbitrary set `A` or a separately varying prescribed target: after `n` is chosen, Theorem 1 applies to **all** sets satisfying (13), with the same selected `m(n)`.

The local Lean proof obtains the ratio for `r` from the lcm/PNT ratio for `r+1`, subtracting `1/log n→0`. This makes the connection between the available cutoff estimate and (19) explicit.

## 6. The complete lower bound and the constant 1/2

Fix any real `c>2` and set `Q=ceil(c log n)`. For sufficiently large `n`, `Q≥1` and

\[
\frac{\theta(Q)}{\log n}
=\frac{\theta(Q)}Q\frac Q{\log n}\longrightarrow c.
\]

Hence `θ(Q)>2log n`. Let `P_Q` be the product of all primes at most `Q`. Since `log P_Q=θ(Q)`,

\[
P_Q>n^2.
\tag{20}
\]

Now let `m>0` be arbitrary.

- If `m>n(n+1)/2`, the entire interval `[n]` avoids `m`, because every subset sum is at most the sum of `[n]`.
- If `m≤n(n+1)/2≤n²`, not every prime at most `Q` can divide `m`: otherwise their squarefree product would divide the positive integer `m`, forcing `P_Q≤m≤n²`, contrary to (20). Choose a prime `p≤Q` that does not divide `m`. The set of positive multiples of `p` up to `n` has size `floor(n/p)` and every one of its subset sums is divisible by `p`; it therefore avoids `m`.

In either case there is an avoiding set of size at least `floor(n/Q)`. Passing to a subset gives that exact common cardinality, independently of the target. Thus, eventually in `n`,

\[
\left\lfloor\frac n{\lceil c\log n\rceil}\right\rfloor
\le f(n).
\tag{21}
\]

The threshold depends on the fixed `c`, not on `m`. The equality case `m=n(n+1)/2` belongs to the prime-nondivisor branch, not to the branch using the whole interval.

Since `Q/log n→c`, and an integer-part error of at most one becomes at most `log n/n` after normalization, (21) gives

\[
\liminf_{n\to\infty}\frac{f(n)}{n/\log n}\ge\frac1c.
\]

This holds for every `c>2`, so the liminf is at least `1/2`.

On the upper side, (14), (15) and (19) imply

\[
\begin{aligned}
\frac{K(n,r)}{n/\log n}
&=\frac{\lfloor n/r\rfloor}{n/\log n}
  +16\frac{B^{16}\log n}{n}
  +\frac{r\log n}{n}\\
&\longrightarrow\frac12+0+0.
\end{aligned}
\tag{22}
\]

Indeed, the first term differs from `log n/r` by less than `log n/n`; the second is `O((log n)^17/n)`; and the third is `O((log n)^2/n)`. Therefore the limsup is at most `1/2`, proving (2).

Equivalently, the complete result can be displayed as the following two-sided theorem: for every fixed `c>2`, there is `N(c)` such that for all integers `n≥N(c)`,

\[
\boxed{
\left\lfloor\frac n{\lceil c\log n\rceil}\right\rfloor
\le f(n)
<\left\lfloor\frac n{r(n)}\right\rfloor+16B(n)^{16}+r(n),
\qquad r(n)\sim2\log n.
}
\tag{23}
\]

The upper hypotheses themselves require only an absolute eventual threshold; dependence on `c` comes from the lower bound. As (22) tends to `1/2`, the upper threshold is eventually less than `n`, so the density assertion is not merely vacuous.

The constant has a concrete origin in both constructions. Positive subset sums from `[n]` live on a quadratic scale `n²`. Divisibility obstructions are controlled by products/lcms of small integers, whose logarithm grows linearly with the cutoff by PNT. Taking the logarithm of a quadratic scale gives `2log n`; taking multiples of a modulus of that size leaves about `n/(2log n)` elements. The polylogarithmic reductions in `V` contribute only `O(log log n)` to `log V` and do not change the factor `2`.

## 7. Local implementation process

The module `lean/ProgressionUpperBound.lean` implements the argument in the namespace `JSP000632Progression`. Its three definitions are `cutoff`, `cutoffTarget`, and `cutoffThreshold`, corresponding to `r`, `m`, and `K(n,r)`.

| Mathematical step | Local Lean declaration |
|---|---|
| Integer endpoint inequality (10) | `lowerEndpoint_mul_le_upper` |
| Strict lower endpoint for the target (11) | `lowerEndpoint_lt_cutoffTarget` |
| Every set at the threshold represents the target | `cutoffTarget_mem_subsetSum` |
| Finite hypotheses hold eventually; hence (14) holds eventually | `eventually_erdosF_lt_cutoffThreshold` |
| Cutoff scale `r/log n→2` | `cutoff_ratio_tendsto_two` |
| Normalized integer quotient tends to `1/2` | `natDiv_cutoff_ratio_tendsto_half` |
| Normalized cutoff term tends to zero | `cutoff_error_tendsto_zero` |
| Complete threshold limit (22) | `cutoffThreshold_ratio_tendsto_half` |
| Normalized eventual upper bound | `eventually_erdosF_ratio_le_cutoffThreshold` |
| Full limit (2) | `erdosF_asymptotic_via_progression` |

The endpoint proof uses natural-number multiplication and division, preserving every floor. The target representation applies the representation input at `s=r`, obtains `q∣m`, and transfers the subset sum from `G` to `A` by inclusion. The eventual upper-bound proof collects all six numerical conditions from Sections 2–5 before applying this finite result.

For the quotient limit, the implementation squeezes the natural-number quotient between a neighboring-cutoff quotient and the real quotient:

\[
\frac{\lfloor n/(r+1)\rfloor}{n/\log n}
\le
\frac{\lfloor n/r\rfloor}{n/\log n}
\le
\frac{\log n}{r}
\qquad(n>1,\ r>0).
\]

Both bounding sequences tend to `1/2`. The seed error and cutoff error then vanish, yielding (22). The final theorem uses the order characterization of convergence: for each `a<1/2`, the uniform lower estimate eventually exceeds `a`; for each `b>1/2`, the normalized upper threshold is eventually below `b`.

The local cutoff target assembly requires no additional residue correction after the representation theorem supplies its modulus. The representation theorem itself retains its analytic and modular ingredients described in Section 2.

## 8. Verification results

The fresh verification sequence ran on 30 October 2026 from 05:06:27 to 05:07:40 UTC (13:06–13:07 Hong Kong time). The proof compilation and dependency checks completed successfully.

| Check | Result | Retained log |
|---|---|---|
| Local proof compilation | Exit 0; finished 05:06:50 UTC | `logs/reproduction-progression-proof.log` |
| Dependency-audit tool compilation | Exit 0 | `logs/reproduction-progression-audit-tool.log` |
| Final theorem's transitive dependency audit | PASS; exit 0; finished 05:07:18 UTC | `logs/reproduction-progression-dependency-check.log` |
| Audit negative control | Expected rejection, exit 1; finished 05:07:40 UTC | `logs/reproduction-progression-negative-control.log` |

All ten locally printed theorem axiom lists contain exactly

```text
[propext, Classical.choice, Quot.sound]
```

The final declaration is

```lean
theorem JSP000632Progression.erdosF_asymptotic_via_progression :
    Tendsto (fun n : ℕ => (Erdos771.erdosF n : ℝ) /
      ((n : ℝ) / Real.log (n : ℝ))) atTop (𝓝 (1 / 2 : ℝ))
```

There is no `sorryAx` in its axiom output. The transitive audit visited 72,948 constants and passed all eight exclusion checks. Its negative control deliberately supplies a prohibited dependency and confirms that the audit rejects it. These checks examine actual theorem bodies, in addition to the compiler's type checking.

The recorded proof and audit commands, run in the prepared reproduction project, are:

```powershell
lake env lean -o .lake/build/lib/lean/ProgressionUpperBound.olean ProgressionUpperBound.lean
lake env lean -o .lake/build/lib/lean/ProofDependencyAudit.olean ProofDependencyAudit.lean
lake env lean ProgressionDependencyAudit.lean
lake env lean DependencyAuditNegative.lean
```

The final command is the expected-failure control. Its exit code `1` verifies rejection and is treated as a successful control by the verification runner.

## 9. Conclusion and mathematical references

The local proof establishes an eventual finite upper bound with the explicit common target `m=L(r)`, proves that its normalized threshold tends to `1/2`, and combines it with a uniform lower bound to obtain the full limit. The cutoff construction aligns the range of possible moduli with the divisors of the selected target. Exact endpoint arithmetic makes that target available to the representation theorem, and the prime number theorem fixes the cutoff scale at `2log n`.

The delivered mathematical result is

\[
\boxed{\displaystyle f(n)=\left(\frac12+o(1)\right)\frac n{\log n}.}
\]

- N. Alon and G. Freiman, *On sums of subsets of a set of integers*, Combinatorica 8 (1988), 297–306: [paper](https://web.math.princeton.edu/~nalon/PDFS/Publications/On%20sums%20of%20subsets%20of%20a%20set%20of%20integers.pdf). Mathematical background for the subset-sum representation method and the Erdős–Graham lower bound.
- The prime number theorem in the forms `θ(x)∼x` and `ψ(x)∼x`, together with the primorial identity `log ∏_{p≤x}p=θ(x)` and the lcm identity `log L(t)=ψ(t)`.
