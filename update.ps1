$ErrorActionPreference = "Stop"

$installDir = "$env:USERPROFILE\dev-standards"
$standardsDir = "$env:USERPROFILE\.claude\standards"

Write-Host "🔄 更新 dev-standards..." -ForegroundColor Cyan

# 1. 检查是否已安装
if (-not (Test-Path "$installDir\.git")) {
    Write-Host "✖ 未检测到安装，请先执行安装命令：" -ForegroundColor Red
    Write-Host "  irm https://raw.githubusercontent.com/YancaiShi/dev-standards/main/install.ps1 | iex" -ForegroundColor Yellow
    exit 1
}

# 2. 拉取最新（规范以远程为唯一源，强制对齐远程）
git -C $installDir fetch -q origin
git -C $installDir reset --hard -q origin/main
Write-Host "✔ 已更新到最新版本" -ForegroundColor Green

# 3. 确认链接
if (-not (Test-Path $standardsDir)) {
    Write-Host "⚠ 检测到 $standardsDir 不存在，建议重新执行安装脚本" -ForegroundColor Yellow
} else {
    Write-Host "✔ 链接正常，规范已同步到 ~/.claude/standards" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ 更新完成！重启 Claude Code 即可生效。" -ForegroundColor Green
