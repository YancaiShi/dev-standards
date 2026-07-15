$ErrorActionPreference = "Stop"

$repoUrl = "https://github.com/YancaiShi/dev-standards.git"
$installDir = "$env:USERPROFILE\dev-standards"
$standardsDir = "$env:USERPROFILE\.claude\standards"
$claudeMd = "$env:USERPROFILE\.claude\CLAUDE.md"

Write-Host "📦 安装 dev-standards..." -ForegroundColor Cyan

# 1. 克隆或更新仓库
if (Test-Path "$installDir\.git") {
    Write-Host "✔ 仓库已存在，拉取最新..." -ForegroundColor Green
    Set-Location $installDir
    git pull -q
} else {
    git clone -q $repoUrl $installDir
    Write-Host "✔ 已克隆仓库到 $installDir" -ForegroundColor Green
}

# 2. 创建 junction（不需要管理员权限）
if (-not (Test-Path "$env:USERPROFILE\.claude")) {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude" | Out-Null
}

if (Test-Path $standardsDir) {
    $item = Get-Item $standardsDir -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        Write-Host "✔ junction 已存在，跳过" -ForegroundColor Green
    } else {
        Rename-Item $standardsDir "$standardsDir.bak"
        cmd.exe /c "mklink /J `"$standardsDir`" `"$installDir\standards`"" | Out-Null
        Write-Host "✔ 已创建 junction（原目录已备份）" -ForegroundColor Green
    }
} else {
    cmd.exe /c "mklink /J `"$standardsDir`" `"$installDir\standards`"" | Out-Null
    Write-Host "✔ 已创建 junction" -ForegroundColor Green
}

# 3. 配置 CLAUDE.md
$marker = "# 个人前端开发规范"
$reference = @"

$marker

前端开发规范，通过 Claude Code import(``@``)自动加载到上下文，会话启动即生效，无需手动读取。

@standards/engineering.md
@standards/code-style.md
@standards/error-handling.md
@standards/testing.md
@standards/component-design.md
@standards/commit-style.md
@standards/review.md
@standards/figma.md
@standards/i18n.md
"@

if ((Test-Path $claudeMd) -and (Select-String -Path $claudeMd -Pattern $marker -Quiet)) {
    Write-Host "✔ CLAUDE.md 已配置，跳过" -ForegroundColor Green
} else {
    Add-Content -Path $claudeMd -Value $reference
    Write-Host "✔ 已配置 CLAUDE.md" -ForegroundColor Green
}

# 4. 同步 Cursor User Rules（alwaysApply，跨项目稳定注入）
& "$installDir\scripts\sync-cursor-rules.ps1"

Write-Host ""
Write-Host "✅ 安装完成！重启 Claude Code / Cursor 即可生效。" -ForegroundColor Green
Write-Host "   Cursor：Settings → Rules, Commands → User Rules 可见 dev-standards-*" -ForegroundColor DarkGray
