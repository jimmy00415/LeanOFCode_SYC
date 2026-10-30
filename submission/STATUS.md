# JSP-000632 submission status

Decision: **GO for contribution submission and source-attribution review.**

The applicant has stated that they are the original contributor and authorized commit, push and award-application work. The complete interval theorem, supporting statement equivalence and axiom audit have passed. This document does not independently certify the applicant's authorship or first priority.

## Verified facts

- Logged-in account: `jimmy00415` (GitHub connector and GitHub CLI agree).
- Verified complete source: `plby/lean-proofs`, commit `8822f7ddef30fadbd92e1c6ab4ed897af356af5e`, project `src/latest`.
- Exact declaration: `Erdos771.erdos_771`.
- Final axiom list: `[propext, Classical.choice, Quot.sound]`.
- The authenticated account has no push permission to `plby/lean-proofs`.
- The workspace root originally had no Git repository or push remote. The applicant subsequently selected `https://github.com/jimmy00415/LeanOFCode_SYC`, branch `main`, and explicitly authorized commit, push, and a PR to the official awards repository.
- The publication repository includes the full verified proof as a pinned Git submodule, retaining its upstream history and source credits, plus the new audit modules, reports and build evidence.
- No matching JSP-000632 PR by `jimmy00415` existed in the pre-submission search. This application now has the draft PR linked below.

## Attribution to be reviewed

The applicant identifies the local proof and `jimmy00415/LeanOFCode_SYC` as their work. This session obtained the unchanged main proof from the earlier public `plby/lean-proofs` commit; its header credits Codex and GPT-5.6 Sol. The relationship between the applicant and that earlier formalization remains for maintainer review. The new repository and its publication date are evidence for this audit bundle, not independent evidence of the earlier proof's authorship or first priority. No adverse conclusion about authorship is inferred merely from the different account name.

## Official process

JSP-000632 is outside the current MathDB pilot. The legacy process requires a complete Lean contribution with mathematical solution references and attribution evidence. Its contribution PR must merge before the Lean award claim is accepted. A pending PR is insufficient. Applicant identity verification is a separate email step.

Sources: [contribution guide](https://github.com/TheJustinSunPrize/awards/blob/main/CONTRIBUTING.md), [award process](https://github.com/TheJustinSunPrize/awards/blob/main/docs/award-process.md), [attribution requirements](https://github.com/TheJustinSunPrize/awards/blob/main/docs/attribution.md).

## Published submission

- Evidence repository: [jimmy00415/LeanOFCode_SYC](https://github.com/jimmy00415/LeanOFCode_SYC), branch `main`.
- Evidence commit cited by the PR: [`2d587ad0493f3eb82e1fd77455a346081cb0188a`](https://github.com/jimmy00415/LeanOFCode_SYC/commit/2d587ad0493f3eb82e1fd77455a346081cb0188a); push verified against the remote branch.
- Official PR: [TheJustinSunPrize/awards#5508](https://github.com/TheJustinSunPrize/awards/pull/5508), **open draft**, created 30 October 2026.
- PR source: `jimmy00415/awards:jsp-000632-verification`; head `0cfcb529af68778ffefe49e3da5bf89b6adf0351`; target `TheJustinSunPrize/awards:main`.
- Verified PR diff: only `problems/catalog-0601-0700.md`, two added lines and one removed line, confined to JSP-000632's Lean proof and attribution evidence.
- Final pre-push incremental target build, axiom audit and faithfulness check all exited 0; see `logs/reproduction-submission-recheck-*.log`. The unchanged source pin and audit-file equality were also checked.

The later award claim remains a local draft pending statement/attribution review and the required contribution merge. No claim issue or identity-verification email has been submitted. Original source credits are preserved. The draft PR records the applicant's assertion without claiming that original-source attribution or first priority has already been adjudicated.
