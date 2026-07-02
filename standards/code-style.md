# 代码风格规范

## 文件组织

- 单文件不宜过长，超过阅读阈值 → 按职责拆分，禁止堆砌成大文件
- 嵌套要浅，过深不易阅读：条件 / 循环 / 回调用早返回（guard clause）、提取函数、链式调用拍平，避免层层缩进
- 功能完全独立 → 用独立文件夹管理其所有相关代码，干净、方便、不污染其他位置
- 一个文件夹 = 一个职责，内部自包含（组件、类型、工具函数、样式）

## 复用原则

- 模块之间天然有共性，能复用的必须复用，禁止各写各的副本
- 遵守单一数据源（Single Source of Truth）：同一份常量、类型、配置、逻辑只在唯一一处定义，其他地方引用而非复制
- 共性 UI → 公共组件；共性逻辑 → composable / utility；共性样式 → 变量或公共类；共性配置 → 集中导出

## Vue 规范

- 项目配了 Tailwind → 优先用 Tailwind，不写原始 CSS / SCSS
- 必须写原始 CSS / SCSS 时同样要考虑复用：重复的颜色、尺寸、间距、动画抽成变量或全局类，禁止在多处硬编码
- 不轻易去掉 `scoped`
- 一个 `.vue` 文件只写一个 `<style>`，全局样式写到全局文件，不通过多 style 块注入

## TypeScript 规范

- 关注 TS 错误，不写 `any` 等泛化类型
- 类型要精确，宁可多写一个 interface 也不用 `any` 兜底

## 命名规范

### 文件 / 文件夹

- 新增组件必须参考现有项目的目录结构和命名风格，不独立创造体系
- 文件名不宜过长，不宜冗余
- 禁止 `xxxUtils.ts`、`xxxHelper.ts`、`xxxService.ts` 这类无意义后缀堆砌

### 变量 / 方法

- 名称简洁，能表达意图即可，不堆砌单词
- 禁止 AI 味命名：`resolveXxx`、`normalizeXxx`、`ensureXxx`、`handleXxx`、`processXxx`
- 好的命名：`getUsers`、`formatDate`、`parseConfig`
- 差的命名：`resolveUserDataFromApiResponse`、`normalizeDateStringToISOFormat`
