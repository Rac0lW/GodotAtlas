# 25 · 旋转矩阵

单轴矩阵容易理解，实际旋转常由多个轴组合。矩阵乘法不满足交换律，因此 XYZ 和 ZYX 会得到不同结果。

## 任务

根据三个角度构造 X、Y、Z 旋转矩阵，按 `rotation_z * rotation_y * rotation_x` 的顺序变换顶点。

## 验收

- 每个轴都有独立 uniform。
- 只改变一个角度时，模型绕对应轴旋转。
- 改变乘法顺序会产生可观察差异。

## 提示 1

先把三个角度转换为弧度。

## 提示 2

每个 `mat3` 只在对应二维平面包含正弦和余弦。

## 提示 3

最终写入 `VERTEX = rotation_z * rotation_y * rotation_x * VERTEX;`。

