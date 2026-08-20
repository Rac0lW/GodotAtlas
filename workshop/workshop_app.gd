class_name WorkshopApp
extends Control

const CourseSessionScript = preload("res://workshop/course_session.gd")
const AtlasThemeScript = preload("res://workshop/atlas_theme.gd")
const AtlasButtonScript = preload("res://workshop/atlas_button.gd")
const MarkdownBBCodeScript = preload("res://workshop/markdown_bbcode.gd")
const CalibratedPreviewScript = preload("res://workshop/calibrated_preview.gd")
const PreviewFixtureScript = preload("res://workshop/preview_fixture.gd")

var session
var markdown
var reference_fixture
var learner_validation_fixture

var nav_panel: PanelContainer
var lesson_panel: PanelContainer
var nav_list: VBoxContainer
var nav_rows: Dictionary = {}
var prep_nav_rows: Dictionary = {}
var progress_bar: ProgressBar
var progress_count: Label
var prep_progress_count: Label
var asset_status_label: Label

var breadcrumb_label: Label
var source_path_label: Label
var exercise_meta_label: Label
var exercise_state_label: Label
var exercise_title_label: Label
var lesson_lead: RichTextLabel
var lesson_scroll: ScrollContainer
var lesson_sections: VBoxContainer
var hint_button: Button
var reset_button: Button
var global_reset_button: Button
var developer_mode_button: Button
var previous_button: Button
var next_button: Button
var reset_panel: PanelContainer
var reset_copy: Label
var global_reset_panel: PanelContainer
var global_reset_copy: Label

var preview_kind_label: Label
var calibrated_preview
var manual_panel: PanelContainer
var manual_list: VBoxContainer
var manual_checks: Array[CheckBox] = []
var status_panel: PanelContainer
var status_dot_style: StyleBoxFlat
var status_label: Label
var validate_button: Button
var solution_button: Button

var validation_busy := false
var reset_scope := ""


func _ready() -> void:
	theme = AtlasThemeScript.create()
	markdown = MarkdownBBCodeScript.new()
	_build_shell()
	_build_session()
	resized.connect(_apply_responsive_layout)
	_apply_responsive_layout()
	call_deferred("_initialize_session")


func _build_session() -> void:
	session = CourseSessionScript.new()
	add_child(session)
	session.exercise_changed.connect(_on_exercise_changed)
	session.source_external_changed.connect(_on_source_external_changed)
	session.progress_changed.connect(_on_progress_changed)
	session.session_error.connect(_on_session_error)
	session.session_ready.connect(_on_session_ready)
	session.developer_mode_changed.connect(_on_developer_mode_changed)

	reference_fixture = PreviewFixtureScript.new()
	reference_fixture.render_target_update_mode = SubViewport.UPDATE_DISABLED
	add_child(reference_fixture)
	learner_validation_fixture = PreviewFixtureScript.new()
	learner_validation_fixture.render_target_update_mode = SubViewport.UPDATE_DISABLED
	add_child(learner_validation_fixture)


func _initialize_session() -> void:
	_set_status("正在载入课程目录与本机进度", "pending")
	if not session.initialize():
		return
	_build_navigation()
	_refresh_progress()
	_refresh_navigation_state()


func _build_shell() -> void:
	var canvas := PanelContainer.new()
	canvas.theme_type_variation = "CanvasPanel"
	canvas.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(canvas)

	var shell := HBoxContainer.new()
	shell.add_theme_constant_override("separation", 0)
	canvas.add_child(shell)

	_build_navigation_panel(shell)
	_build_workspace(shell)


