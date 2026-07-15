$ErrorActionPreference = "Stop"

$standardsDir = "$env:USERPROFILE\.claude\standards"
$claudeMd = "$env:USERPROFILE\.claude\CLAUDE.md"

Write-Host "🗑️  卸载 dev-standards..." -ForegroundColor Cyan

# 1. 删除链接/目录
if (Test-Path $standardsDir) {
    $item = Get-Item $standardsDir -Force
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        cmd.exe /c "rmdir `"$standardsDir`"" | Out-Null
        Write-Host "✔ 已删除链接" -ForegroundColor Green
    } else {
        Remove-Item -Recurse -Force $standardsDir
        Write-Host "✔ 已删除 standards 目录" -ForegroundColor Green
    }
}

# 2. 恢复备份
if (Test-Path "$standardsDir.bak") {
    Rename-Item "$standardsDir.bak" $standardsDir
    Write-Host "✔ 已恢复备份" -ForegroundColor Green
}

# 3. 从 CLAUDE.md 移除我们添加的精确内容
if ((Test-Path $claudeMd) -and (Select-String -Path $claudeMd -Pattern "# 个人前端开发规范" -Quiet)) {
    $content = Get-Content $claudeMd -Raw

    # 我们添加的精确块
    $ourBlock = @"

# 个人前端开发规范

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

    if ($content.Contains($ourBlock)) {
        $newContent = $content.Replace($ourBlock, "")
        Set-Content -Path $claudeMd -Value $newContent.TrimEnd()
        Write-Host "✔ 已从 CLAUDE.md 移除规范引用" -ForegroundColor Green
    } else {
        Write-Host "✔ CLAUDE.md 中未找到精确匹配的规范引用，跳过" -ForegroundColor Green
    }
} else {
    Write-Host "✔ CLAUDE.md 中未找到规范引用，跳过" -ForegroundColor Green
}

# 4. 删除 Cursor User Rules
$removeCursor = Join-Path $env:USERPROFILE "dev-standards\scripts\remove-cursor-rules.ps1"
if (Test-Path $removeCursor) {
    & $removeCursor
} else {
    Get-ChildItem -Path (Join-Path $env:USERPROFILE ".cursor\rules") -Filter "dev-standards-*.mdc" -ErrorAction SilentlyContinue |
        Remove-Item -Force -ErrorAction SilentlyContinue
    Write-Host "✔ 已清理 Cursor Rules（dev-standards-*.mdc）" -ForegroundColor Green
}

# 5. 询问是否删除仓库
Write-Host ""
$reply = Read-Host "是否删除仓库 ~/dev-standards？(y/N)"
if ($reply -eq "y" -or $reply -eq "Y") {
    Remove-Item -Recurse -Force "$env:USERPROFILE\dev-standards"
    Write-Host "✔ 已删除仓库" -ForegroundColor Green
} else {
    Write-Host "✔ 保留仓库 ~/dev-standards" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ 卸载完成！重启 Claude Code / Cursor 生效。" -ForegroundColor Green
