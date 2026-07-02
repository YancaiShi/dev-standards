$ErrorActionPreference = "Stop"

$standardsDir = "$env:USERPROFILE\.claude\standards"
$claudeMd = "$env:USERPROFILE\.claude\CLAUDE.md"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "📦 安装 dev-standards..." -ForegroundColor Cyan

# 1. 确保 ~/.claude 目录存在
$claudeDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir | Out-Null
    Write-Host "✔ 创建目录: $claudeDir" -ForegroundColor Green
}

# 2. 链接 standards 目录
if (Test-Path $standardsDir) {
    $item = Get-Item $standardsDir -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        Write-Host "✔ standards 链接已存在，跳过" -ForegroundColor Green
    } else {
        Write-Host "⚠️  $standardsDir 已存在（非链接），备份为 .bak" -ForegroundColor Yellow
        Rename-Item $standardsDir "$standardsDir.bak"
        New-Item -ItemType SymbolicLink -Path $standardsDir -Target "$scriptDir\standards" | Out-Null
        Write-Host "✔ 已创建符号链接（原目录已备份）" -ForegroundColor Green
    }
} else {
    New-Item -ItemType SymbolicLink -Path $standardsDir -Target "$scriptDir\standards" | Out-Null
    Write-Host "✔ 已创建符号链接: $standardsDir" -ForegroundColor Green
}

# 3. 自动配置 CLAUDE.md
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

if (Test-Path $claudeMd) {
    if (Select-String -Path $claudeMd -Pattern $marker -Quiet) {
        Write-Host "✔ CLAUDE.md 已配置，跳过" -ForegroundColor Green
    } else {
        Add-Content -Path $claudeMd -Value "`n$reference"
        Write-Host "✔ 已追加规范引用到 CLAUDE.md" -ForegroundColor Green
    }
} else {
    Set-Content -Path $claudeMd -Value $reference
    Write-Host "✔ 已创建 CLAUDE.md 并写入规范引用" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ 安装完成！重启 Claude Code 即可生效。" -ForegroundColor Green
