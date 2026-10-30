# Reproducing the local cutoff proof

This guide prepares the pinned Windows environment and checks the local theorem `JSP000632Progression.erdosF_asymptotic_via_progression`. Its source is [ProgressionUpperBound.lean](../lean/ProgressionUpperBound.lean); the mathematical derivation is in [method-note.md](method-note.md).

## Environment and pins

Use Windows x86-64, PowerShell 7, Git, and Python 3 available as `python`. The commands download the Lean runtime and dependency caches into the checkout; no global Elan installation is needed. Run the blocks in order in the same PowerShell session. Start in a directory without an existing `LeanOFCode_SYC` child directory.

| Input | Pinned value |
|---|---|
| Lean | `leanprover/lean4:v4.33.0` |
| Library submodule | `plby/lean-proofs@8822f7ddef30fadbd92e1c6ab4ed897af356af5e` |
| Mathlib | `db584cd6d46c92f209a44c0f1c829460d327499d` |
| BoundedGaps / FormalPantheon | `ffbb65c21afc8a36ace67720f1b0df1c63d26bd1` |
| Windows runtime ZIP SHA-256 | `301edc4cf03571c839cd7bf73ec850921f36d9451dbec68da557969a845726d9` |

The complete dependency revisions are in the submodule's `src/latest/lake-manifest.json`. The library source, source history, headers, and supplied compatibility patches remain in the pinned submodule; preserve their credits and licenses.

## Select the publication revision

Replace `SELECTED_COMMIT` with the full commit ID of the publication revision containing this guide and `lean/ProgressionUpperBound.lean`. Check out that revision before initializing the submodule so Git uses its recorded pin.

```powershell
$ErrorActionPreference = 'Stop'
# The runner checks native exit codes explicitly, including its negative control.
$PSNativeCommandUseErrorActionPreference = $false
$TaskSelectedCommit = 'SELECTED_COMMIT'

git clone https://github.com/jimmy00415/LeanOFCode_SYC.git LeanOFCode_SYC
if ($LASTEXITCODE -ne 0) { throw 'Publication clone failed.' }
Set-Location -LiteralPath './LeanOFCode_SYC'
git checkout --detach $TaskSelectedCommit
if ($LASTEXITCODE -ne 0) { throw 'Selected publication revision is unavailable.' }

$TaskRoot = (Get-Location).Path
git submodule update --init -- reproduction/lean-proofs
if ($LASTEXITCODE -ne 0) { throw 'Library submodule initialization failed.' }

$TaskSourceRepo = Join-Path $TaskRoot 'reproduction/lean-proofs'
$TaskProject = Join-Path $TaskSourceRepo 'src/latest'
$TaskSourceRevision = git -C $TaskSourceRepo rev-parse HEAD
if ($LASTEXITCODE -ne 0 -or
    $TaskSourceRevision -ne '8822f7ddef30fadbd92e1c6ab4ed897af356af5e') {
  throw 'Library submodule does not match the required pin.'
}
$TaskToolchain = (Get-Content -LiteralPath (Join-Path $TaskProject 'lean-toolchain') -Raw).Trim()
if ($TaskToolchain -ne 'leanprover/lean4:v4.33.0') {
  throw 'Unexpected Lean toolchain.'
}
```

## Download and verify the runtime

