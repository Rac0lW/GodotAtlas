class_name MarkdownBBCode
extends RefCounted

const INLINE_CODE_COLOR := "#F0A23A"
const STRONG_COLOR := "#E7E2D6"

var _code_regex := RegEx.new()
var _strong_regex := RegEx.new()


func _init() -> void:
	_code_regex.compile("`([^`]+)`")
	_strong_regex.compile("\\*\\*([^*]+)\\*\\*")


func body(markdown: String) -> String:
	var output: PackedStringArray = []
	for raw_line in markdown.replace("\r\n", "\n").split("\n"):
		var line := raw_line.strip_edges(false, true)
		if line.begins_with("- "):
			output.append("[indent]• %s[/indent]" % _inline(line.trim_prefix("- ")))
		elif line.begins_with("### "):
			output.append("[b][color=%s]%s[/color][/b]" % [STRONG_COLOR, _inline(line.trim_prefix("### "))])
		else:
			output.append(_inline(line))
	return "\n".join(output).strip_edges()


func _inline(value: String) -> String:
	var safe := value.replace("[", "[lb]").replace("]", "[rb]")
	safe = _strong_regex.sub(safe, "[b][color=%s]$1[/color][/b]" % STRONG_COLOR, true)
	safe = _code_regex.sub(safe, "[color=%s][code]$1[/code][/color]" % INLINE_CODE_COLOR, true)
	return safe
