# 02 · Uniform 控制台

硬编码值只能通过改源码调整。`uniform` 把参数暴露给材质和 Workshop，适合艺术调节、动画驱动与复用。

## 任务

声明一个名为 `ink_color` 的 `vec4` 颜色 uniform，并用它填满预览。默认值使用偏青色的 `vec4(0.12, 0.78, 0.72, 1.0)`。

## 验收

- Workshop 能识别 `ink_color`。
- 修改颜色控件时，预览立即更新。
- shader 中没有继续使用硬编码的最终颜色。

## 提示 1

颜色参数可以添加 `source_color` 提示。

## 提示 2

声明位于函数外：`uniform vec4 ... : source_color = ...;`。

## 提示 3

在 `fragment()` 中把 `ink_color` 直接赋给 `COLOR`。
