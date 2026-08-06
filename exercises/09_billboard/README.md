# 09 · Billboard

Billboard 是始终面向相机的平面。关键不是每帧旋转节点，而是用相机的逆视图矩阵重建模型方向，并保留模型平移。

## 任务

启用 `skip_vertex_transform`，使用 `INV_VIEW_MATRIX` 的前三个基向量和 `MODEL_MATRIX[3]` 构造 Billboard 矩阵，最终手动写入 `POSITION`。

## 验收

- 旋转预览相机时，平面始终正对相机。
- 平面的世界位置保持不变。
- 顶点经过世界、视图、投影三个阶段。

## 提示 1

新矩阵前三列控制方向，第四列控制平移。

## 提示 2

投影链为世界位置到视图位置，再到裁剪位置。

## 提示 3

最后写入 `POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vertex_ws;`。

