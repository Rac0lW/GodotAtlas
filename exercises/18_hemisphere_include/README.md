# 18 · 半球光与 ShaderInclude

半球光用法线朝上程度在天空色与地面反射色之间插值。把计算提取到 `.gdshaderinc` 后，同一函数可以服务多个材质，也能单独审查。

## 任务

引用 `res://shared/shaders/atlas_lighting.gdshaderinc`，调用 `atlas_hemisphere()` 计算环境色，并与 `base_color` 相乘。

## 验收

- shader 使用 `#include`，没有复制函数实现。
- 朝上的区域偏天空色，朝下区域偏地面色。
- 基础色仍然影响最终结果。

## 提示 1

include 指令位于函数外。

## 提示 2

函数参数依次是法线、天空色、地面色。

## 提示 3

将返回值乘 `base_color.rgb` 后写入 `ALBEDO`。

