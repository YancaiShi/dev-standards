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

# 3. 从 CLAUDE.md 移除我们添加的内容（精确匹配）
if ((Test-Path $claudeMd) -and (Select-String -Path $claudeMd -Pattern "# 个人前端开发规范" -Quiet)) {
    $content = Get-Content $claudeMd -Raw
    # 只移除我们添加的精确块（从 "# 个人前端开发规范" 到下一个 "## " 之前）
    $pattern = "(?ms)\r?\n# 个人前端开发规范\r?\n\r?\n> 详细规范文档.*?(?=\r?\n## |\z)"
    $newContent = [regex]::Replace($content, $pattern, "")
    Set-Content -Path $claudeMd -Value $newContent.TrimEnd()
    Write-Host "✔ 已从 CLAUDE.md 移除规范引用" -ForegroundColor Green
} else {
    Write-Host "✔ CLAUDE.md 中未找到规范引用，跳过" -ForegroundColor Green
}

# 4. 询问是否删除仓库
Write-Host ""
$reply = Read-Host "是否删除仓库 ~/dev-standards？(y/N)"
if ($reply -eq "y" -or $reply -eq "Y") {
    Remove-Item -Recurse -Force "$env:USERPROFILE\dev-standards"
    Write-Host "✔ 已删除仓库" -ForegroundColor Green
} else {
    Write-Host "✔ 保留仓库 ~/dev-standards" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ 卸载完成！重启 Claude Code 生效。" -ForegroundColor Green