The ZIP is the [Lean 4.33.0 Windows release asset](https://github.com/leanprover/lean4/releases/download/v4.33.0/lean-4.33.0-windows.zip). The recorded hash was checked against the release asset digest during environment preparation. This block verifies the downloaded bytes before extraction.

```powershell
$TaskDownloadDir = Join-Path $TaskRoot 'tools/lean-download'
New-Item -ItemType Directory -Path $TaskDownloadDir -Force | Out-Null
$TaskRuntimeZip = Join-Path $TaskDownloadDir 'lean-4.33.0-windows.zip'
Invoke-WebRequest `
  -Uri 'https://github.com/leanprover/lean4/releases/download/v4.33.0/lean-4.33.0-windows.zip' `
  -OutFile $TaskRuntimeZip
$TaskRuntimeHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $TaskRuntimeZip).Hash.ToLowerInvariant()
if ($TaskRuntimeHash -ne '301edc4cf03571c839cd7bf73ec850921f36d9451dbec68da557969a845726d9') {
  throw 'Lean runtime checksum mismatch.'
}
Expand-Archive -LiteralPath $TaskRuntimeZip -DestinationPath (Join-Path $TaskRoot 'tools')
& (Join-Path $TaskRoot 'tools/lean-4.33.0-windows/bin/lean.exe') --version
if ($LASTEXITCODE -ne 0) { throw 'Lean runtime did not start.' }
```

The runtime should report Lean 4.33.0, commit `d8b18978322de05a8f3dba51ef03cf5461676c17`.

## Fetch exact dependencies and apply the supplied patches

This block is for a fresh checkout only. `lean-fetch-dependencies.py` creates remotes and checks out manifest commits; it is not a resumable installer. It also reports individual fetch errors without setting a failing process exit code, so the explicit revision loop below is required. If fetching fails, inspect `logs/reproduction-fetch-*.log` and resolve that failed checkout before continuing.

```powershell
$TaskPackages = Join-Path $TaskProject '.lake/packages'
if (Test-Path -LiteralPath $TaskPackages) {
  throw 'Dependency fetching requires a fresh .lake/packages directory.'
}
python (Join-Path $TaskRoot 'tools/lean-fetch-dependencies.py')
if ($LASTEXITCODE -ne 0) { throw 'Dependency fetch helper failed.' }

$TaskManifest = Get-Content -LiteralPath (Join-Path $TaskProject 'lake-manifest.json') -Raw |
  ConvertFrom-Json
foreach ($TaskPackage in $TaskManifest.packages) {
  if ($TaskPackage.type -ne 'git') { continue }
  $TaskPackagePath = Join-Path $TaskPackages $TaskPackage.name
  $TaskPackageRevision = git -C $TaskPackagePath rev-parse HEAD
  if ($LASTEXITCODE -ne 0 -or $TaskPackageRevision -ne $TaskPackage.rev) {
    throw "Dependency pin check failed: $($TaskPackage.name)"
  }
}

python (Join-Path $TaskRoot 'tools/lean-apply-patches.py')
if ($LASTEXITCODE -ne 0) { throw 'Compatibility patch application failed.' }
```

Apply the patch helper once. It extracts the nine supplied patch blobs with `git show` and applies their exact LF bytes, avoiding Windows checkout line-ending conversion. The patched package working trees intentionally differ from their pinned commits. Lake warnings naming local changes in Waring, BoundedGaps, AINTLIB, and leancert are expected for this setup.

## Build the imported library and verify the local modules

`lean-run.ps1` records timestamps, commands, output, and exit codes in `logs/`. It also changes the calling session's current directory. The following block therefore invokes it through an absolute path and restores the repository directory afterward.

```powershell
$TaskRunner = Join-Path $TaskRoot 'tools/lean-run.ps1'
try {
  & $TaskRunner -LogName 'cache' -LakeArgs @('exe', 'cache', 'get')
  if ($LASTEXITCODE -ne 0) { throw 'Mathlib cache retrieval failed.' }

  & $TaskRunner -LogName 'erdos771-build' `
    -LakeArgs @('build', '+ErdosProblems.Erdos771:olean')
  if ($LASTEXITCODE -ne 0) { throw 'Imported library build failed.' }
} finally {
  Set-Location -LiteralPath $TaskRoot
}

& (Join-Path $TaskRoot 'tools/verify-progression.ps1')
```

The verifier copies `ProgressionUpperBound.lean`, `ProofDependencyAudit.lean`, `ProgressionDependencyAudit.lean`, and `DependencyAuditNegative.lean` from `lean/` into the prepared project. It rebuilds the local proof and audit tool, checks transitive dependencies and axioms, and requires the negative control to fail with the configured dependency diagnostic. A successful run ends with:

```text
VERIFIED: complete progression proof, transitive dependency audit, and expected negative control.
```

The negative control intentionally exits 1. The verifier checks that status internally; it is part of a successful verification run. In an already prepared checkout, rerun only this verifier to refresh the local proof checks. The verifier checks for a build directory, but does not itself validate dependency pins; retain the setup checks above.

## Recorded local verification

The fresh verifier run on **30 October 2026, 05:06:27–05:07:40 UTC**, returned process exit **0**. Its four child commands used `lake.exe` from the verified runtime, with working directory `reproduction/lean-proofs/src/latest`:

| Lake arguments | Exit | Retained log |
|---|---:|---|
| `env lean -o .lake/build/lib/lean/ProgressionUpperBound.olean ProgressionUpperBound.lean` | 0 | [proof](../logs/reproduction-progression-proof.log) |
| `env lean -o .lake/build/lib/lean/ProofDependencyAudit.olean ProofDependencyAudit.lean` | 0 | [audit tool](../logs/reproduction-progression-audit-tool.log) |
| `env lean ProgressionDependencyAudit.lean` | 0 | [dependency check](../logs/reproduction-progression-dependency-check.log) |
| `env lean DependencyAuditNegative.lean` | 1, expected | [negative control](../logs/reproduction-progression-negative-control.log) |

All ten printed local theorem axiom audits reported exactly `[propext, Classical.choice, Quot.sound]`, including the complete limit. No `sorryAx` appeared. The dependency audit traversed **72,948 constants** and logged **285 declarations in the `Erdos771` namespace**, including generated helper declarations. It follows declaration types and bodies, including opaque theorem bodies, and fails on a missing constant or an occurrence of any declaration in its configured exclusion list. The negative control reached the expected exclusion diagnostic. The list and its implementation are in [ProofDependencyAudit.lean](../lean/ProofDependencyAudit.lean).

This run rebuilt the four local modules against the prepared library artifacts; it did not rebuild the full dependency environment from an empty checkout. The earlier targeted source build completed successfully on 30 October 2026 at 04:16:11 UTC, reporting 9,018 jobs against the pinned Mathlib cache ([build log](../logs/reproduction-erdos771-build.log)). The fresh-checkout sequence above documents how to prepare those prerequisites; it has not been rerun end to end in a second clean checkout.

The result certifies the stated Lean limit and the reported axiom/dependency checks in this environment. It retains the substantial library lemmas for uniform representation, prime-number asymptotics, and the lower bound. Counts in the dependency audit are declaration counts, not counts of independent mathematical results or source modules. Runtime files and caches are excluded from Git; the source pins, scripts, and verification logs are retained.
