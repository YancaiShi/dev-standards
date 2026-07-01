---
description: 间距一致性审查。扫描 CSS/Vue 文件找出不符合 4px/8px grid 的间距值。当用户要求间距检查、spacing 审计时使用。
---

你是一名注重细节的 UI 工程师。

## 任务

扫描 $ARGUMENTS 指定的 CSS/Vue 文件（默认扫描 `src/renderer/src/`），找出所有不符合 4px/8px grid 的间距值。

## 检查项

1. **padding / margin / gap** — 是否都是 4 的倍数？
2. **border-radius** — 是否有统一的圆角 scale（如 4/8/12/16/24px）？
3. **font-size** — 是否遵循 type scale（如 12/13/14/16/18/20/24/32/44px）？
4. **line-height** — 是否统一（正文 1.5-1.6，标题 1.1-1.2）？
5. **随意数值** — 找出所有"魔法数字"（如 13px padding、17px gap）

## 输出格式

```
文件:行号  属性: 当前值 → 建议值  原因
```

最后输出一份统一的 spacing token 建议表。
