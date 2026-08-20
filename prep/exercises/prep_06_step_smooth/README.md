# P06 · 硬边与软边

`step` 和 `smoothstep` 都把一个数值变成遮罩。前者在阈值处瞬间切换，后者在两个边界之间平滑过渡。

## 任务

在 `UV.x` 上同时画出硬边和软边。最终每个像素必须按下面的数值公式输出，不能自行更换蓝色或 Alpha：

```glsl
float hard_edge = step(0.5, UV.x);
float soft_edge = smoothstep(0.25, 0.75, UV.x);
COLOR = vec4(hard_edge, soft_edge, 0.18, 1.0);
```

## 验收

- 红色通道是 `step(0.5, UV.x)`，所以 `UV.x < 0.5` 时为 `0.0`，`UV.x >= 0.5` 时为 `1.0`。
- 绿色通道是 `smoothstep(0.25, 0.75, UV.x)`，在两个边界之间从 `0.0` 连续变为 `1.0`。
- 蓝色通道固定为 `0.18`，Alpha 固定为 `1.0`。例如 `UV.x = 0.5` 时，目标 RGBA 是 `(1.0, 0.5, 0.18, 1.0)`。
- Shader 可以在预科预览中正常编译，并通过数值图像验证。

## 提示 1

`step(edge, value)` 只会返回 0 或 1。

## 提示 2

`smoothstep(edge0, edge1, value)` 会把区间映射到 0 到 1。

## 提示 3

把两个结果分别放进 `vec4(hard, soft, 0.18, 1.0)` 的红、绿通道。
