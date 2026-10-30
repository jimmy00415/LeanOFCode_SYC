param(
  [Parameter(Mandatory=$true)][string]$LogName,
  [Parameter(ValueFromRemainingArguments=$true)][string[]]$LakeArgs
)
$ErrorActionPreference = 'Stop'
$TaskRoot = Split-Path -Parent $PSScriptRoot
$LeanBin = Join-Path $TaskRoot 'tools/lean-4.33.0-windows/bin'
$Project = Join-Path $TaskRoot 'reproduction/lean-proofs/src/latest'
$env:PATH = $LeanBin + ';' + $env:PATH
$env:MATHLIB_CACHE_DIR = Join-Path $TaskRoot 'reproduction/mathlib-cache'
$env:MATHLIB_NO_CACHE_ON_UPDATE = '1'
$env:LAKE_CACHE_DIR = Join-Path $TaskRoot 'reproduction/lake-cache'
Set-Location -LiteralPath $Project
$LogPath = Join-Path $TaskRoot ('logs/reproduction-' + $LogName + '.log')
& {
  Write-Output ('Started UTC: ' + [DateTime]::UtcNow.ToString('o'))
  Write-Output ('Working directory: ' + $Project)
  Write-Output ('Command: ' + (Join-Path $LeanBin 'lake.exe') + ' ' + ($LakeArgs -join ' '))
  & (Join-Path $LeanBin 'lake.exe') @LakeArgs 2>&1
  $BuildExit = $LASTEXITCODE
  Write-Output ('Exit code: ' + $BuildExit)
  Write-Output ('Finished UTC: ' + [DateTime]::UtcNow.ToString('o'))
  $script:ResultExit = $BuildExit
} | Tee-Object -FilePath $LogPath
exit $script:ResultExit
