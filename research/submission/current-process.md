# Current submission process — JSP-000632

Refreshed **2026-10-30 04:25 UTC**, read-only, through the GitHub connector. Official main: **`fbaf42fcf8cfc036e00e9ae58a367155e8283e5a`**. The requested work can proceed as **GO for contribution submission preparation and review**, without changing the historical proof/build findings or declaring an award approved.

The user now asserts that they are the original/first Lean contributor. This is material new information: earlier third-party catalog registrations do not automatically defeat the actual author's application. This memo does not infer that the user is `plby`, Boris Alexeev, or any other GitHub identity. The coordinating agent is checking the account-to-contribution evidence.

## Route and exact permitted diff

JSP-000632 is absent from the 50-problem [MathDB pilot register](https://github.com/TheJustinSunPrize/awards/blob/fbaf42fcf8cfc036e00e9ae58a367155e8283e5a/problems/mathdb-pilot.md), so the **legacy contribution PR → maintainer review/merge → claim** route applies.

The current [contribution guide](https://github.com/TheJustinSunPrize/awards/blob/fbaf42fcf8cfc036e00e9ae58a367155e8283e5a/CONTRIBUTING.md#external-solver-and-lean-submissions) permits external changes to these fields in the existing `problems/catalog-0601-0700.md` entry:

- **Current status**, including supported **Proof contributors** attribution.
- **Lean proof**.
- **Attribution basis**.
- **Publication details**.

For this Lean-formalizer registration, the minimal justified diff is **Lean proof** plus an evidence-backed **Attribution basis** row. Keep the mathematical status `Solved`. The paper citation can be linked or clarified in **Publication details** if useful; the PR must cite the complete prior mathematical solution regardless.

Do not self-update **Eligible to claim**, the problem index, either claim-status column, candidate records, award records, reward amount, or review dates. Maintainers reconcile these after review. Other catalog corrections, including a proposed rewrite of the arbitrary-host wording, use a correction issue; the PR body can and should disclose the statement correspondence issue now.

The catalog proposal can use this shape only after replacing every placeholder with supported facts:

```markdown
| Lean proof | Yes — [Lean source](PINNED_ORIGINAL_PROOF_URL)<br>Formalization contributors: EVIDENCE_SUPPORTED_NAMES. |
| Attribution basis | The formalization proves the Erdős #771 interval subset-sum avoidance asymptotic. Mathematical source: Alon–Freiman (1988), Theorem 1.2 and the p.298 consequence, together with the Erdős–Graham lower bound. [Statement/source](SOURCE_LINK) [Contribution evidence](AUTHORSHIP_LINK). |
```

This is a **proposed catalog edit**, subject to the PR's explicit review status; it does not declare maintainer acceptance. Preserve the source's existing co-contributor and AI-tool credit. If the user claims credit not named in the source header, explain the linkage with public evidence rather than silently replacing the attribution.

## Contribution PR: materials required now

Use the current [PR template](https://github.com/TheJustinSunPrize/awards/blob/fbaf42fcf8cfc036e00e9ae58a367155e8283e5a/.github/PULL_REQUEST_TEMPLATE.md). Select **Lean proof or formalization author information**. Do not claim the historical mathematical-solver role merely because this is a new Lean submission.

The package must include:

1. **Mathematical source:** Alon–Freiman, *On sums of subsets of a set of integers*, Combinatorica 8 (1988), 297–306; Theorem 1.2 on p.298 and its #771 asymptotic consequence, combined with Erdős–Graham's lower bound. Link the primary PDF and exact #771 source. State mathematical review as pending unless an actual maintainer decision exists.
2. **Exact formal statement:** positive target m, a target-dependent subset of `{1,…,n}`, exact cardinality maximum, normalized limit 1/2; file and fully qualified target name. Explain that the official catalog's short arbitrary-host phrasing is broader than this precise cited problem. The template expressly allows a **proposed statement requiring review**.
3. **Original source provenance:** original public repository, actual branch, full 40-character selected commit SHA, exact proof file/entry theorem. The selected commit must belong to the named branch. A new mirror or copied proof repository is not an original contribution source.
4. **Account-to-author evidence:** public attributable commits, merged development PRs, original authorship records, or maintainer confirmations linking the applicant to the exact proof contribution. Organization membership, access, ownership, last-committer status, and a user-controlled Git author name alone are insufficient under the [attribution policy](https://github.com/TheJustinSunPrize/awards/blob/fbaf42fcf8cfc036e00e9ae58a367155e8283e5a/docs/attribution.md#lean-contributor-verification). Explain bot/shared-account or AI-name credit explicitly.
5. **Reproduction:** Lean version/toolchain path, exact dependency commits/manifest, correct project directory, setup and clean-build commands, target checks, and actual axiom command/output for each checked target. Distinguish observed outputs from procedures not yet run.
6. **Priority:** identify the claimed first complete source version and corroborating public history; link related official PRs. PR opening time alone does not determine priority.
7. **Scope of verification:** optional self-check report with actual date, checked pin, completed levels and limitations. The optional nature of a self-check does not permit a knowingly incomplete proof or a false complete-proof checkbox.

Only references and catalog text belong in the awards PR. Keep Lean sources, proof/build files, vendored dependencies, binaries and full logs in the external proof/evidence repository. Local verification reports may be published there in a later evidence commit while clearly identifying the earlier proof commit they actually check.

If the authenticated user already owns one of the pending submissions for the same contribution, update that PR instead of duplicating it. If the matched PRs are third-party registrations and the user is the actual source author, submit the author's own contribution and explain the distinction, linking that history. Do not adopt another submitter's authorship or priority narrative.

## What follows only after maintainer merge

The [legacy claim form](https://github.com/TheJustinSunPrize/awards/blob/fbaf42fcf8cfc036e00e9ae58a367155e8283e5a/.github/ISSUE_TEMPLATE/claim-award.yml) explicitly requires a **merged contribution PR for the Lean role**. The recorded-solver exception applies only to mathematical-solver claims; it does not waive this for formalizers.

A pending PR or proof repository URL is not a substitute. The [process guide](https://github.com/TheJustinSunPrize/awards/blob/fbaf42fcf8cfc036e00e9ae58a367155e8283e5a/docs/award-process.md#open-a-claim-award-issue) says an early claim must be marked as not meeting that prerequisite and acceptance deferred until merge. Therefore:

- **Now:** prepare the full contribution PR and a truthful, ready-to-complete claim draft. Submission of the contribution can advance immediately once source and contribution facts are filled.
- **After maintainer merge:** submit or update `[Award claim] JSP-000632` from the contributor's own account, linking that merged PR and choosing **Lean formalization**.
- Do not tick the claim declaration saying a merged contribution PR is linked while it remains pending. An early issue, if explicitly pursued, must say it is premature and cannot yet be accepted; it does not start public review or establish eligibility.

The claim form needs:

| Field | Required content |
| --- | --- |
| Problem link | Official JSP-000632 catalog anchor |
| Merged submission PR | Accepted PR recording this contributor's Lean work |
| Contribution being claimed | Lean formalization |
| Original Lean proof repository | Original accepted source, with contribution evidence if needed |
| Follow-up contact email | A public correspondence address intentionally designated by the applicant |
| Identity verification method | Optional public method-only note; required identity material goes by email |
| Contribution evidence / attribution clarification | Link existing evidence; explain source/account/bot/name mismatches |
| Related claims and conflicts | Relevant prior submissions, co-contributors, disputes; distinguish unrelated partial attempts |

All applicants subsequently send identity-verification email **from the follow-up address in the issue** to `thejustinsunprize@hejustinsun.com`, linking the issue and merged PR. Private identity, payment-network/address and medal-delivery information stay out of public GitHub. Written recipient confirmation remains required.

Maintainers publish the candidate and actual UTC notice start. The separate **14-day public-review clock starts at candidate publication**, not at source commit, PR opening, build completion, claim opening, or merge. Relevant unresolved PR reviews, attribution/priority disputes and identity issues must be resolved. Maintainers then confirm the recipient and announce an award; payment is a later factual state.

## Refreshed competing-PR state

All eight exact-ID matches are still **unmerged**. An exact-ID issue search found no claim issue. These observations do not adjudicate whether the user is the first contributor.

| PR | Submitter | State at refresh | Current head |
| --- | --- | --- | --- |
| [#5357](https://github.com/TheJustinSunPrize/awards/pull/5357) | dcdreamy-code | open; unmerged | `36ffcce017708ed110d3ee1eef0cc5a83c9558e1` |
| [#1050](https://github.com/TheJustinSunPrize/awards/pull/1050) | xiahongchi | open; unmerged | `1ffe5f2803e33fa8629cb42fc690f2a0021c8e55` |
| [#1669](https://github.com/TheJustinSunPrize/awards/pull/1669) | xinkuangsi-spec | open; unmerged | `a1ad517b6342637207966fde400de2de8f39e861` |
| [#4573](https://github.com/TheJustinSunPrize/awards/pull/4573) | qzxuwenlong | open; unmerged | `cb60744d2c1b52b1b13d2c359e40fef6fafe0b9c` |
| [#4049](https://github.com/TheJustinSunPrize/awards/pull/4049) | dcdreamy-code | closed; unmerged | `183eb074d400952a2758975abd79f5312f68bbf5` |
| [#2854](https://github.com/TheJustinSunPrize/awards/pull/2854) | dcdreamy-code | closed; unmerged | `2df68917d738567b692e98d924647cdc58197fcd` |
| [#1854](https://github.com/TheJustinSunPrize/awards/pull/1854) | dcdreamy-code | closed; unmerged | `a6113e8770cc4d7e920195f02c1e45f9985c9749` |
| [#1146](https://github.com/TheJustinSunPrize/awards/pull/1146) | zjukop3 | closed; unmerged | `b23d5abe4dd46c204f6cb85c7c8517b0d001f388` |

The three still-open full-source catalog registrations #1050, #1669 and #5357 cite the same `plby/lean-proofs` pin and disclaim original authorship. #4049 was closed administratively. #1146 was rejected as another contributor's registration. #1854, #2854 and #4573 are scoped/trivial artifacts, not rival full asymptotic proofs. Existing audit evidence documents these distinctions.

For the source previously inspected, `Erdos771.erdos_771` is at:

[plby/lean-proofs, commit 8822f7ddef30fadbd92e1c6ab4ed897af356af5e, Erdos771.lean#L4547](https://github.com/plby/lean-proofs/blob/8822f7ddef30fadbd92e1c6ab4ed897af356af5e/src/latest/ErdosProblems/Erdos771.lean#L4547).

That is an inspected artifact reference, **not an inference that the current user owns or authored it**. If the original contribution is in a different repository/version, use that actual source and connect its history to the collected copy.

## Snapshot files

Unmodified current-source snapshots are saved in `research/submission/templates/`:

- `CONTRIBUTING.md`
- `PULL_REQUEST_TEMPLATE.md`
- `claim-award.yml`
- `award-process.md`
- `attribution.md`
- `mathdb-pilot.md`

No external messages, PRs, claims, commits or pushes were made by this subagent.
