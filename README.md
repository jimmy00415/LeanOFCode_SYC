# JSP-000632 research audit

Start with [REPORT.md](REPORT.md). It distinguishes the original mathematical statement, the official catalogue wording, prior public work, and actual verification results.

Current decision: **GO for contribution submission and review**. The applicant asserts independent origination of a method, without claiming to be an author of the upstream repository; see the [clarification and current artifact scope](submission/APPLICANT_STATEMENT.md). The applicant selected [jimmy00415/LeanOFCode_SYC](https://github.com/jimmy00415/LeanOFCode_SYC) as the publication repository. See [submission status](submission/STATUS.md). A separate implementation of the independently claimed method is not yet supplied; official priority and eligibility remain subject to review.

Published evidence: [`2d587ad0493f3eb82e1fd77455a346081cb0188a`](https://github.com/jimmy00415/LeanOFCode_SYC/commit/2d587ad0493f3eb82e1fd77455a346081cb0188a). Official contribution review: [TheJustinSunPrize/awards#5508](https://github.com/TheJustinSunPrize/awards/pull/5508), opened on 30 October 2026 and now **ready for review**. The award claim follows the required contribution merge and review.

## Evidence

- [Mathematical architecture and library inventory](research/mathematical-audit.md)
- [Priority and eligibility audit](research/eligibility-audit.md)
- [Independent adversarial review](research/referee-audit.md)
- [Environment and build reproduction](research/lean-reproduction.md)
- [Independent elementary Lean experiment](lean/StatementAudit.lean)
- [Public-proof axiom audit](lean/AxiomAudit.lean)
- [Literal-statement bridge to the verified proof](lean/FaithfulnessAudit.lean)
- [Unmodified pinned main proof](https://github.com/plby/lean-proofs/blob/8822f7ddef30fadbd92e1c6ab4ed897af356af5e/src/latest/ErdosProblems/Erdos771.lean)
- [Submitted PR body](submission/PR_BODY.md) and [later claim draft](submission/CLAIM_DRAFT.md)

`logs/` preserves successful and failed commands. The local-only `sources/` and `research/eligibility/` directories preserve retrieved primary evidence and are excluded from Git. The failed initial elementary experiment is retained separately under `research/experiments/`; it is not an accepted proof. The complete proof project is linked as the `reproduction/lean-proofs` Git submodule at the verified commit. Its source history and credits are preserved. Runtime and caches are excluded; their exact pins and recreation steps are recorded in the reproduction report.

## Obtain the complete source

```powershell
git clone --recurse-submodules https://github.com/jimmy00415/LeanOFCode_SYC.git
Set-Location LeanOFCode_SYC
Copy-Item -LiteralPath lean/AxiomAudit.lean,lean/StatementAudit.lean,lean/FaithfulnessAudit.lean `
  -Destination reproduction/lean-proofs/src/latest/
```

The submodule is pinned to `plby/lean-proofs@8822f7ddef30fadbd92e1c6ab4ed897af356af5e`; the audit files are additional modules in this repository. Follow [environment setup](research/lean-reproduction.md) before running the commands below. The new publication repository records this verification work and does not by itself establish authorship of the pre-existing main proof.

## Recheck in the prepared Windows workspace

From this directory, run these PowerShell commands. The runner uses the local Lean 4.33.0 runtime and the pinned project; it does not require a global Elan installation.

```powershell
& './tools/lean-run.ps1' -LogName 'recheck-main' `
  -LakeArgs @('build','+ErdosProblems.Erdos771:olean')
& './tools/lean-run.ps1' -LogName 'recheck-axioms' `
  -LakeArgs @('env','lean','AxiomAudit.lean')
& './tools/lean-run.ps1' -LogName 'recheck-statement' `
  -LakeArgs @('env','lean','StatementAudit.lean')
& './tools/lean-run.ps1' -LogName 'recheck-faithfulness' `
  -LakeArgs @('env','lean','FaithfulnessAudit.lean')
```

Read the exit code and entire diagnostic output. A failed elaboration can still print declaration names and `sorryAx`; that is not successful verification. `JSP000632Audit.ExactTarget` is only a proposition definition. Any full result in `FaithfulnessAudit` is explicitly derived from the prior public proof and confers no new priority.

The pinned repository, original manifests and upstream compatibility patches remain available. Recreating the environment on another machine is documented in the reproduction report and helper scripts under `tools/`. Preserve the attribution and licenses of the third-party source.
