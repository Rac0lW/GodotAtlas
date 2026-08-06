# 29 · 距离渐隐

距离渐隐需要世界空间表面位置与世界空间相机位置。如果混用对象空间，移动或缩放模型会改变渐隐逻辑。

## 任务

在顶点阶段传递世界位置，在片元阶段计算到 `CAMERA_POSITION_WORLD` 的距离，用 `fade_near` 和 `fade_far` 控制 Alpha。

## 验收

- 近于 `fade_near` 时完全不透明。
- 远于 `fade_far` 时完全透明。
- 移动模型和移动相机产生一致的相对距离结果。

## 提示 1

世界位置仍由 `MODEL_MATRIX * vec4(VERTEX, 1.0)` 得到。

## 提示 2

距离使用 `distance(a, b)`。

## 提示 3

Alpha 为 `1.0 - smoothstep(fade_near, fade_far, camera_distance)`。

