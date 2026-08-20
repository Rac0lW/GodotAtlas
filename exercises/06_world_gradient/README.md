# 06 · 世界渐变

对象空间渐变会跟着模型移动。世界空间渐变则像场景中的一层有色雾，任何模型穿过它都会得到一致的颜色。

## 任务

将世界空间 Y 坐标传入片元阶段，以 `gradient_low` 和 `gradient_high` 为边界，在 `cold_color` 与 `warm_color` 之间插值。

## 验收

- 四个指定 uniform 均存在。
- 移动模型时，颜色分界线留在世界原位。
- 边界外颜色稳定，没有无限外插。

## 固定数值目标

`cold_color` 默认值为 `vec4(0.05, 0.22, 0.42, 1.0)`，`warm_color` 默认值为 `vec4(1.0, 0.48, 0.16, 1.0)`。`gradient_low` 和 `gradient_high` 的默认值分别为 `-0.7` 与 `0.7`。

## 提示 1

沿用上一题的 varying，但它应保存世界空间高度。

## 提示 2

`smoothstep(low, high, value)` 自带 0 到 1 限制。

## 提示 3

世界高度来自 `(MODEL_MATRIX * vec4(VERTEX, 1.0)).y`。
