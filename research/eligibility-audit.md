# JSP-000632 eligibility, priority and competing-proof audit

**Applicant clarification:** The applicant has since stated that they are the original contributor and requested submission. The active decision is GO for application preparation and attribution verification; see `../REPORT.md` and `../submission/STATUS.md`. Earlier personal-attribution assumptions below are historical, not an independent finding that the applicant is unrelated to the public source. The source, mathematical and build findings remain unchanged.

**Final verification addendum (12:17 HKT, 30 October 2026):** The pinned public target compiled successfully, and a separate audit printed only `propext`, `Classical.choice`, and `Quot.sound` for both final declarations. `FaithfulnessAudit.lean` also compiled, proving its explicit original predicate/maximum equal the prior proof's definitions and restating the full limit via that proof. See `../REPORT.md` and `../logs/reproduction-axiom-audit.log`. Earlier pending statements below describe the source-review checkpoint and are superseded by these executed results. This establishes no new authorship, official prize acceptance, or payment.


Snapshot: **2026-10-30, approximately 03:57–04:02 UTC**. This report concerns JSP-000632 = **Erdős Problem 771**, the Alon–Freiman subset-sum avoidance asymptotic. It does not concern Erdős 632 or JSP-000771.

## Decision for new work

**Do not treat this as an unclaimed first formalization merely because the catalog says “Lean proof: No.”** An earlier public source contains an unconditional, full-scope Lean endpoint at a fixed commit, and multiple official-repository PRs have referenced it since September 2026. Its main statement and definitions were inspected directly in this audit. Independent compilation and transitive axiom validation are being performed separately; this report does **not** certify them.

The responsible current conclusion is:

- There is a serious prior full-scope formalization candidate, so novelty of a new implementation is not established.
- No matched PR has merged; no JSP-000632 candidate or confirmed award appears in the inspected registers.
- Neither fact establishes that a new submitter has priority, is eligible for a prize, or will receive payment.
- Existing partial/axiomatic developments are not complete proofs. Their incompleteness does not erase the separate `plby/lean-proofs` candidate.

## Sources and pinned state

The official awards repository's current main commit is **`fbaf42fcf8cfc036e00e9ae58a367155e8283e5a`**, read through the GitHub connector. The recursive tree response was not truncated. The catalog entry at this snapshot says Solved / Lean No / Eligible No and cites Alon–Freiman (1988), without a numerical bounty. See the [pinned catalog](https://github.com/TheJustinSunPrize/awards/blob/fbaf42fcf8cfc036e00e9ae58a367155e8283e5a/problems/catalog-0601-0700.md#JSP-000632).

The principal existing artifact is:

