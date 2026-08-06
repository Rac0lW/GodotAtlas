# 11 · 材质通道

光照结果不仅取决于灯，也取决于材质如何响应能量。`ALBEDO` 决定基础反射色，`ROUGHNESS` 控制高光宽度，`METALLIC` 决定材质更接近绝缘体还是金属。

## 任务

声明 `base_color`、`roughness_value` 和 `metallic_value` 三个 uniform，并分别写入对应材质通道。

## 验收

- 三个参数都出现在 Workshop 控件区。
- 粗糙度从低到高时，高光从锐利变宽。
- 金属度改变时，反射色明显变化。

## 提示 1

颜色使用 `vec4` 与 `source_color`，其余两个参数使用 `float`。

## 提示 2

给 float 参数添加 0 到 1 的 `hint_range`。

## 提示 3

分别写入 `ALBEDO`、`ROUGHNESS` 和 `METALLIC`。
