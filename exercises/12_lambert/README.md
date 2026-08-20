# 12 · Lambert

Lambert 漫反射只关心表面法线与入射光方向的夹角。两者点积越大，表面越朝向光；负值代表光在表面背面，应截断为零。

## 任务

禁用内置漫反射，在 `light()` 中计算 `max(dot(NORMAL, LIGHT), 0.0)`，乘上材质色、灯光颜色与衰减，累加到 `DIFFUSE_LIGHT`。

## 验收

- 背光面不会得到负亮度。
- 移动灯光时，明暗边界平滑移动。
- 光源颜色与距离衰减仍然生效。

## 固定数值目标

`base_color` 默认值为 `vec4(0.78, 0.34, 0.12, 1.0)`。灯光颜色由预览夹具提供，材质基础色使用这个数值。

## 提示 1

自定义 `light()` 后，需要自己累加光照结果。

## 提示 2

衰减变量是 `ATTENUATION`。

## 提示 3

最终形式为 `DIFFUSE_LIGHT += ALBEDO * LIGHT_COLOR * ndotl * ATTENUATION;`。
