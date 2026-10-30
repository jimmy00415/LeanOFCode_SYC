# Lean reproduction audit — JSP-000632 / Erdős 771

This is an independent reproduction audit of an existing public formalization. It is not an original solution, a submission, or a claim that an open benchmark target has been newly solved.

**Outcome:** the pinned public proof compiled successfully, and an independent audit of both final declarations reported only `[propext, Classical.choice, Quot.sound]`. No `sorryAx`, custom axiom, or extra theorem hypothesis appears in those final results. The exact commands and retained evidence are below.

## Pinned inputs

- Public repository: `https://github.com/plby/lean-proofs`
- Commit: `8822f7ddef30fadbd92e1c6ab4ed897af356af5e` (Git commit date: 2026-09-15T13:59:44-07:00).
- Target source: `src/latest/ErdosProblems/Erdos771.lean`.
- Target declarations: `Erdos771.erdosF_asymptotic` and `Erdos771.erdos_771`.
- Project toolchain: `leanprover/lean4:v4.33.0`.
- Lean runtime: `Lean (version 4.33.0, x86_64-w64-windows-gnu, commit d8b18978322de05a8f3dba51ef03cf5461676c17, Release)`.
- Lake runtime: `Lake version 5.0.0-src+d8b1897 (Lean version 4.33.0)`.
- Mathlib commit: `db584cd6d46c92f209a44c0f1c829460d327499d`.
- BoundedGaps/FormalPantheon commit: `ffbb65c21afc8a36ace67720f1b0df1c63d26bd1`.
- Runtime ZIP: `https://github.com/leanprover/lean4/releases/download/v4.33.0/lean-4.33.0-windows.zip`.
- Runtime ZIP SHA-256 verified against the release API digest: `301edc4cf03571c839cd7bf73ec850921f36d9451dbec68da557969a845726d9`.

The runtime and caches are confined to this workspace. No global Lean/Elan installation was created. Full dependency pins are preserved in the original `lake-manifest.json` and `logs/reproduction-pinned-metadata.log`.

## Source-level findings

The local import closure contains 40 repository modules, totaling 56,636 lines, including the target. Following custom external imports through BoundedGaps resolves 312 modules, totaling 111,279 lines before the repository's supplied compatibility patches and 111,270 lines after those patches. Standard Mathlib/Batteries/tactic-package sources are outside this custom-source count.

The comment-stripping source scan found no `sorry`, `admit`, `axiom`, `unsafe`, `native_decide`, `implemented_by`, or `extern` tokens in that custom closure. The scan is a heuristic, not a substitute for elaboration or an axiom audit. Per-module paths, hashes, imports, and scan results are retained in `reproduction/import-audit.json` and `reproduction/import-audit-with-dependencies.json`.

The direct external boundary `BoundedGaps.BombieriVinogradov.Proof.MainTheorem` explains why a small-looking import list requires a substantial source build.

## Reproduction sequence and observed environment issue

Commands run from `D:/VS_Project/LeanCode` unless a working directory is stated:

```powershell
git clone --filter=blob:none --no-checkout https://github.com/plby/lean-proofs.git reproduction/lean-proofs
git -C reproduction/lean-proofs checkout --detach 8822f7ddef30fadbd92e1c6ab4ed897af356af5e
python tools/lean-fetch-dependencies.py
python tools/lean-audit-imports.py
python tools/lean-audit-imports.py --dependencies
python tools/lean-apply-patches.py
```

All git dependencies were fetched by exact manifest commit without executing remote setup hooks. The project's Lake configuration and dependency Lake configurations were inspected before invoking Lake. The project `post_update` hook only applies nine supplied compatibility patches; the reproduction applies those same patch blobs explicitly and preserves the original root project configuration.

The first patch attempt failed with `corrupt patch ... formalpantheon-v4.33.0.patch:30` because this Windows Git installation has `core.autocrlf=true`. Extracting the exact LF patch bytes with `git show HEAD:src/latest/patches/<name>` and applying those unmodified blobs resolved the issue. Both the failure and successful applications are logged. No proof source repair was introduced.

The initial runtime download stalled and was resumed using `curl -C -`; the final complete ZIP passed the official SHA-256 check. Mathlib's cache hashing explicitly uses `contents.crlfToLf`, so cache source files were not normalized or changed.

```powershell
& './tools/lean-run.ps1' -LogName cache -LakeArgs @('exe','cache','get')
```

`tools/lean-run.ps1` sets only process-local PATH and workspace-local cache directories, records UTC timestamps and exit codes, and runs Lake in `reproduction/lean-proofs/src/latest`.

## Verification status

The pinned runtime and cache executable built successfully; all 8,690 pinned Mathlib cache artifacts downloaded and decompressed successfully (exit 0, finished 2026-10-30T04:07:39Z).

