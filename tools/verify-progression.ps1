param()
$ErrorActionPreference = 'Stop'
$TaskRoot = Split-Path -Parent $PSScriptRoot
$TaskProject = Join-Path $TaskRoot 'reproduction/lean-proofs/src/latest'
$TaskRunner = Join-Path $PSScriptRoot 'lean-run.ps1'
$TaskOriginalLocation = Get-Location

function Invoke-ProgressionCheck {
  param([string]$Name, [string[]]$Arguments, [int]$ExpectedExit = 0)
  & $TaskRunner -LogName $Name -LakeArgs $Arguments
  $TaskActualExit = $LASTEXITCODE
  if ($TaskActualExit -ne $ExpectedExit) {
    throw "$Name exited $TaskActualExit; expected $ExpectedExit"
  }
}

try {
  $TaskBuildDir = Join-Path $TaskProject '.lake/build/lib/lean'
  if (-not (Test-Path -LiteralPath $TaskBuildDir)) {
    throw 'Prepare the pinned environment and build ErdosProblems.Erdos771 first; see research/lean-reproduction.md.'
  }
  foreach ($TaskModule in @('ProgressionUpperBound', 'ProofDependencyAudit',
      'ProgressionDependencyAudit', 'DependencyAuditNegative')) {
    Copy-Item -LiteralPath (Join-Path $TaskRoot "lean/$TaskModule.lean") -Destination $TaskProject
  }
  Invoke-ProgressionCheck -Name 'progression-proof' -Arguments @(
    'env', 'lean', '-o', '.lake/build/lib/lean/ProgressionUpperBound.olean', 'ProgressionUpperBound.lean')
  Invoke-ProgressionCheck -Name 'progression-audit-tool' -Arguments @(
    'env', 'lean', '-o', '.lake/build/lib/lean/ProofDependencyAudit.olean', 'ProofDependencyAudit.lean')
  Invoke-ProgressionCheck -Name 'progression-dependency-check' -Arguments @(
    'env', 'lean', 'ProgressionDependencyAudit.lean')
  Invoke-ProgressionCheck -Name 'progression-negative-control' -ExpectedExit 1 -Arguments @(
    'env', 'lean', 'DependencyAuditNegative.lean')
  $TaskNegativeLog = Join-Path $TaskRoot 'logs/reproduction-progression-negative-control.log'
  if (-not (Select-String -LiteralPath $TaskNegativeLog -SimpleMatch 'Forbidden original target-proof dependencies:' -Quiet)) {
    throw 'Negative control failed for an unexpected reason.'
  }
  Write-Output 'VERIFIED: complete progression proof, transitive dependency audit, and expected negative control.'
} finally {
  Set-Location -LiteralPath $TaskOriginalLocation.Path
}