func _build_navigation_panel(parent: HBoxContainer) -> void:
	nav_panel = PanelContainer.new()
	nav_panel.theme_type_variation = "SidebarPanel"
	nav_panel.custom_minimum_size = Vector2(252.0, 0.0)
	nav_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(nav_panel)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 0)
	nav_panel.add_child(column)

	var brand_row := HBoxContainer.new()
	brand_row.add_theme_constant_override("separation", 12)
	var brand_signal := _make_dot(AtlasThemeScript.SIGNAL_AMBER, 10.0)
	brand_row.add_child(brand_signal)

	var brand_copy := VBoxContainer.new()
	brand_copy.add_theme_constant_override("separation", 2)
	var brand := Label.new()
	brand.text = "SHADER ATLAS"
	brand.theme_type_variation = "AppMark"
	brand_copy.add_child(brand)
	var brand_subtitle := Label.new()
	brand_subtitle.text = "GODOT GPU WORKSHOP"
	brand_subtitle.theme_type_variation = "MonoLabel"
	brand_copy.add_child(brand_subtitle)
	brand_row.add_child(brand_copy)
	column.add_child(_margin_wrap(brand_row, 16, 18, 16, 16))
	column.add_child(_make_divider())

	var progress_column := VBoxContainer.new()
	progress_column.add_theme_constant_override("separation", 8)
	var progress_header := HBoxContainer.new()
	var progress_title := Label.new()
	progress_title.text = "主课进度"
	progress_title.theme_type_variation = "SecondaryLabel"
	progress_header.add_child(progress_title)
	progress_header.add_spacer(false)
	progress_count = Label.new()
	progress_count.text = "00 / --"
	progress_count.theme_type_variation = "MonoLabel"
	progress_header.add_child(progress_count)
	progress_column.add_child(progress_header)
	progress_bar = ProgressBar.new()
	progress_bar.min_value = 0.0
	progress_bar.max_value = 0.0
	progress_bar.value = 0.0
	progress_bar.show_percentage = false
	progress_bar.custom_minimum_size = Vector2(0.0, 7.0)
	progress_column.add_child(progress_bar)
	var prep_progress_row := HBoxContainer.new()
	var prep_progress_title := Label.new()
	prep_progress_title.text = "预科入口"
	prep_progress_title.theme_type_variation = "MutedLabel"
	prep_progress_row.add_child(prep_progress_title)
	prep_progress_row.add_spacer(false)
	prep_progress_count = Label.new()
	prep_progress_count.text = "00 / --"
	prep_progress_count.theme_type_variation = "MonoLabel"
	prep_progress_row.add_child(prep_progress_count)
	progress_column.add_child(prep_progress_row)
	column.add_child(_margin_wrap(progress_column, 16, 14, 16, 14))
	column.add_child(_make_divider())
	var utility_row := HBoxContainer.new()
	utility_row.add_theme_constant_override("separation", 6)
	developer_mode_button = _new_button("DEV · OFF", "QuietButton")
	developer_mode_button.toggle_mode = true
	developer_mode_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	developer_mode_button.tooltip_text = "临时解除关卡前置限制，不修改完成记录"
	developer_mode_button.toggled.connect(_toggle_developer_mode)
	utility_row.add_child(developer_mode_button)
	global_reset_button = _new_button("重置全部", "QuietButton")
	global_reset_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	global_reset_button.tooltip_text = "备份全部练习代码，并从第 1 题重新开始"
	global_reset_button.pressed.connect(_arm_global_reset)
	utility_row.add_child(global_reset_button)
	column.add_child(_margin_wrap(utility_row, 10, 8, 10, 8))
	global_reset_panel = PanelContainer.new()
	global_reset_panel.theme_type_variation = "RaisedPanel"
	global_reset_panel.visible = false
	var global_reset_column := VBoxContainer.new()
	global_reset_column.add_theme_constant_override("separation", 8)
	global_reset_copy = Label.new()
	global_reset_copy.text = "备份主课与预科代码，清空进度与提示，回到主课第 1 题。"
	global_reset_copy.theme_type_variation = "SecondaryLabel"
	global_reset_copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	global_reset_column.add_child(global_reset_copy)
	var global_reset_actions := HBoxContainer.new()
	global_reset_actions.add_theme_constant_override("separation", 6)
	var cancel_global_reset := _new_button("取消", "QuietButton")
	cancel_global_reset.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cancel_global_reset.pressed.connect(_cancel_reset)
	global_reset_actions.add_child(cancel_global_reset)
	var confirm_global_reset := _new_button("确认全部重置", "DangerButton")
	confirm_global_reset.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	confirm_global_reset.pressed.connect(_confirm_global_reset)
	global_reset_actions.add_child(confirm_global_reset)
	global_reset_column.add_child(global_reset_actions)
	global_reset_panel.add_child(_margin_wrap(global_reset_column, 10, 9, 10, 9))
	column.add_child(_margin_wrap(global_reset_panel, 10, 0, 10, 8))
	column.add_child(_make_divider())

	var nav_scroll := ScrollContainer.new()
	nav_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	nav_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	nav_scroll.follow_focus = true
	column.add_child(nav_scroll)
	nav_list = VBoxContainer.new()
	nav_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav_list.add_theme_constant_override("separation", 2)
	nav_scroll.add_child(_margin_wrap(nav_list, 10, 12, 10, 12))

	column.add_child(_make_divider())
	var footer := VBoxContainer.new()
	footer.add_theme_constant_override("separation", 5)
	var engine_label := Label.new()
	engine_label.text = "GODOT 4.7.1 · FORWARD+"
	engine_label.theme_type_variation = "MonoLabel"
	footer.add_child(engine_label)
	asset_status_label = Label.new()
	asset_status_label.text = "正在检查私人素材"
	asset_status_label.theme_type_variation = "MutedLabel"
	footer.add_child(asset_status_label)
	column.add_child(_margin_wrap(footer, 16, 12, 16, 14))


