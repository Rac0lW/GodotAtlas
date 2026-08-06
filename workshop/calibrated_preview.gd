class_name CalibratedPreview
extends PanelContainer

const FRAME_MARGIN := 28.0

var fixture: PreviewFixture
var texture_rect: TextureRect
var overlay: CalibrationOverlay
var scan_line: ColorRect
var _scan_tween: Tween


class CalibrationOverlay:
	extends Control

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		resized.connect(queue_redraw)

	func _draw() -> void:
		var line_color := Color("26323a")
		var signal_color := Color("f0a23a")
		var inset := 19.0
		var left := inset
		var top := inset
		var right := size.x - inset
		var bottom := size.y - inset
		var corner := 12.0

		draw_line(Vector2(left, top), Vector2(left + corner, top), signal_color, 1.0)
		draw_line(Vector2(left, top), Vector2(left, top + corner), signal_color, 1.0)
		draw_line(Vector2(right, top), Vector2(right - corner, top), signal_color, 1.0)
		draw_line(Vector2(right, top), Vector2(right, top + corner), signal_color, 1.0)
		draw_line(Vector2(left, bottom), Vector2(left + corner, bottom), signal_color, 1.0)
		draw_line(Vector2(left, bottom), Vector2(left, bottom - corner), signal_color, 1.0)
		draw_line(Vector2(right, bottom), Vector2(right - corner, bottom), signal_color, 1.0)
		draw_line(Vector2(right, bottom), Vector2(right, bottom - corner), signal_color, 1.0)

		for index in range(1, 10):
			var ratio := float(index) / 10.0
			var tick := 5.0 if index % 5 == 0 else 3.0
			var x := lerpf(left, right, ratio)
			var y := lerpf(top, bottom, ratio)
			draw_line(Vector2(x, top), Vector2(x, top + tick), line_color, 1.0)
			draw_line(Vector2(x, bottom), Vector2(x, bottom - tick), line_color, 1.0)
			draw_line(Vector2(left, y), Vector2(left + tick, y), line_color, 1.0)
			draw_line(Vector2(right, y), Vector2(right - tick, y), line_color, 1.0)

		var font := ThemeDB.fallback_font
		draw_string(font, Vector2(left + 7.0, top + 16.0), "0,0", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 10, Color(signal_color, 0.78))
		draw_string(font, Vector2(right - 31.0, bottom - 8.0), "1,1", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 10, Color(signal_color, 0.78))


func _ready() -> void:
	theme_type_variation = "PreviewInstrument"
	clip_contents = true
	custom_minimum_size = Vector2(360.0, 360.0)

	var stage := Control.new()
	stage.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(stage)

	fixture = PreviewFixture.new()
	stage.add_child(fixture)

	texture_rect = TextureRect.new()
	texture_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	texture_rect.offset_left = FRAME_MARGIN
	texture_rect.offset_top = FRAME_MARGIN
	texture_rect.offset_right = -FRAME_MARGIN
	texture_rect.offset_bottom = -FRAME_MARGIN
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(texture_rect)
	texture_rect.texture = fixture.get_texture()

	overlay = CalibrationOverlay.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	stage.add_child(overlay)

	scan_line = ColorRect.new()
	scan_line.color = Color("f0a23a")
	scan_line.modulate.a = 0.0
	scan_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scan_line.visible = false
	stage.add_child(scan_line)
	resized.connect(_layout_scan_line)
	_layout_scan_line()


func configure(kind: String, shader: Shader, exercise_id: String) -> void:
	fixture.configure(kind, shader, exercise_id)
	texture_rect.texture = fixture.get_texture()


func replace_shader(shader: Shader) -> void:
	fixture.replace_shader(shader)


func snapshot() -> Image:
	return fixture.snapshot()


func play_scan() -> void:
	if _scan_tween != null:
		_scan_tween.kill()
	_layout_scan_line()
	scan_line.visible = true
	scan_line.modulate.a = 0.0
	scan_line.position.y = FRAME_MARGIN

	_scan_tween = create_tween()
	_scan_tween.set_trans(Tween.TRANS_QUART)
	_scan_tween.set_ease(Tween.EASE_OUT)
	_scan_tween.tween_property(scan_line, "modulate:a", 0.72, 0.08)
	_scan_tween.tween_property(scan_line, "position:y", maxf(FRAME_MARGIN, size.y - FRAME_MARGIN - 2.0), 0.52)
	_scan_tween.tween_property(scan_line, "modulate:a", 0.0, 0.14)
	_scan_tween.finished.connect(func() -> void: scan_line.visible = false)


func _layout_scan_line() -> void:
	if scan_line == null:
		return
	scan_line.position.x = FRAME_MARGIN
	scan_line.size = Vector2(maxf(0.0, size.x - FRAME_MARGIN * 2.0), 2.0)
