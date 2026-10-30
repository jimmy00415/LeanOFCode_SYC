# JSP-000632 research audit

Start with [REPORT.md](REPORT.md). It distinguishes the original mathematical statement, the official catalogue wording, prior public work, and actual verification results.

Current decision: **GO for submission preparation and attribution verification**, following the applicant's statement that they are the original contributor. See [submission status](submission/STATUS.md). The applicant's original source/commit and push destination remain to be linked; the drafts do not claim official priority or eligibility.

## Evidence

- [Mathematical architecture and library inventory](research/mathematical-audit.md)
- [Priority and eligibility audit](research/eligibility-audit.md)
- [Independent adversarial review](research/referee-audit.md)
- [Environment and build reproduction](research/lean-reproduction.md)
- [Independent elementary Lean experiment](lean/StatementAudit.lean)
- [Public-proof axiom audit](lean/AxiomAudit.lean)
- [Literal-statement bridge to the verified proof](lean/FaithfulnessAudit.lean)
- [Unmodified pinned main proof](https://github.com/plby/lean-proofs/blob/8822f7ddef30fadbd92e1c6ab4ed897af356af5e/src/latest/ErdosProblems/Erdos771.lean)
- [Contribution PR draft](submission/PR_BODY.md) and [later claim draft](submission/CLAIM_DRAFT.md)

`logs/` preserves successful and failed commands. The local-only `sources/` and `research/eligibility/` directories preserve retrieved primary evidence and are excluded from Git. The failed initial elementary experiment is retained separately under `research/experiments/`; it is not an accepted proof. The runtime, caches and full external proof clone are also excluded from this audit repository; their exact pins and recreation steps are recorded in the reproduction report.

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
