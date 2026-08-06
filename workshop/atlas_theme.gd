class_name AtlasTheme
extends RefCounted

const CANVAS_INK := Color("080b0e")
const SIDEBAR_INK := Color("0d1115")
const WORK_SURFACE := Color("11171c")
const RAISED_SURFACE := Color("172027")
const RAISED_HOVER := Color("1d2830")
const HAIRLINE := Color("26323a")
const TEXT_PRIMARY := Color("e7e2d6")
const TEXT_SECONDARY := Color("a3aaa8")
const TEXT_MUTED := Color("69747a")
const SIGNAL_AMBER := Color("f0a23a")
const SIGNAL_BRIGHT := Color("ffb54f")
const PASS_GREEN := Color("70c697")
const FAULT_CORAL := Color("df7466")

const RADIUS_1 := 4
const RADIUS_2 := 8
const RADIUS_3 := 12


static func create() -> Theme:
	var theme := Theme.new()
	var ui_font := _system_font(["Bahnschrift", "Microsoft YaHei UI", "Microsoft YaHei"])
	var mono_font := _system_font(["Cascadia Mono", "Sarasa Mono SC", "Microsoft YaHei UI"])
	theme.default_font = ui_font
	theme.default_font_size = 13

	theme.set_color("font_color", "Label", TEXT_PRIMARY)
	theme.set_color("font_shadow_color", "Label", Color.TRANSPARENT)
	theme.set_font("font", "Label", ui_font)
	theme.set_font_size("font_size", "Label", 13)

	theme.set_color("default_color", "RichTextLabel", TEXT_PRIMARY)
	theme.set_color("font_outline_color", "RichTextLabel", Color.TRANSPARENT)
	theme.set_font("normal_font", "RichTextLabel", ui_font)
	theme.set_font("bold_font", "RichTextLabel", ui_font)
	theme.set_font("mono_font", "RichTextLabel", mono_font)
	theme.set_font_size("normal_font_size", "RichTextLabel", 15)
	theme.set_font_size("bold_font_size", "RichTextLabel", 15)
	theme.set_font_size("mono_font_size", "RichTextLabel", 13)
	theme.set_constant("line_separation", "RichTextLabel", 7)
	theme.set_stylebox("normal", "RichTextLabel", _empty_box(0))

	_configure_panels(theme)
	_configure_buttons(theme)
	_configure_scrollbars(theme)
	_configure_progress(theme)
	_configure_checkboxes(theme)

	theme.set_type_variation("AppMark", "Label")
	theme.set_font_size("font_size", "AppMark", 18)
	theme.set_color("font_color", "AppMark", TEXT_PRIMARY)

	theme.set_type_variation("ExerciseTitle", "Label")
	theme.set_font_size("font_size", "ExerciseTitle", 28)
	theme.set_color("font_color", "ExerciseTitle", TEXT_PRIMARY)

	theme.set_type_variation("SectionHeading", "Label")
	theme.set_font_size("font_size", "SectionHeading", 15)
	theme.set_color("font_color", "SectionHeading", TEXT_PRIMARY)

	theme.set_type_variation("SecondaryLabel", "Label")
	theme.set_color("font_color", "SecondaryLabel", TEXT_SECONDARY)

	theme.set_type_variation("MutedLabel", "Label")
	theme.set_color("font_color", "MutedLabel", TEXT_MUTED)

	theme.set_type_variation("AmberLabel", "Label")
	theme.set_color("font_color", "AmberLabel", SIGNAL_AMBER)

	theme.set_type_variation("SuccessLabel", "Label")
	theme.set_color("font_color", "SuccessLabel", PASS_GREEN)

	theme.set_type_variation("FaultLabel", "Label")
	theme.set_color("font_color", "FaultLabel", FAULT_CORAL)

	theme.set_type_variation("MonoLabel", "Label")
	theme.set_font("font", "MonoLabel", mono_font)
	theme.set_font_size("font_size", "MonoLabel", 12)
	theme.set_color("font_color", "MonoLabel", TEXT_SECONDARY)

	return theme


