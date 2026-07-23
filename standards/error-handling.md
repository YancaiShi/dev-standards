# 错误处理规范

## 分层职责

- API 层统一拦截:在 axios / fetch 封装层集中处理网络错误、HTTP 状态码、业务错误码,统一上报、统一提示
- 业务层按需 catch:只在需要"局部恢复 / 降级 / 静默"时才 catch,否则让错误冒泡到统一拦截层
- 禁止业务代码到处 try/catch 重复处理同一个错误
- **发请求前必须先了解拦截器**:调用任何接口前,先确认项目中 axios / fetch 的 request / response interceptor 已做了哪些处理（错误码判断、token 注入、统一错误提示等）,禁止在业务代码中重复拦截器已处理的逻辑（如再判断 `res.code === 200`）

## 错误信息

- 面向用户:提示必须是用户能理解的自然语言(如「网络异常,请稍后重试」),禁止暴露技术细节(stack、状态码、内部字段名、SQL / 接口路径)
- 面向开发者:技术细节只进日志 / 控制台,不进 UI
- 文案走 i18n,禁止硬编码错误文本

## 异步处理

- 所有 Promise / async 必须处理 reject:用 await 时配 try/catch,或用 `.catch()`,或交给统一拦截层
- 禁止裸 await 不处理错误导致 unhandledrejection
- 并发场景用 `Promise.allSettled` 容忍部分失败,不要让一个失败拖垮全部

## 边界防御

- 数据边界层(解析外部输入 / 接口返回)必须防御:校验关键字段、兜底默认值
- 业务内部信任上游:拿到数据直接用,不再层层判空(见 [[code-style]] 的 ES6+ 优先部分)

## 示例

```ts
// ❌ 业务层重复拦截,且把技术细节暴露给用户
try {
  const data = await getUser()
} catch (e) {
  alert(`请求失败: ${e.message}`) // 暴露内部信息 + 硬编码文案
}

// ✅ API 层已统一拦截,业务层只关心成功路径;需要降级时才 catch
const data = await getUser()

// 或局部降级:静默或走兜底 UI,不重复提示(拦截层已提示)
try {
  const data = await getUser()
} catch {
  users.value = []
}

// ❌ 裸 Promise 不处理 reject
function load() {
  fetchData().then(setData) // 缺 .catch
}

// ✅
function load() {
  fetchData().then(setData).catch(() => {})
}

// ✅ 部分失败容忍
const results = await Promise.allSettled(requests)
const ok = results
  .filter((r): r is PromiseFulfilledResult<unknown> => r.status === 'fulfilled')
  .map(r => r.value)
```
