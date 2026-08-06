class_name AtlasButton
extends Button

var _press_tween: Tween


func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	resized.connect(_update_pivot)
	_update_pivot()


func _exit_tree() -> void:
	if _press_tween != null:
		_press_tween.kill()


func _on_button_down() -> void:
	_animate_scale(Vector2(0.96, 0.96), 0.07)


func _on_button_up() -> void:
	_animate_scale(Vector2.ONE, 0.12)


func _animate_scale(target: Vector2, duration: float) -> void:
	if _press_tween != null:
		_press_tween.kill()
	_press_tween = create_tween()
	_press_tween.set_trans(Tween.TRANS_QUART)
	_press_tween.set_ease(Tween.EASE_OUT)
	_press_tween.tween_property(self, "scale", target, duration)


func _update_pivot() -> void:
	pivot_offset = size * 0.5
