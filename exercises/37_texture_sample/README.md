# 37 · 纹理采样

程序化图形最终经常要和已有画面混合。`sampler2D` 表示二维纹理，`SCREEN_UV` 则给出当前像素在屏幕纹理中的采样坐标。

## 任务

声明一个 `screen_texture` sampler2D，用 `texture(screen_texture, SCREEN_UV)` 读取后处理输入，并原样输出。

## 验收

- Shader 声明了 `sampler2D screen_texture`。
- 画面来自屏幕纹理，而不是固定颜色。
- 采样坐标使用 `SCREEN_UV`，画面不会整体错位。

## 提示 1

Godot 的屏幕纹理声明需要 `hint_screen_texture`。

## 提示 2

后处理片元函数已经提供 `SCREEN_UV`。

## 提示 3

`COLOR = texture(screen_texture, SCREEN_UV);` 可以先完成原样采样。
