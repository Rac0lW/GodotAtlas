# 16 · Fresnel 边缘光

当视线几乎贴着表面掠过时，`dot(NORMAL, VIEW)` 接近零。用 `1 - dot` 就能得到边缘信号，再用幂指数控制轮廓宽度。

## 任务

计算 Fresnel 项，将 `rim_color` 按该强度叠加到 `base_color`。`rim_power` 越高，边缘应越窄。

## 验收

- 正对相机的中心保留基础色。
- 轮廓明显发亮。
- 改变 `rim_power` 会改变轮廓宽度。

## 固定数值目标

`base_color` 默认值为 `vec4(0.035, 0.08, 0.14, 1.0)`，`rim_color` 默认值为 `vec4(0.2, 0.95, 0.82, 1.0)`，`rim_power` 默认值为 `3.0`。

## 提示 1

先把点积限制在 0 到 1。

## 提示 2

基础信号是 `1.0 - max(dot(NORMAL, VIEW), 0.0)`。

## 提示 3

对基础信号使用 `pow(signal, rim_power)`。
