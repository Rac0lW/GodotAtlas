# 08 · 混合、遮罩与 Alpha

硬阈值会制造锯齿和闪烁。距离场配合 `smoothstep()` 可以把边界变成可控过渡，再同时驱动颜色与透明度。

## 任务

以画面中心为圆心构造半径遮罩，用 `feather` 控制软边，在 `outside_color` 与 `inside_color` 之间混合，并把遮罩写入 Alpha。

## 验收

- 圆形内部不透明，外部透明。
- `feather` 增大时边缘逐渐变宽。
- 颜色和 Alpha 使用同一个遮罩。

## 提示 1

中心化坐标为 `UV - vec2(0.5)`。

## 提示 2

距离使用 `length()`。

## 提示 3

遮罩可写成 `1.0 - smoothstep(radius - feather, radius + feather, distance)`。
