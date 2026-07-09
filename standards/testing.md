# 测试规范

## 测试范围

- 核心业务逻辑(纯函数 / utility / composable 的计算部分)必须有单元测试
- 复杂状态流转、边界条件、数据转换重点覆盖
- 简单的 getter / setter、直接透传不需要测

## 组件测试

- 测行为,不测实现:通过用户视角交互(点击、输入、提交)断言结果,不断言内部状态 / 私有方法 / 实现细节
- 不依赖组件内部结构(子组件实例、data 字段名),重构不该导致测试大面积失败

## 独立性

- 每个用例独立,不依赖执行顺序、不依赖前一个用例的副作用
- 用例内部自己 setup 需要的数据,测完清理
- 禁止用例间共享可变状态

## 命名与断言

- 用例名表达意图:「当...时,应该...」,描述场景而非「测试 xxx 函数」
- 一个用例只断言一个行为,失败时能快速定位

## 边界

- mock 外部依赖(接口、时间、随机数、浏览器 API),保证可复现
- 不 mock 被测对象本身

## 示例

```ts
// ✅ 测行为:输入 → 输出
describe('formatPrice', () => {
  it('金额超过一万时缩写为万', () => {
    expect(formatPrice(123456)).toBe('12.35万')
  })
  it('零或负数返回原值', () => {
    expect(formatPrice(0)).toBe('0')
    expect(formatPrice(-100)).toBe('-100')
  })
})

// ❌ 测实现细节:断言内部状态
it('点击后 isLoading 变 true', () => {
  expect((wrapper.vm as any).isLoading).toBe(true) // 实现细节,重构即坏
})

// ✅ 测交互行为
it('提交时显示加载态', async () => {
  await wrapper.find('button').trigger('click')
  expect(wrapper.find('[data-test="loading"]').exists()).toBe(true)
})
```