- Repository: [plby/lean-proofs](https://github.com/plby/lean-proofs).
- Commit: **`8822f7ddef30fadbd92e1c6ab4ed897af356af5e`**.
- Project: `src/latest/`, not the repository root.
- Proof: [Erdos771.lean at the pin](https://github.com/plby/lean-proofs/blob/8822f7ddef30fadbd92e1c6ab4ed897af356af5e/src/latest/ErdosProblems/Erdos771.lean).
- Header and repository problem page state Lean/Mathlib **v4.33.0**. Actual manifest/build validation belongs to the separate verification report.
- Formal source attribution: **Codex; GPT-5.6 Sol**. Informal source attribution: **Noga Alon; Gregory Freiman**. The [source metadata](https://github.com/plby/lean-proofs/blob/8822f7ddef30fadbd92e1c6ab4ed897af356af5e/data/sources.yaml#L5774) corroborates the header. Repository ownership or commit authorship does not alone decide award authorship.

The original Erdős webpage returned HTTP 403 to this subagent's web fetch. Statement correspondence here is based on the directly read Lean definitions, the independently maintained formal-conjectures statement, the paper reference, and the parent audit's original-source review. No claim is made that this subagent read a successful live rendering of that page.

## Actual prior-proof inspection

The pinned file has 4,563 lines. This number is descriptive, not evidence of correctness.

`Erdos771.AdmissibleCard n k` says that **for every positive target m there exists** a k-element subset of `Icc 1 n` whose subset sums avoid m. The avoiding subset may depend on m. `AvoidsSubsetSum m S` is `m ∉ S.subsetSum`. `erdosF n` is `Nat.findGreatest (AdmissibleCard n) n`; nearby lemmas prove zero admissibility, the maximum's specification, downward closure, and the expected comparison characterization.

This is the original optimization over subsets of the initial interval `{1,…,n}`. It is not a new theorem about an arbitrary externally supplied finite integer set, despite the catalog's loose English wording.

The endpoints `Erdos771.erdosF_asymptotic` (line 4528) and `Erdos771.erdos_771` (line 4547) have the unconditional type:

```lean
Tendsto (fun n : ℕ =>
  (erdosF n : ℝ) / ((n : ℝ) / Real.log (n : ℝ)))
  atTop (𝓝 (1 / 2 : ℝ))
```

There is no free representation theorem or asymptotic assumption in these endpoint signatures. The final `Iff.mp ... trivial` wrapper calls `erdosF_asymptotic`; it does not replace the conclusion with `True`.

The main file has no lexical occurrences of `sorry`, `admit`, `axiom`, `unsafe`, `native_decide`, or `implemented_by`. It imports Mathlib, `PrimeNumberTheoremAnd.Consequences`, and several substantial local Erdős modules. A clean main file does not establish a clean transitive proof. The final `#print axioms erdos_771` command exists in the source, but a command's presence is not its executed output.

A separate [October 20 source audit](https://github.com/xccElephant/justin-sun-prize-lean/blob/41a747d638b5e029d4fdc708ec019c435b4cae7b/verification/2026-10-20-final-search/SUBSET_SUMS.md) inspected the same pin and found 39 local modules / 56,219 lines with no stripped-source placeholder tokens. It explicitly did not compile or replay the kernel, and identified external boundaries including `BoundedGaps.BombieriVinogradov.Proof.MainTheorem`. That report is useful corroboration and a discovery aid, not an independent verification result adopted here.

## Priority evidence

[File history](https://api.github.com/repos/plby/lean-proofs/commits?path=src/latest/ErdosProblems/Erdos771.lean&per_page=100) contains an initial “Add Erdos771.” commit:

- `cbae03d6a2b93007d18511b9b45b591469078765`: author/committer date **2026-08-17 18:34:34 UTC**.
- Later file changes: August 23, August 25, September 1, and September 4.
- The selected complete-proof candidate commit `8822f7d...` has author/committer date **2026-09-15 20:59:44 UTC**.
- Official repository PR [#1050](https://github.com/TheJustinSunPrize/awards/pull/1050), created **2026-09-18 05:57:20 UTC**, explicitly identifies this exact pin, file, and target.

The initial file addition is not proved to be the first complete or publicly available proof. Git dates are user-controlled. The September 18 PR is independent public-history corroboration that the pinned artifact was being publicly identified by that time; the precise publication/completion date still requires review. No competing claimant's precedence is adjudicated here.

## Official PR and claim ledger

Searches covered all PR states. The API exact-ID search returned **8 results**, `incomplete_results=false`. The issue-only exact-ID search returned **0**, also with `incomplete_results=false`. Additional searches for 771, Alon/Freiman, and the proof's file/target names were used to find references that might omit the JSP identifier.

| PR | Created (UTC) | Snapshot state | Substance |
| --- | --- | --- | --- |
| [#1050](https://github.com/TheJustinSunPrize/awards/pull/1050) | 2026-09-18 05:57:20 | Open, unmerged | Catalog editor links the pinned plby full proof; explicitly makes no authorship or award claim. |
| [#1146](https://github.com/TheJustinSunPrize/awards/pull/1146) | 2026-09-18 09:43:47 | Closed, unmerged | Batch registration of the same external proof; closed September 19 for registering another contributor's proof. |
| [#1669](https://github.com/TheJustinSunPrize/awards/pull/1669) | 2026-09-19 04:32:52 | Open, unmerged | Same plby pin; catalog editor disclaims authorship and eligibility. |
| [#1854](https://github.com/TheJustinSunPrize/awards/pull/1854) | 2026-09-19 11:29:50 | Closed, unmerged | Actual source has four `True := trivial` declarations. Reviewer rejected partial formalization. |
| [#2854](https://github.com/TheJustinSunPrize/awards/pull/2854) | 2026-09-22 00:35:17 | Closed, unmerged | Actual source proves primality of 2,3,5,7,11 and arithmetic involving 632. No target asymptotic. |
| [#4049](https://github.com/TheJustinSunPrize/awards/pull/4049) | 2026-09-23 04:05:44 | Closed, unmerged | Same plby pin. Administratively closed October 27 for source-in-diff format; reviewer expressly makes no correctness, attribution or award determination. |
| [#4573](https://github.com/TheJustinSunPrize/awards/pull/4573) | 2026-09-28 03:24:28 | Open, unmerged | Actual source only checks 15 nonempty subset masks of {1,3,4,7} avoid 9. October 22 reviewer comment says partial work is insufficient and announces closure; API still reports open. |
| [#5357](https://github.com/TheJustinSunPrize/awards/pull/5357) | 2026-10-27 14:04:14 | Open, unmerged | Replacement for #4049, same plby pin, same disclaimer of authorship; no review comments at snapshot. |

The mismatch between #4573's reviewer prose and its open API state is preserved rather than “corrected” by inference. None of these PRs establishes an accepted first formalization. #4049's administrative closure does not establish a flaw in the plby proof. #1146's [explicit attribution rejection](https://github.com/TheJustinSunPrize/awards/pull/1146#issuecomment-5741357419) is especially relevant: copying or registering the prior proof on another author's behalf does not create eligibility.

The [candidate register](https://github.com/TheJustinSunPrize/awards/blob/fbaf42fcf8cfc036e00e9ae58a367155e8283e5a/candidates/README.md) and [confirmed award register](https://github.com/TheJustinSunPrize/awards/blob/fbaf42fcf8cfc036e00e9ae58a367155e8283e5a/awards/README.md) contain no JSP-000632 row. The complete recursive tree contains only each register README under those directories. This establishes no listed candidate/award in this snapshot, not absence of unpublished applications, work, or future adjudication.

## Other public formalizations

1. **Google DeepMind formal-conjectures** at main `feacabbcf6ed2e7b622663c3e1c0f61038183392`: [771.lean](https://github.com/google-deepmind/formal-conjectures/blob/feacabbcf6ed2e7b622663c3e1c0f61038183392/FormalConjectures/ErdosProblems/771.lean) proves basic API lemmas but leaves `erdos_771`, its lower-bound variant and upper-bound variant as `sorry`. PR [#7533](https://github.com/google-deepmind/formal-conjectures/pull/7533) merged **2026-10-22 16:25:31 UTC**. “Solved” there records mathematical status; the merged file is not a complete proof.
2. **rjwalters/lean-genius** at `470a7df849a5b2c21a8ee06db711561372bc639f`: [Erdos771Problem.lean](https://github.com/rjwalters/lean-genius/blob/470a7df849a5b2c21a8ee06db711561372bc639f/proofs/Proofs/Erdos771Problem.lean) explicitly introduces `axiom erdos_graham_lower_bound` (line 716) and `axiom alon_freiman_upper_bound` (line 756). Its concluding asymptotic uses those axioms. The elementary construction and small/intermediate regime modules do not discharge these two deep inputs.
3. **ryantuck/erdos-ai** at `5e0413e1741e58260ed2967bab53db30df853152`: [conjectures/771.lean](https://github.com/ryantuck/erdos-ai/blob/5e0413e1741e58260ed2967bab53db30df853152/conjectures/771.lean) is a correctly scoped statement ending in `sorry`.
4. **Mathlib**: scoped code searches for `erdos_771` found no match. Searches involving Alon/Freiman returned an unrelated arithmetic-progression definitions file. This is bounded search evidence, not proof that no equivalent theorem exists under another name.

Global GitHub code searches included `Erdos771`, `erdos_771`, `alon_freiman`, and the paper title. They found the above actual proof sources and secondary audits. Search indexes, private repositories, unindexed branches and arbitrary renamings remain outside a complete absence proof.

## Prize process and eligibility interpretation

JSP-000632 is **not** in the current [50-problem MathDB pilot](https://github.com/TheJustinSunPrize/awards/blob/fbaf42fcf8cfc036e00e9ae58a367155e8283e5a/problems/mathdb-pilot.md), so the repository directs it to the legacy process.

The website [Selection Rules](https://www.hejustinsun.com/prize/rules), accessed in this audit, distinguish verification entry from adjudication. They state retroactive eligibility from January 1, 2026, a 70/30 solver/formalizer split, priority ordering, discretionary tiers other than the designated $1 million Pinnacle tier, and identity/compliance requirements for disbursement. The historical 1988 solver attribution and a 2026 formalization are different contributions; this report does not infer a personal award entitlement from either.

The current repository's [contribution guide](https://github.com/TheJustinSunPrize/awards/blob/fbaf42fcf8cfc036e00e9ae58a367155e8283e5a/CONTRIBUTING.md) and [legacy process](https://github.com/TheJustinSunPrize/awards/blob/fbaf42fcf8cfc036e00e9ae58a367155e8283e5a/docs/award-process.md) add practical requirements:

- Complete original-problem solutions/formalizations only; special cases, weaker results and unproved hypotheses do not qualify under the current submission process.
- The Lean claimant must demonstrate their actual contribution in the original repository; mirrors, copied proofs and proxy registration are not enough.
- Priority follows the verified selected proof and corroborated public history, not merely PR opening time.
- Mathematical review and Lean verification precede acceptance. A successful local build alone is insufficient.
- A merged contribution PR is required for a legacy Lean claim; accepted publication of a candidate starts a separate 14-day public review.
- Identity, written recipient confirmation and unresolved challenges remain separate conditions. A merge, elapsed review window, announced award and actual payment are distinct states.

There are apparent differences between the website's general provisions (including partial-progress tiers and a peer-verified registration alternative) and the repository's current complete-proof/legacy-merge procedure. Do not resolve these differences by inventing an exception for this case. This audit reports the current operational documents and leaves official interpretation to the operator.

No source inspected establishes a fixed prize amount for JSP-000632 or a guaranteed payment to a new formalizer. A later independent proof may be mathematically valuable while failing first-contribution priority. If the prior candidate has a concrete verification or statement defect, that may justify a repair investigation; no such defect has been demonstrated by this eligibility audit.

## Local evidence and limits

Supporting artifacts are under `research/eligibility/`:

- `Erdos771-pinned.lean`: actual main proof text fetched at the exact pin.
- `formal-conjectures-771.lean`, `lean-genius-Erdos771Problem.lean`, `ryantuck-771.lean`: inspected alternative artifacts.
- `scoped1854.lean`, `scoped2854.lean`, `scoped4573.lean`: actual limited submissions.
- `github-evidence.json`, `additional-evidence.json`, `pr-ledger.json`: raw/normalized connector snapshots, timestamps, head commits, search results, comments, source history.
- `awards-*.md`: source documents and registers.
- `website-rules-extract.txt`: retrieved website rules.
- `prior-source-audit.md`: explicitly limited earlier third-party source audit.

All external interactions by this subagent were read-only. No messages, PRs, claims, registrations or repository mutations were sent. This report's proof-validity status must be updated from the separate actual-build/axiom audit before stating that the prior proof has been independently verified.