func _build_workspace(parent: HBoxContainer) -> void:
	var work_column := VBoxContainer.new()
	work_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	work_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	work_column.add_theme_constant_override("separation", 0)
	parent.add_child(work_column)

	_build_top_bar(work_column)
	work_column.add_child(_make_divider())

	var split := HSplitContainer.new()
	split.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	split.size_flags_vertical = Control.SIZE_EXPAND_FILL
	split.add_theme_constant_override("separation", 1)
	work_column.add_child(split)

	_build_lesson_panel(split)
	_build_preview_panel(split)


func _build_top_bar(parent: VBoxContainer) -> void:
	var top_bar := PanelContainer.new()
	top_bar.theme_type_variation = "WorkPanel"
	top_bar.custom_minimum_size = Vector2(0.0, 56.0)
	parent.add_child(top_bar)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	breadcrumb_label = Label.new()
	breadcrumb_label.text = "M-- / --"
	breadcrumb_label.theme_type_variation = "AmberLabel"
	row.add_child(breadcrumb_label)
	row.add_spacer(false)
	source_path_label = Label.new()
	source_path_label.text = "正在定位 exercise.gdshader"
	source_path_label.theme_type_variation = "MonoLabel"
	source_path_label.clip_text = true
	source_path_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	source_path_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(source_path_label)
	var copy_button := _new_button("复制路径", "QuietButton")
	copy_button.tooltip_text = "复制当前 Shader 的绝对路径"
	copy_button.pressed.connect(_copy_source_path)
	row.add_child(copy_button)
	var open_button := _new_button("打开 Shader", "QuietButton")
	open_button.tooltip_text = "使用系统关联程序打开当前练习文件"
	open_button.pressed.connect(_open_source)
	row.add_child(open_button)
	top_bar.add_child(_margin_wrap(row, 16, 8, 16, 8))


func _build_lesson_panel(parent: HSplitContainer) -> void:
	lesson_panel = PanelContainer.new()
	lesson_panel.theme_type_variation = "WorkPanel"
	lesson_panel.custom_minimum_size = Vector2(456.0, 0.0)
	parent.add_child(lesson_panel)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	lesson_panel.add_child(_margin_wrap(column, 20, 18, 20, 16))

	var meta_row := HBoxContainer.new()
	exercise_meta_label = Label.new()
	exercise_meta_label.text = "MODULE -- · EXERCISE --"
	exercise_meta_label.theme_type_variation = "MonoLabel"
	meta_row.add_child(exercise_meta_label)
	meta_row.add_spacer(false)
	exercise_state_label = Label.new()
	exercise_state_label.text = "载入中"
	exercise_state_label.theme_type_variation = "AmberLabel"
	meta_row.add_child(exercise_state_label)
	column.add_child(meta_row)

	exercise_title_label = Label.new()
	exercise_title_label.text = "正在校准课程"
	exercise_title_label.theme_type_variation = "ExerciseTitle"
	exercise_title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(exercise_title_label)

	lesson_lead = RichTextLabel.new()
	lesson_lead.bbcode_enabled = true
	lesson_lead.fit_content = true
	lesson_lead.scroll_active = false
	lesson_lead.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lesson_lead.text = "读取目录、讲义与本机进度。"
	column.add_child(lesson_lead)
	column.add_child(_make_divider())

	lesson_scroll = ScrollContainer.new()
	lesson_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	lesson_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	lesson_scroll.follow_focus = true
	column.add_child(lesson_scroll)
	lesson_sections = VBoxContainer.new()
	lesson_sections.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lesson_sections.add_theme_constant_override("separation", 18)
	lesson_scroll.add_child(lesson_sections)

	reset_panel = PanelContainer.new()
	reset_panel.theme_type_variation = "RaisedPanel"
	reset_panel.visible = false
	column.add_child(reset_panel)
	var reset_row := HBoxContainer.new()
	reset_row.add_theme_constant_override("separation", 10)
	reset_copy = Label.new()
	reset_copy.text = "当前代码会先备份，再恢复 starter。"
	reset_copy.theme_type_variation = "SecondaryLabel"
	reset_copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	reset_copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	reset_row.add_child(reset_copy)
	var cancel_reset := _new_button("取消", "QuietButton")
	cancel_reset.pressed.connect(_cancel_reset)
	reset_row.add_child(cancel_reset)
	var confirm_reset := _new_button("确认重置", "DangerButton")
	confirm_reset.pressed.connect(_confirm_reset)
	reset_row.add_child(confirm_reset)
	reset_panel.add_child(_margin_wrap(reset_row, 12, 10, 12, 10))

	column.add_child(_make_divider())
	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 8)
	previous_button = _new_button("上一题", "QuietButton")
	previous_button.pressed.connect(_go_previous)
	action_row.add_child(previous_button)
	next_button = _new_button("下一题", "QuietButton")
	next_button.pressed.connect(_go_next)
	action_row.add_child(next_button)
	action_row.add_spacer(false)
	hint_button = _new_button("提示 0/3", "QuietButton")
	hint_button.tooltip_text = "逐级揭示提示，快捷键 H"
	hint_button.pressed.connect(_reveal_hint)
	action_row.add_child(hint_button)
	reset_button = _new_button("重置", "QuietButton")
	reset_button.tooltip_text = "进入可恢复的重置确认，快捷键 Ctrl+R"
	reset_button.pressed.connect(_arm_reset)
	action_row.add_child(reset_button)
	column.add_child(action_row)


