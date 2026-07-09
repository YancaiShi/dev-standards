# 组件设计规范

## Props

- 少而明确:每个 prop 都必要,无关职责拆成独立组件
- boolean 超过 3 个(且互斥 / 有组合关系)→ 改用 enum(string 联合类型),避免布尔组合爆炸
- 必填项给精确类型,可选项给合理默认值,避免调用方每次都要传

```ts
// ❌ 布尔堆叠,组合难维护
defineProps<{
  isPrimary?: boolean
  isGhost?: boolean
  isLink?: boolean
  isLarge?: boolean
}>()

// ✅ 用 enum 表达互斥状态
type Variant = 'primary' | 'ghost' | 'link'
defineProps<{
  variant?: Variant
  size?: 'sm' | 'md' | 'lg'
}>()
```

## 透传限制

- 禁止 prop 透传超过 2 层:A → B → C → D 的链条要打断
- 跨多层共享状态用 provide / inject 或状态管理(Pinia),不要层层手传

## 逻辑归属

- 有状态逻辑(响应式、生命周期、副作用)→ composable(`useXxx`)
- 纯数据转换(无副作用、输入决定输出)→ utility(纯函数)
- 组件只做「组合 UI + 调用逻辑」,不塞业务算法

```ts
// ❌ 业务逻辑塞进组件
const total = computed(() => {
  let sum = 0
  cart.value.forEach(item => {
    /* 复杂折扣计算 */
  })
  return sum
})

// ✅ 纯计算抽成 utility,组件只调用
import { calcTotal } from '@/utils/cart'
const total = computed(() => calcTotal(cart.value))
```

## 组合优于配置

- 需求分化时优先「组合多个小组件」,而非「给一个大组件加无数 prop / 分支」
- 单一职责:一个组件只解决一类 UI 问题
