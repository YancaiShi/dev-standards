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

> 详细规范文档位于 ``~/.claude/standards/``，需要时读取。

## 工程决策约束
详见 ``~/.claude/standards/engineering.md``

## 代码风格
详见 ``~/.claude/standards/code-style.md``

## Git 提交规范
详见 ``~/.claude/standards/commit-style.md``

## 国际化（i18n）
详见 ``~/.claude/standards/i18n.md``

## Figma 还原规则
详见 ``~/.claude/standards/figma.md``

## Code Review
详见 ``~/.claude/standards/review.md``
"@

if ((Test-Path $claudeMd) -and (Select-String -Path $claudeMd -Pattern $marker -Quiet)) {
    Write-Host "✔ CLAUDE.md 已配置，跳过" -ForegroundColor Green
} else {
    Add-Content -Path $claudeMd -Value $reference
    Write-Host "✔ 已配置 CLAUDE.md" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ 安装完成！重启 Claude Code 即可生效。" -ForegroundColor Green
