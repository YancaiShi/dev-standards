# dev-standards

Claude Code 插件 — 一套前端开发规范，自动应用到所有 AI 编程工具。

## 安装

### 本地开发测试

```bash
claude --plugin-dir ./dev-standards
```

### 安装到本地

```bash
claude plugin init dev-standards
```

### 从 marketplace 安装

```bash
/plugin install dev-standards
```

## 结构

```
dev-standards/
├── .claude-plugin/
│   └── plugin.json          # 插件清单
├── agents/
│   └── standards-agent.md   # 主 agent（始终生效的规范）
├── skills/
│   ├── ui-review/           # UI 审查
│   ├── component-spec/      # 组件规格
│   ├── dark-theme/          # 深色主题
│   ├── design-polish/       # 视觉打磨
│   └── spacing-audit/       # 间距审计
├── standards/               # 规范源文件
│   ├── code-style.md
│   ├── commit-style.md
│   ├── engineering.md
│   ├── figma.md
│   ├── i18n.md
│   └── review.md
└── settings.json            # 激活主 agent
```

## 内容

### Skills（按需调用）

| Skill | 调用方式 | 用途 |
|-------|---------|------|
| ui-review | `/dev-standards:ui-review` | 商业软件级视觉审查 |
| component-spec | `/dev-standards:component-spec` | 组件规格文档生成 |
| dark-theme | `/dev-standards:dark-theme` | 深色主题优化 |
| design-polish | `/dev-standards:design-polish` | 视觉打磨 |
| spacing-audit | `/dev-standards:spacing-audit` | 间距一致性审查 |

### Standards（始终生效）

通过 `standards-agent` 自动加载：

- 工程决策约束
- 代码风格规范
- Git 提交规范
- 国际化规范
- Figma 还原规则
- Code Review 偏好

## 工作流

1. 编辑 `standards/` 或 `skills/` 中的文件
2. 运行 `/reload-plugins` 重新加载
3. 变更立即生效
