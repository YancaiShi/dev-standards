# 代码风格规范

## 文件组织

- 单文件不宜过长，超过阅读阈值 → 按职责拆分，禁止堆砌成大文件
- 嵌套要浅，过深不易阅读：条件 / 循环 / 回调用早返回（guard clause）、提取函数、链式调用拍平，避免层层缩进
- 功能完全独立 → 用独立文件夹管理其所有相关代码，干净、方便、不污染其他位置
- 一个文件夹 = 一个职责，内部自包含（组件、类型、工具函数、样式）
- 工具方法（utility）独立于业务代码：通用工具放 `utils/`，模块专属工具放该模块文件夹内，禁止塞进业务组件 / 业务逻辑文件

## 复用原则

- 模块之间天然有共性，能复用的必须复用，禁止各写各的副本
- 共性 UI → 公共组件；共性逻辑 → composable / utility；共性样式 → 变量或公共类；共性配置 → 集中导出
- **主动扫描**：开发过程中发现相似结构、重复逻辑、雷同 UI 片段，必须提取为模块/组件，不能因为"能跑"就到处复制
- 提取时机：同一模式出现第 2 次即可提取，不等到第 3 次；已有模块能覆盖的，直接复用，禁止重写一份

## 单一数据源（Single Source of Truth）

同一份数据（常量、类型、配置、逻辑）只在唯一一处定义，其他地方引用而非复制。散落各处的副本是 bug 温床——改一处漏一处。

### 范围

| 数据类型 | 定义位置 | 使用方式 |
|---------|---------|---------|
| 常量 / 枚举 | `constants/` 或模块内 `constants.ts` | `import { ORDER_STATUS } from '@/constants/order'` |
| 类型 / 接口 | `types/` 或模块内 `types.ts` | `import type { User } from '@/types/user'` |
| 配置 | 集中配置文件 | `import { config } from '@/config'` |
| 业务逻辑 | composable / utility | `import { useAuth } from '@/composables/useAuth'` |
| 样式变量 | 主题文件 / CSS 变量 | `var(--color-primary)` |

### 示例

```ts
// ❌ 多处硬编码同一份数据
// a.ts
const STATUS_MAP = { 0: '待处理', 1: '进行中', 2: '已完成' }
// b.ts
const STATUS_MAP = { 0: '待处理', 1: '进行中', 2: '已完成' } // 复制粘贴

// ✅ 定义一次，多处引用
// constants/order.ts
export const ORDER_STATUS = { 0: '待处理', 1: '进行中', 2: '已完成' } as const
// a.ts / b.ts
import { ORDER_STATUS } from '@/constants/order'

// ❌ 类型重复定义
interface UserInfo { id: number; name: string }
// 另一处又写了一遍

// ✅ 类型单点维护
// types/user.ts
export interface User { id: number; name: string }
// 使用处
import type { User } from '@/types/user'

// ❌ 魔法数字散落
if (status === 2) { ... }
if (type === 1) { ... }

// ✅ 枚举集中管理
import { OrderStatus, OrderType } from '@/constants/order'
if (status === OrderStatus.Completed) { ... }
```

## Vue 规范

- 项目配了 Tailwind → 优先用 Tailwind，不写原始 CSS / SCSS
- 必须写原始 CSS / SCSS 时同样要考虑复用：重复的颜色、尺寸、间距、动画抽成变量或全局类，禁止在多处硬编码
- 不轻易去掉 `scoped`
- 一个 `.vue` 文件只写一个 `<style>`，全局样式写到全局文件，不通过多 style 块注入
- 能不用 `watch` 就不用：优先用计算属性（computed）、事件回调、或模板直接绑定表达式；`watch` 只在副作用不可推导时才使用

## 样式与主题

- 所有颜色、间距、字体、圆角、阴影等视觉 token 必须使用 CSS 变量（`var(--xxx)`），禁止硬编码具体值
- 变量定义集中在全局主题文件（如 `theme/light.css`、`theme/dark.css`），通过切换 class 或属性实现主题切换
- Tailwind 项目通过 `theme.extend.colors` 等配置映射到 CSS 变量，保持 Tailwind 使用习惯的同时支持主题
- 命名语义化：`--color-primary`、`--spacing-md`、`--radius-lg`，而非 `--blue-500`、`--16px`
- 新增样式时先查现有变量表，有合适的直接复用，禁止创建功能重复的变量

## TypeScript 规范

- 关注 TS 错误，不写 `any` 等泛化类型
- 类型要精确，宁可多写一个 interface 也不用 `any` 兜底

## 命名规范

### 文件 / 文件夹

- 新增组件必须参考现有项目的目录结构和命名风格，不独立创造体系
- 文件名不宜过长，不宜冗余
- 文件名不重复路径已表达的语义：在 `windowTop/` 下就不叫 `windowTopXxx`，目录本身已说明归属，前缀属冗余
- 禁止 `xxxUtils.ts`、`xxxHelper.ts`、`xxxService.ts` 这类无意义后缀堆砌

### 变量 / 方法

- 名称简洁，能表达意图即可，不堆砌单词
- 禁止 AI 味命名：`resolveXxx`、`normalizeXxx`、`ensureXxx`、`handleXxx`、`processXxx`
- 好的命名：`getUsers`、`formatDate`、`parseConfig`
- 差的命名：`resolveUserDataFromApiResponse`、`normalizeDateStringToISOFormat`
