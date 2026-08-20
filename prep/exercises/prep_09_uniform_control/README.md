# P09 · 把颜色交给参数

Shader 中的 `uniform` 是材质可以编辑的输入。把颜色从函数体移到 uniform，预览和正式项目就能共享同一套参数习惯。

## 任务

声明 `uniform vec4 prep_color`，默认值设为 `vec4(0.12, 0.78, 0.72, 1.0)`，再把它输出到 `COLOR`。

## 验收

- 文件中存在名为 `prep_color` 的 `vec4` uniform。
- 默认画面是青绿色，数值为 RGB `(0.12, 0.78, 0.72)`，Alpha 为 `1.0`。
- 修改材质参数后，画面会随 uniform 改变。

## 提示 1

声明格式是 `uniform vec4 prep_color : source_color = ...;`。

## 提示 2

uniform 的默认值仍然是 Shader 内的常量。

## 提示 3

在 `fragment()` 中写 `COLOR = prep_color;`。