func _build_preview_panel(parent: HSplitContainer) -> void:
	var preview_panel := PanelContainer.new()
	preview_panel.theme_type_variation = "CanvasPanel"
	preview_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(preview_panel)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	preview_panel.add_child(_margin_wrap(column, 16, 14, 16, 16))

	var heading := HBoxContainer.new()
	heading.add_theme_constant_override("separation", 8)
	heading.add_child(_make_dot(AtlasThemeScript.SIGNAL_AMBER, 7.0))
	var live_label := Label.new()
	live_label.text = "LIVE SIGNAL"
	live_label.theme_type_variation = "SectionHeading"
	heading.add_child(live_label)
	preview_kind_label = Label.new()
	preview_kind_label.text = "等待夹具"
	preview_kind_label.theme_type_variation = "MonoLabel"
	heading.add_child(preview_kind_label)
	heading.add_spacer(false)
	var reload_button := _new_button("重新载入", "QuietButton")
	reload_button.tooltip_text = "从磁盘重新载入当前 Shader"
	reload_button.pressed.connect(_reload_source)
	heading.add_child(reload_button)
	column.add_child(heading)

	calibrated_preview = CalibratedPreviewScript.new()
	calibrated_preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	calibrated_preview.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(calibrated_preview)

	manual_panel = PanelContainer.new()
	manual_panel.theme_type_variation = "RaisedPanel"
	manual_panel.visible = false
	column.add_child(manual_panel)
	manual_list = VBoxContainer.new()
	manual_list.add_theme_constant_override("separation", 6)
	manual_panel.add_child(_margin_wrap(manual_list, 12, 10, 12, 10))

	status_panel = PanelContainer.new()
	status_panel.theme_type_variation = "RaisedPanel"
	status_panel.custom_minimum_size = Vector2(0.0, 48.0)
	column.add_child(status_panel)
	var status_row := HBoxContainer.new()
	status_row.add_theme_constant_override("separation", 10)
	var status_dot := PanelContainer.new()
	status_dot.custom_minimum_size = Vector2(7.0, 7.0)
	status_dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	status_dot_style = _dot_style(AtlasThemeScript.TEXT_MUTED, 7.0)
	status_dot.add_theme_stylebox_override("panel", status_dot_style)
	status_row.add_child(status_dot)
	status_label = Label.new()
	status_label.text = "等待课程载入"
	status_label.theme_type_variation = "SecondaryLabel"
	status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status_label.clip_text = true
	status_row.add_child(status_label)
	status_panel.add_child(_margin_wrap(status_row, 12, 6, 12, 6))

	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 8)
	solution_button = _new_button("打开参考解答", "QuietButton")
	solution_button.tooltip_text = "在系统关联程序中打开独立参考解答"
	solution_button.pressed.connect(_open_solution)
	action_row.add_child(solution_button)
	action_row.add_spacer(false)
	validate_button = _new_button("运行验证  Ctrl+Enter", "PrimaryButton")
	validate_button.custom_minimum_size.x = 176.0
	validate_button.pressed.connect(_run_validation)
	action_row.add_child(validate_button)
	column.add_child(action_row)


func _build_navigation() -> void:
	_clear_children(nav_list)
	nav_rows.clear()
	prep_nav_rows.clear()
	for module_data in session.repository.prep_modules:
		_append_navigation_module(module_data, prep_nav_rows, "prep")
	for module_data in session.repository.modules:
		_append_navigation_module(module_data, nav_rows, "main")