The targeted build started at 04:07:47Z and finished at 04:16:11Z, exit 0. Lake reported `Build completed successfully (9018 jobs).` This builds the custom proof closure from source against the pinned standard-library/Mathlib artifacts, rather than rebuilding Mathlib from source. The target module itself took 39 seconds. The full output is in `logs/reproduction-erdos771-build.log`.

```powershell
& './tools/lean-run.ps1' -LogName erdos771-build -LakeArgs @('build','+ErdosProblems.Erdos771:olean')
& './tools/lean-run.ps1' -LogName axiom-audit -LakeArgs @('env','lean','AxiomAudit.lean')
```

The separate axiom audit started at 04:16:37Z and finished at 04:17:02Z, exit 0. Its exact final output was:

```text
'Erdos771.erdosF_asymptotic' depends on axioms: [propext, Classical.choice, Quot.sound]
'Erdos771.erdos_771' depends on axioms: [propext, Classical.choice, Quot.sound]
```

The same audit printed the definitions and declaration types. `AdmissibleCard n k` quantifies `∀ m > 0, ∃ S ⊆ Finset.Icc 1 n` with `S.card = k` and `m ∉ S.subsetSum`; `erdosF n` is `Nat.findGreatest (AdmissibleCard n) n`. Both final declarations have the unconditional type

```text
Filter.Tendsto (fun n => ↑(Erdos771.erdosF n) / (↑n / Real.log ↑n))
  Filter.atTop (nhds (1 / 2))
```

The complete audit output is in `logs/reproduction-axiom-audit.log`. This confirms the formal theorem and its kernel assumptions for the pinned environment; it does not establish novelty or benchmark eligibility.

`AxiomAudit.lean` imports the public candidate, prints its relevant definitions and declaration types, and requests `#print axioms` for both final declarations. `StatementAudit.lean` is a separate small independent sanity check authored in this session; its asymptotic target is only a `def : Prop`, not a proof of that target.

The independent statement sanity check passed on the corrected source at 2026-10-30T04:09:54Z (exit 0). Its nine printed theorem audits all reported exactly `[propext, Classical.choice, Quot.sound]`, with no `sorryAx`. These include the subset-sum equivalence, two finite-host examples, the common-divisor obstruction, a construction of an avoiding set of size `n / q` whenever `q ∤ m`, cardinality bounds and downward closure, the maximum specification, and a quantifier-reversal sanity lemma. One nonblocking `unnecessarySimpa` style warning remains. This validates those elementary statements only; `ExactTarget : Prop` remains unproved in this independent file.

The initial statement-check run failed on two equality orientations and a renamed Mathlib identifier. Its failure log is retained in `logs/reproduction-statement-audit.log`, and the reconstructed failed source is clearly labeled in `research/experiments/StatementAudit.initial-failed.lean.txt`. The corrected successful log is `logs/reproduction-statement-audit-fixed.log`.

## Final provenance check

At 04:17:04Z, `git diff --exit-code HEAD` restricted to the target proof, Lake configuration, Lake manifest, and toolchain file returned exit 0. The checked target source's Git clean-filter blob hash exactly matched the pinned commit: `dfce72438c4182f8a234ef899a5b173538ab2358`. This comparison accounts for Windows checkout line endings without modifying the source.

Additional SHA-256 values, recorded in `logs/reproduction-final-provenance.log`:

- Checked CRLF working copy `Erdos771.lean`: `ad58725be7d9216fb46dd5b80b48a2246482d1744d23b00dc6ec86fcbc701540`.
- Built `ErdosProblems/Erdos771.olean`: `16c1f3272c98074c05b3c0386a5b841fbe45026285e3d92a4881bdc5a9a585fd`.
- Independent `AxiomAudit.lean`: `cddf7aaa054ab320e991c6fa39fd527559b1121e9829cda3416ace67d067ab0c`.

All failures, compatibility patch blobs, source checkouts, caches, runtime files, audit files, and successful outputs remain available in the workspace. The expected Lake warnings about locally changed external repositories refer to the pinned project's own nine compatibility patches.

## Additional literal-statement bridge

The parent audit subsequently ran `lake env lean FaithfulnessAudit.lean` (through `tools/lean-run.ps1`, log name `faithfulness-audit`), exit 0 at 04:17:08 UTC. It proves `originalPredicate_eq`, `originalF_eq`, and `original_statement_from_prior_proof`. All three printed axiom lists are `[propext, Classical.choice, Quot.sound]`. The wrapper explicitly cites the existing public `Erdos771.erdos_771`; it is not a new original proof. Full output is preserved in `logs/reproduction-faithfulness-audit.log`.
