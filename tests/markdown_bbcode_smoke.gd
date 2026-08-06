extends SceneTree

const MarkdownBBCodeScript = preload("res://workshop/markdown_bbcode.gd")

var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var renderer = MarkdownBBCodeScript.new()
	var label := RichTextLabel.new()
	label.bbcode_enabled = true
	get_root().add_child(label)

	_check_bbcode(label, "[code]MODEL_MATRIX[3][/code]", "MODEL_MATRIX[3]")
	_check_bbcode(label, "普通 [lb]方括号[rb]", "普通 [方括号]")
	_check_render(label, renderer, "范围 `[-1, 1]`", "范围 [-1, 1]")
	_check_render(label, renderer, "矩阵 `MODEL_MATRIX[3]`", "矩阵 MODEL_MATRIX[3]")
	_check_render(label, renderer, "普通 [方括号]", "普通 [方括号]")

	label.free()
	if failures.is_empty():
		print("MARKDOWN_BBCODE_SMOKE_OK bracket_code=pass plain_brackets=pass")
		quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("MARKDOWN_BBCODE_SMOKE_FAILED count=%d" % failures.size())
	quit(1)

func _check_bbcode(label: RichTextLabel, bbcode: String, expected: String) -> void:
	label.text = bbcode
	var actual := label.get_parsed_text()
	if actual != expected:
		failures.append("BBCode probe expected '%s', got '%s'" % [expected, actual])


func _check_render(label: RichTextLabel, renderer, markdown: String, expected: String) -> void:
	label.text = renderer.body(markdown)
	var actual := label.get_parsed_text()
	if actual != expected:
		failures.append("expected '%s', got '%s'" % [expected, actual])