func _append_navigation_module(module_data: Dictionary, rows: Dictionary, track: String) -> void:
	var module_header := HBoxContainer.new()
	module_header.add_theme_constant_override("separation", 8)
	var module_number := Label.new()
	module_number.text = "P%02d" % int(module_data.get("number", 0)) if track == "prep" else "%02d" % int(module_data.get("number", 0))
	module_number.theme_type_variation = "AmberLabel"
	module_header.add_child(module_number)
	var module_title := Label.new()
	module_title.text = module_data.get("title", "")
	module_title.theme_type_variation = "SectionHeading"
	module_header.add_child(module_title)
	nav_list.add_child(_margin_wrap(module_header, 6, 9, 6, 5))

	for exercise_data in module_data.get("exercises", []):
		var exercise_id: String = exercise_data.get("id", "")
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		var dot := PanelContainer.new()
		dot.custom_minimum_size = Vector2(6.0, 6.0)
		dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var dot_style := _dot_style(AtlasThemeScript.HAIRLINE, 6.0)
		dot.add_theme_stylebox_override("panel", dot_style)
		row.add_child(dot)

		var number_label := "P%02d" % int(exercise_data.get("number", 0)) if track == "prep" else "%02d" % int(exercise_data.get("number", 0))
		var button := _new_button("%s  %s" % [number_label, exercise_data.get("title", "")], "NavButton")
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.toggle_mode = true
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.tooltip_text = exercise_data.get("summary", "")
		if track == "prep":
			button.pressed.connect(_select_prep_exercise.bind(exercise_id))
		else:
			button.pressed.connect(_select_exercise.bind(exercise_id))
		row.add_child(button)
		nav_list.add_child(row)
		rows[exercise_id] = {"button": button, "dot_style": dot_style}


func _on_exercise_changed(entry: Dictionary, lesson: Dictionary, shader: Shader) -> void:
	var exercise_id: String = entry.get("id", "")
	var number: int = entry.get("number", 0)
	var is_prep: bool = session.current_track == "prep"
	var module_data: Dictionary = session.repository.get_prep_module_for(exercise_id) if is_prep else session.repository.get_module_for(exercise_id)
	breadcrumb_label.text = "PREP / %02d" % number if is_prep else "M%02d / %02d" % [int(module_data.get("number", 0)), number]
	source_path_label.text = str(entry.get("exercise_path", "")).trim_prefix("res://")
	source_path_label.tooltip_text = session.workspace.absolute_source_path()
	var total: int = session.repository.prep_exercises.size() if is_prep else session.repository.exercises.size()
	exercise_meta_label.text = "预科 · 练习 %02d / %02d" % [number, total] if is_prep else "MODULE %02d · EXERCISE %02d / %02d" % [int(module_data.get("number", 0)), number, total]
	exercise_title_label.text = entry.get("title", "")
	lesson_lead.text = markdown.body(lesson.get("lead", ""))
	preview_kind_label.text = "%s · 512²" % entry.get("preview", "canvas").to_upper()
	calibrated_preview.configure(entry.get("preview", "canvas"), shader, exercise_id)
	learner_validation_fixture.configure(entry.get("preview", "canvas"), shader, exercise_id)
	learner_validation_fixture.render_target_update_mode = SubViewport.UPDATE_DISABLED

	var solution_shader: Shader = session.workspace.solution_shader()
	reference_fixture.configure(entry.get("preview", "canvas"), solution_shader, exercise_id)
	reference_fixture.render_target_update_mode = SubViewport.UPDATE_DISABLED

	reset_scope = ""
	reset_panel.visible = false
	global_reset_panel.visible = false
	_render_lesson_sections()
	_build_manual_checklist()
	_refresh_navigation_state()
	_refresh_exercise_actions()
	_set_status("已载入当前 Shader，保存文件后会自动刷新", "neutral")


func _on_source_external_changed(shader: Shader) -> void:
	calibrated_preview.replace_shader(shader)
	learner_validation_fixture.replace_shader(shader)
	_set_status("检测到文件保存，实时画面已重新载入", "pending")


func _on_progress_changed(_progress: Dictionary) -> void:
	_refresh_progress()
	_refresh_navigation_state()
	_refresh_exercise_actions()

func _on_developer_mode_changed(enabled: bool) -> void:
	developer_mode_button.set_pressed_no_signal(enabled)
	developer_mode_button.text = "DEV · ON" if enabled else "DEV · OFF"
	developer_mode_button.theme_type_variation = "PrimaryButton" if enabled else "QuietButton"
	_refresh_navigation_state()
	_refresh_exercise_actions()


func _on_session_ready() -> void:
	var asset_status: Dictionary = session.private_assets.status()
	if asset_status.get("available", false):
		asset_status_label.text = "PRIVATE ASSETS · DETECTED"
		asset_status_label.theme_type_variation = "SuccessLabel"
	else:
		asset_status_label.text = "SELF-CONTAINED FIXTURES"
		asset_status_label.theme_type_variation = "MutedLabel"
	if session.progress.recovered_corrupt_save:
		_set_status("进度存档已恢复，损坏副本保留在 user://shader_atlas", "pending")


