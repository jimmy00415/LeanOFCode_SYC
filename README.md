# Erdős 771: a direct lcm-cutoff proof

This repository records the derivation, Lean implementation, and verification developed locally by Jimmy (`jimmy00415`) and Codex on 30 October 2026.

For each positive target `m`, choose a set `S⊆{1,…,n}` whose subset sums avoid `m`. Let `f(n)` be the largest cardinality that can be achieved for every target, allowing `S` to depend on `m`. The local Lean module proves the complete limit

\[
\boxed{\displaystyle\lim_{n\to\infty}\frac{f(n)}{n/\log n}=\frac12.}
\]

The final declaration is [`JSP000632Progression.erdosF_asymptotic_via_progression`](lean/ProgressionUpperBound.lean). The logarithm is natural, and the final theorem has no remaining numerical hypotheses.

The construction sets `m=lcm(1,…,r)`, where `r` is the largest cutoff whose lcm lies below the chosen upper endpoint. Using this same `r` as the parameter of the uniform representation lemma makes every returned modulus divide `m`. Our endpoint estimate places `m` inside the represented interval and gives an eventual bound

\[
f(n)<\left\lfloor\frac nr\right\rfloor+16B^{16}+r,
\qquad B=\lfloor\log_2n\rfloor+1,
\qquad r\sim2\log n.
\]

After normalization, the error tends to zero. Combining the upper bound with the uniform lower bound gives the full limit. The source header and pinned submodule retain the library inputs and their credits, including the representation, prime-number asymptotic, and lower-bound lemmas.

Read the [local proof report](REPORT.md), [Chinese method explanation](METHOD.zh-CN.md), and [detailed mathematical derivation](research/method-note.md) for the process, results, and conclusion.

Fresh verification on 30 October 2026, 05:06:27–05:07:40 UTC, passed: proof compilation, audit-tool compilation, and the transitive dependency check each exited 0; the negative control exited 1 as expected. The final theorem reports only `[propext, Classical.choice, Quot.sound]`. The dependency audit traversed 72,948 constants; the [reproduction guide](research/progression-reproduction.md) links the full logs and explains the check's scope.

In a prepared Windows PowerShell workspace, run:

```powershell
& './tools/verify-progression.ps1'
```

For a fresh checkout, follow the [complete setup and verification instructions](research/progression-reproduction.md). The [verification runner](tools/verify-progression.ps1) copies the four local Lean modules into the pinned project, compiles them, and checks the expected negative-control failure.

Mathematical reference: N. Alon and G. Freiman, *On sums of subsets of a set of integers*, Combinatorica 8 (1988), 297–306 ([paper](https://web.math.princeton.edu/~nalon/PDFS/Publications/On%20sums%20of%20subsets%20of%20a%20set%20of%20integers.pdf)). The asymptotic estimates also use the prime number theorem in its Chebyshev forms.
