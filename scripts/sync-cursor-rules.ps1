# Sync standards/*.md -> ~/.cursor/rules/dev-standards-*.mdc (alwaysApply)
# Chinese metadata lives in cursor-rules-manifest.json (UTF-8) to avoid PS encoding issues.
$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$StandardsDir = Join-Path $RepoRoot "standards"
$CursorRulesDir = Join-Path $env:USERPROFILE ".cursor\rules"
$ManifestPath = Join-Path $PSScriptRoot "cursor-rules-manifest.json"

if (-not (Test-Path $StandardsDir)) {
    Write-Host "Missing standards dir: $StandardsDir" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $ManifestPath)) {
    Write-Host "Missing manifest: $ManifestPath" -ForegroundColor Red
    exit 1
}

$Rules = Get-Content -Path $ManifestPath -Encoding UTF8 -Raw | ConvertFrom-Json

if (-not (Test-Path $CursorRulesDir)) {
    New-Item -ItemType Directory -Path $CursorRulesDir -Force | Out-Null
}

Get-ChildItem -Path $CursorRulesDir -Filter "dev-standards-*.mdc" -ErrorAction SilentlyContinue |
    Remove-Item -Force

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
foreach ($rule in $Rules) {
    $src = Join-Path $StandardsDir $rule.file
    if (-not (Test-Path $src)) {
        Write-Host "Skip missing: $($rule.file)" -ForegroundColor Yellow
        continue
    }
    $body = [System.IO.File]::ReadAllText($src, $utf8NoBom).TrimEnd()
    $mdc = "---`ndescription: $($rule.desc)`nalwaysApply: true`n---`n`n$body`n"
    $dest = Join-Path $CursorRulesDir $rule.name
    [System.IO.File]::WriteAllText($dest, $mdc, $utf8NoBom)
}

Write-Host "Synced Cursor Rules -> $CursorRulesDir (dev-standards-*.mdc)" -ForegroundColor Green
