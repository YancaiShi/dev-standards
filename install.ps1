$ErrorActionPreference = "Stop"

$standardsDir = "$env:USERPROFILE\.claude\standards"
$claudeMd = "$env:USERPROFILE\.claude\CLAUDE.md"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "📦 安装 dev-standards..." -ForegroundColor Cyan

# 1. 链接 standards 目录
if (Test-Path $standardsDir) {
    $item = Get-Item $standardsDir -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        Write-Host "✔ standards 链接已存在，跳过" -ForegroundColor Green
    } else {
        Write-Host "⚠️  $standardsDir 已存在（非链接），跳过" -ForegroundColor Yellow
    }
} else {
    New-Item -ItemType SymbolicLink -Path $standardsDir -Target "$scriptDir\standards" | Out-Null
    Write-Host "✔ 已创建符号链接: $standardsDir -> $scriptDir\standards" -ForegroundColor Green
}

# 2. 检查 CLAUDE.md 是否已引用
if ((Test-Path $claudeMd) -and (Select-String -Path $claudeMd -Pattern "~/.claude/standards" -Quiet)) {
    Write-Host "✔ CLAUDE.md 已引用 standards，跳过" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "⚠️  请在 $claudeMd 中添加以下内容：" -ForegroundColor Yellow
    Write-Host ""
    Write-Host @"
# 个人前端开发规范

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
}

Write-Host ""
Write-Host "✅ 完成！重启 Claude Code 生效。" -ForegroundColor Green
