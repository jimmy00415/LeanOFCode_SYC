# JSP-000632 / Erdős 771：本地推导、实现与结果

本文由 Jimmy（`jimmy00415`）与 Codex 在 2026 年 10 月 30 日共同完成，记录本地推导、Lean 实现、验证结果和结论。本次工作以最大最小公倍数截断为核心，构造统一目标，完成有限上界并与下界合成完整极限。数学背景为 Alon–Freiman 的子集和表示方法、Erdős–Graham 下界和素数定理。实现调用固定版本库中的中间引理，复现信息保存在项目技术文件中。

## 1. 精确问题

令 `[1,n]={1,2,…,n}`。对每个正整数目标 `m`，允许选择一个依赖于 `m` 的集合 `S⊆[1,n]`，要求它的任何子集的元素和都不等于 `m`。定义

\[
f(n)=\max\{k\le n:\ \forall m>0,\ \exists S\subseteq[1,n],\ |S|=k,
\ \forall A\subseteq S,\ \sum_{a\in A}a\ne m\}.
\]

目标是完整极限

\[
\frac{f(n)}{n/\log n}\longrightarrow\frac12.
\]

这里的对数是自然对数，集合元素不重复，空子集的和为零。必须先给定正目标再选集合；所选集合可以随目标变化。本文证明的宿主集合为区间 `[1,n]`。

## 2. 下界：寻找一个不整除目标的小素数

固定任意 `c>2`，取 `Q=⌈c log n⌉`。素数定理给出

\[
\log\prod_{p\le Q}p=\vartheta(Q)\sim Q,
\]

所以 `n` 足够大时，所有不超过 `Q` 的素数之积大于 `n²`。

对于 `1≤m≤n(n+1)/2≤n²`，这些素数不可能全部整除 `m`，否则其乘积也整除 `m`，与乘积大于 `m` 矛盾。因此存在素数 `p≤Q` 不整除 `m`。

选取 `[1,n]` 中所有 `p` 的倍数。该集合有 `⌊n/p⌋≥⌊n/Q⌋` 个元素，任何子集和仍被 `p` 整除，因此不可能等于 `m`。若需要恰好 `⌊n/Q⌋` 个元素，取相应大小的子集即可。

对于 `m>n(n+1)/2`，整个区间的总和都小于 `m`，同样可以选取所需大小的集合。因而这个构造对每个正目标都有效，并得到

\[
f(n)\ge\left\lfloor\frac n{\lceil c\log n\rceil}\right\rfloor,
\qquad
\liminf\frac{f(n)}{n/\log n}\ge\frac1c.
\]

对每个固定 `c>2` 都有这个估计，让 `c` 从上方趋近 `2`，得到下极限至少为 `1/2`。充分大的起点只依赖于 `c`，不依赖于任意给定的目标 `m`。

## 3. 上界：选择能被所有相关小模数整除的目标

设 `B=⌊log₂ n⌋+1`，并取整数端点

\[
R=\left\lfloor\frac{n^2}{10000B^3}\right\rfloor,
\qquad
V=\left\lfloor\frac{n^2}{1000B^2}\right\rfloor.
\]

记 `L(r)=lcm(1,…,r)`。选最大的 `r` 使 `L(r)≤V`，令目标 `m=L(r)`。于是

\[
m\le V<L(r+1)\le(r+1)m.
\]

本地推导的关键是在均匀子集和表示定理中使用参数 **`r`**。对充分大的 `n` 和任意集合 `A⊆[1,n]`，若

\[
|A|\ge K(n,r):=\left\lfloor\frac nr\right\rfloor+16B^{16}+r,
\]

该定理给出一个 `1≤q≤r`，使区间 `[R,V]` 中所有 `q` 的倍数都能表示成 `A` 的子集和。由于 `q≤r`，直接有 `q∣L(r)=m`。

还须检查 `m` 确实落在表示区间。上端 `m≤V` 已成立。对下端，充分大的 `n` 满足 `r+1≤3B`。令 `D=1000B²`、`E=10000B³`，由 `RE≤n²` 得

\[
(R(r+1))D\le R(3B)D\le RE\le n^2,
\]

故 `R(r+1)≤⌊n²/D⌋=V`。结合 `V<(r+1)m`，可得 `R<m`。因此 `m` 被表示，任何大小至少为 `K(n,r)` 的集合都无法避开这个目标，得到 `f(n)<K(n,r)`。

