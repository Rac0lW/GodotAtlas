# 14 · Blinn-Phong

Blinn-Phong 使用光线和视线之间的半程向量。法线越接近半程向量，高光越强；指数越大，高光越集中。

## 任务

在保留 Lambert 漫反射的基础上，计算 `half_direction = normalize(LIGHT + VIEW)`，把 `pow(max(dot(NORMAL, half_direction), 0.0), shininess)` 累加到 `SPECULAR_LIGHT`。

## 验收

- 高光会随相机或灯光移动。
- `shininess` 增大时高光缩小。
- 背光面不会出现完整高光。

## 提示 1

高光也应乘灯光颜色和衰减。

## 提示 2

用漫反射项限制背光高光。

## 提示 3

将高光乘以 `step(0.0, dot(NORMAL, LIGHT))`。