static func _configure_panels(theme: Theme) -> void:
	theme.set_stylebox("panel", "PanelContainer", _flat_box(WORK_SURFACE, 0))
	_register_panel(theme, "CanvasPanel", CANVAS_INK, 0)
	_register_panel(theme, "SidebarPanel", SIDEBAR_INK, 0)
	_register_panel(theme, "WorkPanel", WORK_SURFACE, 0)
	_register_panel(theme, "RaisedPanel", RAISED_SURFACE, RADIUS_2)
	_register_panel(theme, "PreviewInstrument", CANVAS_INK, RADIUS_3, 1, HAIRLINE)


static func _configure_buttons(theme: Theme) -> void:
	var focus := _flat_box(Color.TRANSPARENT, RADIUS_1, 1, SIGNAL_BRIGHT)
	focus.expand_margin_left = 2
	focus.expand_margin_top = 2
	focus.expand_margin_right = 2
	focus.expand_margin_bottom = 2

	theme.set_stylebox("normal", "Button", _flat_box(RAISED_SURFACE, RADIUS_1))
	theme.set_stylebox("hover", "Button", _flat_box(RAISED_HOVER, RADIUS_1))
	theme.set_stylebox("pressed", "Button", _flat_box(RAISED_HOVER, RADIUS_1))
	theme.set_stylebox("disabled", "Button", _flat_box(Color(RAISED_SURFACE, 0.45), RADIUS_1))
	theme.set_stylebox("focus", "Button", focus)
	_set_button_colors(theme, "Button", TEXT_PRIMARY, TEXT_PRIMARY, TEXT_PRIMARY, TEXT_MUTED)
	theme.set_constant("outline_size", "Button", 0)
	theme.set_font_size("font_size", "Button", 13)

	_register_button(theme, "PrimaryButton", SIGNAL_AMBER, SIGNAL_BRIGHT, CANVAS_INK, CANVAS_INK)
	_register_button(theme, "DangerButton", FAULT_CORAL, Color("ee8879"), CANVAS_INK, CANVAS_INK)

	theme.set_type_variation("QuietButton", "Button")
	theme.set_stylebox("normal", "QuietButton", _flat_box(Color.TRANSPARENT, RADIUS_1))
	theme.set_stylebox("hover", "QuietButton", _flat_box(RAISED_SURFACE, RADIUS_1))
	theme.set_stylebox("pressed", "QuietButton", _flat_box(RAISED_HOVER, RADIUS_1))
	theme.set_stylebox("disabled", "QuietButton", _flat_box(Color.TRANSPARENT, RADIUS_1))
	theme.set_stylebox("focus", "QuietButton", focus)
	_set_button_colors(theme, "QuietButton", TEXT_SECONDARY, TEXT_PRIMARY, TEXT_PRIMARY, TEXT_MUTED)

	theme.set_type_variation("NavButton", "Button")
	theme.set_stylebox("normal", "NavButton", _flat_box(Color.TRANSPARENT, RADIUS_1))
	theme.set_stylebox("hover", "NavButton", _flat_box(RAISED_SURFACE, RADIUS_1))
	theme.set_stylebox("pressed", "NavButton", _flat_box(RAISED_HOVER, RADIUS_1))
	theme.set_stylebox("disabled", "NavButton", _flat_box(Color.TRANSPARENT, RADIUS_1))
	theme.set_stylebox("focus", "NavButton", focus)
	_set_button_colors(theme, "NavButton", TEXT_SECONDARY, TEXT_PRIMARY, TEXT_PRIMARY, TEXT_MUTED)
	theme.set_constant("h_separation", "NavButton", 8)


static func _configure_scrollbars(theme: Theme) -> void:
	var transparent := _flat_box(Color.TRANSPARENT, RADIUS_1)
	var grabber := _flat_box(HAIRLINE, RADIUS_1)
	var grabber_hover := _flat_box(TEXT_MUTED, RADIUS_1)
	theme.set_stylebox("scroll", "VScrollBar", transparent)
	theme.set_stylebox("scroll_focus", "VScrollBar", transparent)
	theme.set_stylebox("grabber", "VScrollBar", grabber)
	theme.set_stylebox("grabber_highlight", "VScrollBar", grabber_hover)
	theme.set_stylebox("grabber_pressed", "VScrollBar", grabber_hover)
	theme.set_constant("minimum_grab_thickness", "VScrollBar", 24)


