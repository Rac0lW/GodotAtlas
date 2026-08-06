class_name LessonParser
extends RefCounted


func parse(markdown: String) -> Dictionary:
	var result := {
		"title": "",
		"lead": "",
		"sections": [],
		"hints": []
	}
	var current_heading := ""
	var current_lines: PackedStringArray = []
	var lead_lines: PackedStringArray = []

	for line in markdown.replace("\r\n", "\n").split("\n"):
		if line.begins_with("# ") and result.title.is_empty():
			result.title = line.trim_prefix("# ").strip_edges()
			continue
		if line.begins_with("## "):
			_flush_section(result, current_heading, current_lines)
			current_heading = line.trim_prefix("## ").strip_edges()
			current_lines.clear()
			continue
		if current_heading.is_empty():
			lead_lines.append(line)
		else:
			current_lines.append(line)

	_flush_section(result, current_heading, current_lines)
	result.lead = "\n".join(lead_lines).strip_edges()
	return result


func visible_sections(parsed: Dictionary, revealed_hint_count: int) -> Array:
	var visible: Array = []
	var shown_hints := 0
	for section in parsed.get("sections", []):
		if section.get("kind", "body") == "hint":
			shown_hints += 1
			if shown_hints > revealed_hint_count:
				continue
		visible.append(section)
	return visible


static func _flush_section(result: Dictionary, heading: String, lines: PackedStringArray) -> void:
	if heading.is_empty():
		return
	var body := "\n".join(lines).strip_edges()
	var kind := "hint" if heading.begins_with("提示") else "body"
	var section := {"heading": heading, "body": body, "kind": kind}
	result.sections.append(section)
	if kind == "hint":
		result.hints.append(body)
