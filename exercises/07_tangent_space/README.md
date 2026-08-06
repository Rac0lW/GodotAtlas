# 07 · 切线空间

法线贴图通常存储切线空间方向。直接把它当作观察空间法线使用，会让凹凸方向随模型旋转而出错。TANGENT、BINORMAL 与 NORMAL 组成 TBN 基底。

## 任务

保留程序化生成的切线空间法线，构造 TBN 矩阵，将它转换到观察空间后写入 `NORMAL`。

## 验收

- 使用 TANGENT、BINORMAL、NORMAL 构造 `mat3`。
- 转换后的法线被归一化。
- 旋转模型时，细节光照稳定贴在表面。

## 提示 1

矩阵三列分别是切线、次切线和几何法线。

## 提示 2

转换方向使用 `tbn * normal_ts`。

## 提示 3

最终写入 `NORMAL = normalize(tbn * normal_ts);`。