static func _configure_progress(theme: Theme) -> void:
	theme.set_stylebox("background", "ProgressBar", _flat_box(CANVAS_INK, RADIUS_1))
	theme.set_stylebox("fill", "ProgressBar", _flat_box(SIGNAL_AMBER, RADIUS_1))
	theme.set_color("font_color", "ProgressBar", TEXT_PRIMARY)
	theme.set_color("font_outline_color", "ProgressBar", CANVAS_INK)
	theme.set_font_size("font_size", "ProgressBar", 11)


static func _configure_checkboxes(theme: Theme) -> void:
	theme.set_color("font_color", "CheckBox", TEXT_SECONDARY)
	theme.set_color("font_hover_color", "CheckBox", TEXT_PRIMARY)
	theme.set_color("font_pressed_color", "CheckBox", TEXT_PRIMARY)
	theme.set_color("font_disabled_color", "CheckBox", TEXT_MUTED)
	theme.set_constant("h_separation", "CheckBox", 10)
	theme.set_font_size("font_size", "CheckBox", 13)


static func _register_panel(theme: Theme, variation: StringName, color: Color, radius: int, border_width: int = 0, border_color: Color = Color.TRANSPARENT) -> void:
	theme.set_type_variation(variation, "PanelContainer")
	theme.set_stylebox("panel", variation, _flat_box(color, radius, border_width, border_color))


static func _register_button(theme: Theme, variation: StringName, normal_color: Color, hover_color: Color, font_color: Color, hover_font_color: Color) -> void:
	theme.set_type_variation(variation, "Button")
	theme.set_stylebox("normal", variation, _flat_box(normal_color, RADIUS_1))
	theme.set_stylebox("hover", variation, _flat_box(hover_color, RADIUS_1))
	theme.set_stylebox("pressed", variation, _flat_box(hover_color, RADIUS_1))
	theme.set_stylebox("disabled", variation, _flat_box(Color(normal_color, 0.35), RADIUS_1))
	theme.set_stylebox("focus", variation, _flat_box(Color.TRANSPARENT, RADIUS_1, 1, SIGNAL_BRIGHT))
	_set_button_colors(theme, variation, font_color, hover_font_color, hover_font_color, Color(font_color, 0.42))


static func _set_button_colors(theme: Theme, type_name: StringName, normal: Color, hover: Color, pressed: Color, disabled: Color) -> void:
	theme.set_color("font_color", type_name, normal)
	theme.set_color("font_hover_color", type_name, hover)
	theme.set_color("font_pressed_color", type_name, pressed)
	theme.set_color("font_focus_color", type_name, hover)
	theme.set_color("font_disabled_color", type_name, disabled)


static func _system_font(names: Array[String]) -> SystemFont:
	var font := SystemFont.new()
	font.font_names = PackedStringArray(names)
	font.antialiasing = TextServer.FONT_ANTIALIASING_GRAY
	font.generate_mipmaps = true
	return font


static func _flat_box(color: Color, radius: int, border_width: int = 0, border_color: Color = Color.TRANSPARENT) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.corner_radius_top_left = radius
	box.corner_radius_top_right = radius
	box.corner_radius_bottom_left = radius
	box.corner_radius_bottom_right = radius
	box.border_width_left = border_width
	box.border_width_top = border_width
	box.border_width_right = border_width
	box.border_width_bottom = border_width
	box.border_color = border_color
	return box


static func _empty_box(margin: float) -> StyleBoxEmpty:
	var box := StyleBoxEmpty.new()
	box.content_margin_left = margin
	box.content_margin_top = margin
	box.content_margin_right = margin
	box.content_margin_bottom = margin
	return box