func _on_session_error(message: String) -> void:
	exercise_title_label.text = "课程无法载入"
	_set_status(message, "error")


func _render_lesson_sections() -> void:
	_clear_children(lesson_sections)
	for section in session.visible_lesson_sections():
		var is_hint: bool = section.get("kind", "body") == "hint"
		var section_column := VBoxContainer.new()
		section_column.add_theme_constant_override("separation", 8)
		var heading := Label.new()
		heading.text = section.get("heading", "")
		heading.theme_type_variation = "AmberLabel" if is_hint else "SectionHeading"
		section_column.add_child(heading)

		var body := RichTextLabel.new()
		body.bbcode_enabled = true
		body.fit_content = true
		body.scroll_active = false
		body.selection_enabled = true
		body.context_menu_enabled = true
		body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.text = markdown.body(section.get("body", ""))
		section_column.add_child(body)

		if is_hint:
			var hint_surface := PanelContainer.new()
			hint_surface.theme_type_variation = "RaisedPanel"
			hint_surface.add_child(_margin_wrap(section_column, 12, 10, 12, 11))
			lesson_sections.add_child(hint_surface)
		else:
			lesson_sections.add_child(section_column)
			lesson_sections.add_child(_make_divider())


func _build_manual_checklist() -> void:
	_clear_children(manual_list)
	manual_checks.clear()
	var checklist: Array = session.current_rule().get("manual_checklist", [])
	manual_panel.visible = not checklist.is_empty()
	if checklist.is_empty():
		return
	var heading := Label.new()
	heading.text = "观察清单"
	heading.theme_type_variation = "SectionHeading"
	manual_list.add_child(heading)
	for item in checklist:
		var check := CheckBox.new()
		check.text = str(item)
		check.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		check.focus_mode = Control.FOCUS_ALL
		manual_list.add_child(check)
		manual_checks.append(check)


func _refresh_progress() -> void:
	if session == null or session.progress.data.is_empty():
		return
	var count: int = session.progress.completion_count("main")
	var main_total: int = session.repository.exercises.size()
	var prep_total: int = session.repository.prep_exercises.size()
	progress_bar.max_value = main_total
	progress_bar.value = count
	progress_count.text = "%02d / %02d" % [count, main_total]
	prep_progress_count.text = "%02d / %02d" % [session.progress.completion_count("prep"), prep_total]


func _refresh_navigation_state() -> void:
	if session == null or session.current_entry.is_empty():
		return
	var current_id: String = session.current_entry.get("id", "")
	_refresh_navigation_rows(nav_rows, "main", current_id)
	_refresh_navigation_rows(prep_nav_rows, "prep", current_id)


func _refresh_navigation_rows(rows: Dictionary, track: String, current_id: String) -> void:
	for exercise_id in rows:
		var row: Dictionary = rows[exercise_id]
		var button: Button = row.button
		var dot_style: StyleBoxFlat = row.dot_style
		var is_current: bool = session.current_track == track and exercise_id == current_id
		var is_complete: bool = session.progress.is_complete(exercise_id, track)
		var is_locked: bool = session.is_locked(exercise_id, track)
		button.set_pressed_no_signal(is_current)
		button.disabled = is_locked and not is_current
		if is_current:
			dot_style.bg_color = AtlasThemeScript.SIGNAL_AMBER
		elif is_complete:
			dot_style.bg_color = AtlasThemeScript.PASS_GREEN
		elif is_locked:
			dot_style.bg_color = Color(AtlasThemeScript.HAIRLINE, 0.45)
		else:
			dot_style.bg_color = AtlasThemeScript.HAIRLINE


func _refresh_exercise_actions() -> void:
	if session == null or session.current_entry.is_empty():
		return
	var exercise_id: String = session.current_entry.get("id", "")
	var is_complete: bool = session.progress.is_complete(exercise_id, session.current_track)
	exercise_state_label.text = "已通过" if is_complete else "进行中"
	exercise_state_label.theme_type_variation = "SuccessLabel" if is_complete else "AmberLabel"

	var revealed: int = session.progress.get_revealed_hint_count(exercise_id, session.current_track)
	var total: int = session.current_lesson.get("hints", []).size()
	hint_button.text = "提示 %d/%d" % [revealed, total]
	hint_button.disabled = revealed >= total

	var previous: Dictionary = session.previous_exercise()
	var next: Dictionary = session.next_exercise()
	previous_button.disabled = previous.is_empty()
	next_button.disabled = next.is_empty() or session.is_locked(next.get("id", ""), session.current_track)


