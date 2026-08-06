# Shader Atlas 架构

## 数据层

- `course/catalog.json`：六个模块、32 个练习、预览夹具、前置关系和验证模式。
- `course/checks.json`：图像阈值、必要源码契约和人工观察项。
- `exercises/<id>/README.md`：讲义、任务、验收标准与三级提示。
- `exercise.gdshader`：学习者实际编辑的文件。
- `starter.gdshader.txt`：重置时使用的不可导入快照。
- `solutions/<id>.gdshader`：只供参考渲染器和主动查看答案使用。

## 运行时

- `CourseRepository` 读取并索引课程内容。
- `LessonParser` 把 Markdown 分成导语、正文和渐进提示，不负责界面样式。
- `ProgressStore` 在 `user://shader_atlas/progress.json` 保存当前题、完成题和提示揭示数量。损坏的存档会先复制到带时间戳的备份，再建立新存档。
- `ShaderWorkspace` 监听外部文件修改、生成运行时 Shader，并在重置前保存学习者代码。
- `ValidationRegistry` 执行源码契约、图像差异计算和混合验收逻辑。
- `CourseSession` 把上述组件组织成界面可消费的状态与信号。
- `PrivateAssetResolver` 隔离私有配套资源，保证核心课程可独立运行。

## 交互流程

1. Workshop 载入目录和本机进度，打开上次停留的练习。
2. 学习者在 Godot Shader 编辑器中修改 `exercise.gdshader`。
3. 文件时间变化后，Workshop 自动重新载入学习者 Shader。
4. 点击验证时，实时夹具与参考夹具在同样条件下渲染。
5. 验证器合并图像、源码契约和人工观察结果。
6. 通过后写入进度，并解锁下一题。

## 恢复策略

- 重置不会直接丢弃代码，旧内容先写入 `user://shader_atlas/backups`。
- starter 使用 `.txt` 后缀，避免 Godot 把它当成运行资源导入。
- 参考解答与学习者文件物理分离，验证过程不会覆写学习者代码。
- 核心课程不依赖 `assets_v17`，移动或删除私人素材不会破坏索引。