均匀表示定理的数学基础包括 Fourier 分析、除数抽取和等差数列覆盖。实际应用时保留全部有限条件：`n>10⁷`、`B>256(512·1001)²`、`B³⁸≤⌊n/2⌋`、`V≥1`、`r≥1` 和 `r+1≤3B`。由 `B∼log n/log 2`、`r∼2log n` 及固定对数幂相对 `n` 趋于零，这些条件最终全部成立；Lean 中显式组合了相应的最终成立结论。

## 4. 常数为什么仍是 1/2

由素数定理，`log L(r)∼r`。最大截断的性质给出 `r∼log V`，而 `log V∼2log n`，所以 `r∼2log n`。于是

\[
\frac{\lfloor n/r\rfloor}{n/\log n}\to\frac12,
\qquad
\frac{16B^{16}+r}{n/\log n}\to0.
\]

因此上极限至多为 `1/2`；与下界合并，得到所需完整极限。这里的 `2` 来自可用目标规模约为 `n²`，再经最小公倍数的指数增长转化为模数规模约 `2log n`。

## 5. 本地实现过程

实现文件为 `lean/ProgressionUpperBound.lean`，命名空间为 `JSP000632Progression`。工作按以下数学接口完成：

| 步骤 | 本地 Lean 定理 | 结果 |
|---|---|---|
| 整数端点估计 | `lowerEndpoint_mul_le_upper` | `s≤3B` 时 `Rs≤V` |
| 截断目标定位 | `lowerEndpoint_lt_cutoffTarget` | `R<m` |
| 统一表示目标 | `cutoffTarget_mem_subsetSum` | 所有达到阈值的集合都表示 `m` |
| 有限条件最终成立 | `eventually_erdosF_lt_cutoffThreshold` | 最终有 `f(n)<K(n,r)` |
| 截断尺度 | `cutoff_ratio_tendsto_two` | `r/log n→2` |
| 整数商及误差估计 | `natDiv_cutoff_ratio_tendsto_half`、`cutoff_error_tendsto_zero` | 主项趋于 `1/2`，截断误差趋于零 |
| 阈值归一化 | `cutoffThreshold_ratio_tendsto_half` | `K(n,r)/(n/log n)→1/2` |
| 上下界合成 | `erdosF_asymptotic_via_progression` | 完整极限为 `1/2` |

其中自然数整除部分使用夹逼：整数商位于相邻截断的整数商与实数商之间，再除以正的 `n/log n`；两侧极限均为 `1/2`。最终证明使用极限的序刻画，分别处理任意 `a<1/2` 和 `b>1/2`，覆盖所有充分大的自然数。

## 6. 验证结果与结论

本次重新验证于 2026 年 10 月 30 日 05:06:27–05:07:40 UTC（香港时间 13:06–13:07）执行。本地编译记录 `logs/reproduction-progression-proof.log` 于 05:06:50 UTC 完成，退出码为 `0`。十个本地定理的公理输出均为：

```text
[propext, Classical.choice, Quot.sound]
```

最终定理为 `JSP000632Progression.erdosF_asymptotic_via_progression`，输出不含 `sorryAx`。`logs/reproduction-progression-dependency-check.log` 于 05:07:18 UTC 记录传递依赖审计通过、退出码为 `0`；审计遍历 72,948 个常量的实际证明体，八项排除检查全部通过。负对照按预期被拒绝，退出码为 `1`，记录于 `logs/reproduction-progression-negative-control.log`，表明审计确实能够识别禁止的依赖。

本地工作完成了从“选择目标”到“有限上界”再到“完整渐近极限”的证明链：选择 `m=L(r)`，以 `r` 限制表示定理输出的模数，使每个模数都整除目标；严格检查整数端点；消去归一化后的多对数误差；最后与对所有正目标成立的下界合并。结论为

\[
\boxed{f(n)=\left(\frac12+o(1)\right)\frac n{\log n}.}
\]

## 数学参考

- N. Alon 与 G. Freiman，*On sums of subsets of a set of integers*，Combinatorica 8 (1988), 297–306：[原论文](https://web.math.princeton.edu/~nalon/PDFS/Publications/On%20sums%20of%20subsets%20of%20a%20set%20of%20integers.pdf)。子集和表示方法及 Erdős–Graham 下界背景见该文。
- 素数定理：使用 Chebyshev 函数形式 `θ(x)∼x`、`ψ(x)∼x`，以及恒等式 `log lcm(1,…,t)=ψ(t)`。

完整有限条件与渐近推导见 `research/method-note.md`；复现命令及日志索引见 `REPORT.md`。
