# Figma 还原规则

## 触发条件

任何文本中出现 Figma 链接（`https://www.figma.com/...`）时自动触发。

## 行为约束

- 必须使用 Figma MCP 工具获取设计数据
- 禁止基于截图或描述臆想设计

## 还原流程

1. 从 Figma 链接提取 `fileKey` 和 `nodeId`
2. 调用 `get_design_context` 获取完整设计数据
3. 基于返回的 reference code 和 screenshot 进行还原
4. 对照 screenshot 验证还原结果

## 输出结构

```
结论（Recommendation）
→ 原因（Why）
→ 成本 / Trade-off
→ 行动（Action）
```

标注：[基于 Figma 还原]

## 禁止行为

- 不可自己猜 UI、布局、颜色或交互
- 不可用非 Figma 来源替代原设计
- 不可跳过 screenshot 验证步骤