func _select_exercise(exercise_id: String) -> void:
	if validation_busy:
		return
	session.select_exercise(exercise_id)


func _select_prep_exercise(exercise_id: String) -> void:
	if validation_busy:
		return
	session.select_prep_exercise(exercise_id)


func _go_previous() -> void:
	var entry: Dictionary = session.previous_exercise()
	if not entry.is_empty():
		if session.current_track == "prep":
			session.select_prep_exercise(entry.get("id", ""), false)
		else:
			session.select_exercise(entry.get("id", ""), false)


func _go_next() -> void:
	var entry: Dictionary = session.next_exercise()
	if not entry.is_empty() and not session.is_locked(entry.get("id", ""), session.current_track):
		if session.current_track == "prep":
			session.select_prep_exercise(entry.get("id", ""))
		else:
			session.select_exercise(entry.get("id", ""))


func _reveal_hint() -> void:
	if session == null or session.current_entry.is_empty():
		return
	var result: Dictionary = session.reveal_hint()
	_render_lesson_sections()
	_refresh_exercise_actions()
	_set_status("已揭示提示 %d / %d" % [result.get("revealed", 0), result.get("total", 0)], "pending")
	await get_tree().process_frame
	lesson_scroll.scroll_vertical = int(lesson_sections.size.y)


func _arm_reset() -> void:
	if reset_scope == "current":
		return
	reset_scope = "current"
	reset_panel.visible = true
	reset_copy.text = "将恢复本题 starter，当前代码会先备份到 user://shader_atlas/backups。"
	_set_status("本题重置尚未执行，请在讲义下方确认", "error")


func _arm_global_reset() -> void:
	if validation_busy or reset_scope == "all":
		return
	reset_scope = "all"
	reset_panel.visible = false
	global_reset_panel.visible = true
	_set_status("全局重置尚未执行，请在左侧栏确认", "error")


func _cancel_reset() -> void:
	reset_scope = ""
	reset_panel.visible = false
	global_reset_panel.visible = false
	_set_status("已取消重置，课程代码与进度均未改变", "neutral")


func _confirm_reset() -> void:
	var result: Dictionary = session.reset_current()
	reset_scope = ""
	reset_panel.visible = false
	if result.get("ok", false):
		_set_status("已恢复 starter，旧代码保存在本机备份目录", "pending")
	else:
		_set_status(result.get("error", "无法重置当前练习"), "error")


func _confirm_global_reset() -> void:
	var result: Dictionary = session.reset_all()
	reset_scope = ""
	reset_panel.visible = false
	global_reset_panel.visible = false
	if result.get("ok", false):
		_set_status("已备份全部练习并从第 1 题重新开始", "pending")
	else:
		_set_status(result.get("error", "无法重置课程"), "error")

func _toggle_developer_mode(enabled: bool) -> void:
	if session == null:
		return
	session.set_developer_mode(enabled)
	if enabled:
		_set_status("开发者模式已开启，可跳转全部关卡，完成记录保持不变", "pending")
	else:
		_set_status("开发者模式已关闭，关卡前置限制已恢复", "neutral")


func _reload_source() -> void:
	if session == null or session.current_entry.is_empty():
		return
	var shader: Shader = session.workspace.reload_current()
	calibrated_preview.replace_shader(shader)
	learner_validation_fixture.replace_shader(shader)
	_set_status("已从磁盘重新载入当前 Shader", "pending")


func _run_validation() -> void:
	if validation_busy or session == null or session.current_entry.is_empty():
		return
	validation_busy = true
	validate_button.disabled = true
	calibrated_preview.play_scan()
	_set_status("正在渲染学习版本与参考版本", "pending")

	var rule: Dictionary = session.current_rule()
	var mode: String = rule.get("mode", "visual")
	var visual_result: Dictionary = {"passed": true}
	if mode.contains("visual"):
		learner_validation_fixture.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		reference_fixture.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		var settle_frames: int = rule.get("visual", {}).get("settle_frames", 4)
		for _frame in range(settle_frames):
			await get_tree().process_frame
		await RenderingServer.frame_post_draw
		visual_result = session.current_validation().compare_images(
			session.current_entry.get("id", ""),
			_actual_validation_snapshot(),
			reference_fixture.snapshot()
		)
		learner_validation_fixture.render_target_update_mode = SubViewport.UPDATE_DISABLED
		reference_fixture.render_target_update_mode = SubViewport.UPDATE_DISABLED

	var combined: Dictionary = session.complete_validation(visual_result, _manual_is_confirmed())
	if combined.get("passed", false):
		_set_status("验证通过，下一题已解锁", "success")
		_fade_in_status()
	else:
		var failures: Array = combined.get("failures", [])
		var message: String = failures[0] if not failures.is_empty() else "验证尚未通过。"
		if mode.contains("visual") and not visual_result.get("passed", false) and visual_result.has("mean_error"):
			message = "%s 平均画面差异 %.1f%%。" % [message.trim_suffix("。"), float(visual_result.mean_error) * 100.0]
		_set_status(message, "error")

	validation_busy = false
	validate_button.disabled = false
	_refresh_progress()
	_refresh_navigation_state()
	_refresh_exercise_actions()


