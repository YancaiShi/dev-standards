# Git 提交规范

## 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Type

| Type | 用途 |
|------|------|
| `feat` | 新功能 |
| `fix` | Bug 修复 |
| `docs` | 文档变更 |
| `style` | 代码格式（不影响逻辑） |
| `refactor` | 重构（非 feat / fix） |
| `perf` | 性能优化 |
| `test` | 测试相关 |
| `chore` | 构建、工具、依赖 |
| `ci` | CI/CD 配置 |

## Scope

可选，标识影响范围：

- 组件名：`feat(Button): ...`
- 模块名：`fix(auth): ...`
- 文件类型：`docs(readme): ...`

## Subject

- 使用祈使句（"add" 不是 "added"）
- 首字母小写
- 不超过 50 字符
- 不加句号

## Body

- 解释 **为什么** 改，不是改了什么
- 每行不超过 72 字符

## Footer

- 关联 Issue：`Closes #123`
- Breaking Change：`BREAKING CHANGE: 描述`

## 示例

```
feat(Button): add loading state

Add spinner and disabled state while async action is pending.
Uses existing Spinner component to avoid new dependency.

Closes #456
```
