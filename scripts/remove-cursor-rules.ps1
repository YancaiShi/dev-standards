# Remove ~/.cursor/rules/dev-standards-*.mdc
$ErrorActionPreference = "Stop"

$CursorRulesDir = Join-Path $env:USERPROFILE ".cursor\rules"

if (-not (Test-Path $CursorRulesDir)) {
    Write-Host "No Cursor Rules dir, skip" -ForegroundColor Green
    exit 0
}

$removed = @(Get-ChildItem -Path $CursorRulesDir -Filter "dev-standards-*.mdc" -ErrorAction SilentlyContinue)
if ($removed.Count -eq 0) {
    Write-Host "No dev-standards-*.mdc found, skip" -ForegroundColor Green
    exit 0
}

$removed | Remove-Item -Force
Write-Host "Removed Cursor Rules ($($removed.Count) x dev-standards-*.mdc)" -ForegroundColor Green