func _actual_validation_snapshot() -> Image:
	return learner_validation_fixture.snapshot()


func _actual_validation_fixture():
	return learner_validation_fixture


func _manual_is_confirmed() -> bool:
	for check in manual_checks:
		if not check.button_pressed:
			return false
	return true


func _copy_source_path() -> void:
	if session == null or session.current_entry.is_empty():
		return
	DisplayServer.clipboard_set(session.workspace.absolute_source_path())
	_set_status("当前 Shader 路径已复制", "neutral")


func _open_source() -> void:
	if session == null or session.current_entry.is_empty():
		return
	OS.shell_open(session.workspace.absolute_source_path())


func _open_solution() -> void:
	if session == null or session.current_entry.is_empty():
		return
	var path: String = session.current_entry.get("solution_path", "")
	OS.shell_open(ProjectSettings.globalize_path(path))


func _set_status(message: String, state: String) -> void:
	if status_label == null:
		return
	status_label.text = message
	match state:
		"success":
			status_dot_style.bg_color = AtlasThemeScript.PASS_GREEN
			status_label.theme_type_variation = "SuccessLabel"
		"error":
			status_dot_style.bg_color = AtlasThemeScript.FAULT_CORAL
			status_label.theme_type_variation = "FaultLabel"
		"pending":
			status_dot_style.bg_color = AtlasThemeScript.SIGNAL_AMBER
			status_label.theme_type_variation = "AmberLabel"
		_:
			status_dot_style.bg_color = AtlasThemeScript.TEXT_MUTED
			status_label.theme_type_variation = "SecondaryLabel"


func _fade_in_status() -> void:
	status_panel.modulate.a = 0.0
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(status_panel, "modulate:a", 1.0, 0.18)


func _apply_responsive_layout() -> void:
	if nav_panel == null or lesson_panel == null:
		return
	if size.x < 1400.0:
		nav_panel.custom_minimum_size.x = 224.0
		lesson_panel.custom_minimum_size.x = 400.0
	else:
		nav_panel.custom_minimum_size.x = 252.0
		lesson_panel.custom_minimum_size.x = 456.0


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.ctrl_pressed and event.keycode in [KEY_ENTER, KEY_KP_ENTER]:
		_run_validation()
		get_viewport().set_input_as_handled()
	elif event.ctrl_pressed and event.keycode == KEY_R:
		_arm_reset()
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_ESCAPE and not reset_scope.is_empty():
		_cancel_reset()
		get_viewport().set_input_as_handled()
	elif event.alt_pressed and event.keycode == KEY_LEFT:
		_go_previous()
		get_viewport().set_input_as_handled()
	elif event.alt_pressed and event.keycode == KEY_RIGHT:
		_go_next()
		get_viewport().set_input_as_handled()
	elif not event.ctrl_pressed and not event.alt_pressed and event.keycode == KEY_H:
		_reveal_hint()
		get_viewport().set_input_as_handled()


func _new_button(label: String, variation: StringName) -> Button:
	var button := AtlasButtonScript.new()
	button.text = label
	button.theme_type_variation = variation
	button.custom_minimum_size = Vector2(0.0, 40.0)
	return button


func _margin_wrap(child: Control, left: int, top: int, right: int, bottom: int) -> MarginContainer:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", left)
	margin.add_theme_constant_override("margin_top", top)
	margin.add_theme_constant_override("margin_right", right)
	margin.add_theme_constant_override("margin_bottom", bottom)
	margin.add_child(child)
	return margin


func _make_divider() -> ColorRect:
	var divider := ColorRect.new()
	divider.color = AtlasThemeScript.HAIRLINE
	divider.custom_minimum_size = Vector2(0.0, 1.0)
	divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return divider


func _make_dot(color: Color, diameter: float) -> PanelContainer:
	var dot := PanelContainer.new()
	dot.custom_minimum_size = Vector2(diameter, diameter)
	dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	dot.add_theme_stylebox_override("panel", _dot_style(color, diameter))
	return dot


func _dot_style(color: Color, diameter: float) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	var radius := int(ceilf(diameter * 0.5))
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	return style


func _clear_children(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()
