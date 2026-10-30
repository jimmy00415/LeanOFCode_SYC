# JSP-000632 submission status

The local work now includes a complete LCM-cutoff proof assembly and its executable verification. The submitted target is `JSP000632Progression.erdosF_asymptotic_via_progression` in `lean/ProgressionUpperBound.lean`.

- Publication repository: [jimmy00415/LeanOFCode_SYC](https://github.com/jimmy00415/LeanOFCode_SYC), branch `main`.
- Official submission: [TheJustinSunPrize/awards#5508](https://github.com/TheJustinSunPrize/awards/pull/5508), open for review.
- Local work: [process, results and conclusion](../REPORT.md), [Chinese derivation](../METHOD.zh-CN.md), [source and checks](../research/progression-reproduction.md).
- Contributor: Jimmy (`jimmy00415`) with Codex; [contribution statement](APPLICANT_STATEMENT.md).
- Fresh verification: 30 October 2026, 13:06–13:07 HKT; proof, audit-tool and transitive-check exits 0, expected negative-control exit 1, overall runner exit 0.
- Final theorem assumptions: `[propext, Classical.choice, Quot.sound]`.

The PR now cites the complete local implementation at evidence commit [`b556e9bc6f16fe86b4dc4de3b2f4b0cc8e1719f0`](https://github.com/jimmy00415/LeanOFCode_SYC/commit/b556e9bc6f16fe86b4dc4de3b2f4b0cc8e1719f0). Its title is **JSP-000632: submit LCM-cutoff proof, derivation and verification**. The verified awards-fork head is `9c616ea5e9557d71c8371713a00821df3bcfb269`; the diff contains only the two relevant catalog rows. GitHub reports `OPEN`, ready for review, `REVIEW_REQUIRED`. The exact statement concerns subsets of `{1,...,n}`; correspondence with the catalog's shorter arbitrary-host description remains for maintainer review. Acceptance and merge are pending.

The later Lean award claim is prepared in [CLAIM_DRAFT.md](CLAIM_DRAFT.md). The [official process](https://github.com/TheJustinSunPrize/awards/blob/main/docs/award-process.md) requires the contribution PR to merge before that claim can be accepted. No claim issue or identity-verification email has been submitted.
