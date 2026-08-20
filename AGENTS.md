@C:\Users\racol\.codex\RTK.md

# 项目 Agent 规则与质量日志

## 题目生成后的输出常量审计

每次新增或修改课程题目，生成 README、starter、exercise、solution 和验证规则后，必须检查一次“答案写死颜色，但题面没有写出数值”的问题。

检查顺序：

1. 对照 `solutions/` 或 `prep/solutions/`，搜索 `COLOR`、`ALBEDO`、`vec3`、`vec4` 和 uniform 默认值。
2. 只要输出中存在固定颜色分量、固定 Alpha 或固定阈值，README 的任务、验收或提示必须给出完整数值表达式，不能只写“红色”“青绿色”“变亮”等主观描述。
3. 至少给出一个可计算的采样点。例如 `UV.x = 0.5` 时，明确写出完整 RGBA 数值。
4. `course/checks.json` 或 `course/prep_checks.json` 的验证模式必须和题目要求一致；固定接口要用 `visual_contract`，固定画面仍由视觉验证比较。
5. 对固定输出在对应 checks 条目增加 `documentation_targets`，让 `tests/validate_course.ps1` 逐项检查题面是否包含每个数值。

完成生成后必须运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\validate_course.ps1
godot --headless --path . --rendering-method gl_compatibility --rendering-driver opengl3 --script res://tests/course_controls_smoke.gd
```

## 生成后检查日志

| 日期 | 题目 | 问题 | 根因 | 修复与守门 |
|---|---|---|---|---|
| 2026-08-20 | `prep_06_step_smooth` | 参考 Shader 固定蓝色通道为 `0.18`，题面只描述红、绿色通道，学习者无法推导完整目标；学习文件曾使用 `0.9` | 视觉验证比较完整 RGBA，但 README 没有完整数值表达式；首版断言还误放在主课循环 | README 增加完整公式和 `UV.x = 0.5` 的 `(1.0, 0.5, 0.18, 1.0)` 样例；规则改为 `visual_contract`；断言移到预科循环，并已完成旧题面失败、修复后通过的红绿验证 |
| 2026-08-20 | 主课 `05`、`06`、`07`、`08`、`09`、`11`、`12`、`14`、`16`、`17`、`18`、`19`、`20`、`21`、`22`、`23`、`24`、`27`、`28`、`29`、`30`、`31`、`32`，预科 `P02` | 多个参考 Shader 固定颜色、调色板或颜色 uniform 默认值，题面只写了冷色、暖色、深色等描述 | 视觉验证比较完整画面，但题面没有逐项暴露固定数值 | 各 README 增加 `固定数值目标`，`course/checks.json` 和 `course/prep_checks.json` 增加 `documentation_targets`，`validate_course.ps1` 逐项检查题面是否包含这些数值 |

以后发现同类问题时，先补这张日志，再补对应的验证断言。没有完整数值目标的题目，不得标记为生成完成。
