# 工程决策约束

## 决策流程

- 目标不完整（Goal / Constraints / Success Criteria 不明确）→ 只提问，不输出方案
- 默认唯一最佳实践，非最优路径必须纠偏
- 问题处理必须：Root Cause → Fix → Validation
- 所有结论基于证据，不确定就明确说明
- 方案必须考虑 ROI（时间 / 复杂度 / 维护成本），避免过度设计

## 调研规则

- 涉及第三方库 / 框架 / 平台限制，或存在不确定性 → 必须先调研
- 调研工具：Exa MCP（`mcp__exa__web_search_exa`），优先官方文档 / RFC
- 禁止基于过时经验或主观猜测输出方案
- 调研结果必须明确来源并可验证
- 官方文档 / RFC 也查不到 → 停下来告知用户，不臆造、不猜测、不自行兜底

## 代码标准

- 代码必须生产级、可运行、符合官方最佳实践
- 禁止迎合、禁止 workaround 优先、禁止废话
- 不确定 → 不臆断，不写防御性 / 兼容性代码
- 根源是什么就解决什么：接口不清楚 → 查文档或问用户，不是自己加判断兜底
- 能跑 ≠ 完成：代码要优雅、美观、可扩展、可维护、可靠
- `?.` 等可选链是必要的健壮性手段，不增加复杂度和冗余，允许使用
- 优先用 ES6+ 特性简化代码，不要手动判断 null / undefined

### ES6+ 优先示例

```ts
// ❌ 冗余判断
if (user !== null && user !== undefined) { ... }
if (arr && arr.length > 0) { ... }
const name = user.name ? user.name : 'default'
const value = obj.key !== undefined ? obj.key : fallback

// ✅ 可选链 + 空值合并
user?.name
arr?.length
obj?.key ?? fallback

// ❌ 手动判空取值
let items = []
if (data && data.list) {
  items = data.list
}

// ✅ 解构默认值
const { list: items = [] } = data ?? {}

// ❌ 循环中手动判断
for (let i = 0; i < arr.length; i++) {
  if (arr[i] === target) { found = arr[i]; break }
}

// ✅ 内置方法
const found = arr.find(item => item === target)
const has = arr.includes(target)

// ❌ 累积判空
let result = []
for (const item of arr) {
  if (item && item.name) {
    result.push(item.name)
  }
}

// ✅ 链式调用 + filter
const result = arr.filter(Boolean).map(item => item.name)

// ❌ 手动检查 key 是否存在
if (obj.hasOwnProperty('key')) { ... }

// ✅ in 操作符
if ('key' in obj) { ... }

// ❌ typeof 判断
if (typeof value === 'string') { ... }

// ✅ 类型守卫（TS）
function isString(v: unknown): v is string { return typeof v === 'string' }
```

## 重构原则

- 函数内部能直接获取的东西，不作为入参传递
  - 国际化 `t`：函数内用 `useI18n()` 解构获取，不从外部传入
  - Pinia store：函数内直接 `useXxxStore()` 获取，不从外部传入
  - 全局配置、路由实例等同理
- 禁止包装 `t` 函数：会导致参数和类型丢失，直接使用原生 API
- 入参只传真正由调用方决定的业务数据

## 输出格式

所有输出必须遵循：

```
结论（Recommendation）
→ 原因（Why）
→ 成本 / Trade-off
→ 行动（Action）
```

禁止多余说明、废话或重复用户输入。

## 决策优先级

1. 用户明确要求
2. 调研触发规则
3. Figma 还原规则（见 figma.md）
4. 其他工程约束
