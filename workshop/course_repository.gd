class_name CourseRepository
extends RefCounted

const CATALOG_PATH := "res://course/catalog.json"
const PREP_CATALOG_PATH := "res://course/prep_catalog.json"
const CHECKS_PATH := "res://course/checks.json"
const EXERCISES_ROOT := "res://exercises"
const SOLUTIONS_ROOT := "res://solutions"
const PREP_EXERCISES_ROOT := "res://prep/exercises"
const PREP_SOLUTIONS_ROOT := "res://prep/solutions"

var catalog: Dictionary = {}
var modules: Array = []
var exercises: Array = []
var exercise_by_id: Dictionary = {}
var module_by_exercise_id: Dictionary = {}
var prep_catalog: Dictionary = {}
var prep_modules: Array = []
var prep_exercises: Array = []
var prep_exercise_by_id: Dictionary = {}
var prep_module_by_exercise_id: Dictionary = {}
var last_error := ""


func load_course() -> bool:
	last_error = ""
	modules.clear()
	exercises.clear()
	exercise_by_id.clear()
	module_by_exercise_id.clear()
	prep_modules.clear()
	prep_exercises.clear()
	prep_exercise_by_id.clear()
	prep_module_by_exercise_id.clear()

	var parsed := _read_json(CATALOG_PATH)
	if not parsed.get("ok", false):
		last_error = parsed.get("error", "无法读取课程索引。")
		return false

	catalog = parsed.data
	_append_catalog(catalog, false)

	var prep_parsed := _read_json(PREP_CATALOG_PATH)
	if prep_parsed.get("ok", false):
		prep_catalog = prep_parsed.data
		_append_catalog(prep_catalog, true)

	return not exercises.is_empty()


func get_exercise(exercise_id: String) -> Dictionary:
	return exercise_by_id.get(exercise_id, {})


func get_exercise_at(index: int) -> Dictionary:
	if index < 0 or index >= exercises.size():
		return {}
	return exercises[index]


func get_index(exercise_id: String) -> int:
	for index in range(exercises.size()):
		if exercises[index].get("id", "") == exercise_id:
			return index
	return -1


func get_module_for(exercise_id: String) -> Dictionary:
	return module_by_exercise_id.get(exercise_id, {})


func get_prep_exercise(exercise_id: String) -> Dictionary:
	return prep_exercise_by_id.get(exercise_id, {})


func get_prep_exercise_at(index: int) -> Dictionary:
	if index < 0 or index >= prep_exercises.size():
		return {}
	return prep_exercises[index]


func get_prep_index(exercise_id: String) -> int:
	for index in range(prep_exercises.size()):
		if prep_exercises[index].get("id", "") == exercise_id:
			return index
	return -1


func get_prep_module_for(exercise_id: String) -> Dictionary:
	return prep_module_by_exercise_id.get(exercise_id, {})


func read_lesson(exercise_id: String, language: String = "zh") -> String:
	return _read_text(_localized_readme_path(readme_path(exercise_id), language))


func read_lesson_for_entry(entry: Dictionary, language: String = "zh") -> String:
	return _read_text(_localized_readme_path(entry.get("readme_path", ""), language))


func read_current_shader(exercise_id: String) -> String:
	return _read_text(exercise_path(exercise_id))


func read_solution_shader(exercise_id: String) -> String:
	return _read_text(solution_path(exercise_id))


func extract_hints(exercise_id: String, language: String = "zh") -> Array[String]:
	var hints: Array[String] = []
	var lesson := read_lesson(exercise_id, language)
	var collecting := false
	var buffer: PackedStringArray = []

	for line in lesson.split("\n"):
		if line.begins_with("## 提示") or line.begins_with("## Hint"):
			if collecting and not buffer.is_empty():
				hints.append("\n".join(buffer).strip_edges())
			buffer.clear()
			collecting = true
			continue
		if collecting and line.begins_with("## "):
			if not buffer.is_empty():
				hints.append("\n".join(buffer).strip_edges())
			buffer.clear()
			collecting = false
			continue
		if collecting:
			buffer.append(line)

	if collecting and not buffer.is_empty():
		hints.append("\n".join(buffer).strip_edges())
	return hints


func prerequisite_is_met(exercise_id: String, completed_ids: Array) -> bool:
	var entry := get_exercise(exercise_id)
	var prerequisite: String = entry.get("prerequisite", "")
	return prerequisite.is_empty() or prerequisite in completed_ids


static func readme_path(exercise_id: String) -> String:
	return "%s/%s/README.md" % [EXERCISES_ROOT, exercise_id]


static func exercise_path(exercise_id: String) -> String:
	return "%s/%s/exercise.gdshader" % [EXERCISES_ROOT, exercise_id]


static func starter_path(exercise_id: String) -> String:
	return "%s/%s/starter.gdshader.txt" % [EXERCISES_ROOT, exercise_id]


static func solution_path(exercise_id: String) -> String:
	return "%s/%s.gdshader" % [SOLUTIONS_ROOT, exercise_id]


static func _localized_readme_path(path: String, language: String) -> String:
	if language == "en":
		var english_path := path.trim_suffix(".md") + ".en.md"
		if FileAccess.file_exists(english_path):
			return english_path
	return path


static func _read_text(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""
	return FileAccess.get_file_as_string(path)


func _append_catalog(source: Dictionary, is_prep: bool) -> void:
	var target_modules: Array = prep_modules if is_prep else modules
	var target_exercises: Array = prep_exercises if is_prep else exercises
	var target_by_id: Dictionary = prep_exercise_by_id if is_prep else exercise_by_id
	var target_modules_by_id: Dictionary = prep_module_by_exercise_id if is_prep else module_by_exercise_id
	for module_data in source.get("modules", []):
		if not (module_data is Dictionary):
			continue
		target_modules.append(module_data)
		for exercise_data in module_data.get("exercises", []):
			if not (exercise_data is Dictionary):
				continue
			var entry: Dictionary = exercise_data.duplicate(true)
			var exercise_id: String = entry.get("id", "")
			entry["module_id"] = module_data.get("id", "")
			entry["module_title"] = module_data.get("title", "")
			if is_prep:
				entry["readme_path"] = "res://prep/exercises/%s/README.md" % exercise_id
				entry["exercise_path"] = "%s/%s/exercise.gdshader" % [PREP_EXERCISES_ROOT, exercise_id]
				entry["starter_path"] = "%s/%s/starter.gdshader.txt" % [PREP_EXERCISES_ROOT, exercise_id]
				entry["solution_path"] = "%s/%s.gdshader" % [PREP_SOLUTIONS_ROOT, exercise_id]
			else:
				entry["readme_path"] = readme_path(exercise_id)
				entry["exercise_path"] = exercise_path(exercise_id)
				entry["starter_path"] = starter_path(exercise_id)
				entry["solution_path"] = solution_path(exercise_id)
			target_exercises.append(entry)
			target_by_id[exercise_id] = entry
			target_modules_by_id[exercise_id] = module_data


static func _read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {"ok": false, "error": "缺少文件：%s" % path}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not (parsed is Dictionary):
		return {"ok": false, "error": "JSON 格式无效：%s" % path}
	return {"ok": true, "data": parsed}
