class_name ProgressStore
extends RefCounted

const SCHEMA_VERSION := 1
const COURSE_ID := "shader_atlas_zh"
const SAVE_PATH := "user://shader_atlas/progress.json"
const DATA_ROOT := "user://shader_atlas"

var data: Dictionary = {}
var recovered_corrupt_save := false


func load_progress(default_exercise_id: String) -> Dictionary:
	recovered_corrupt_save = false
	if not FileAccess.file_exists(SAVE_PATH):
		data = _new_data(default_exercise_id)
		save()
		return data

	var raw := FileAccess.get_file_as_string(SAVE_PATH)
	var parsed: Variant = JSON.parse_string(raw)
	if not (parsed is Dictionary) or parsed.get("schema_version", 0) != SCHEMA_VERSION:
		_backup_corrupt(raw)
		data = _new_data(default_exercise_id)
		recovered_corrupt_save = true
		save()
		return data

	data = parsed
	_normalize(default_exercise_id)
	return data


func save() -> bool:
	_ensure_data_root()
	data["updated_at"] = Time.get_datetime_string_from_system(true)
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("无法保存课程进度：%s" % FileAccess.get_open_error())
		return false
	file.store_string(JSON.stringify(data, "\t", false))
	return true


func set_current(exercise_id: String) -> void:
	data["current_id"] = exercise_id
	save()


func mark_complete(exercise_id: String) -> void:
	var completed: Array = data.get("completed", [])
	if exercise_id not in completed:
		completed.append(exercise_id)
	data["completed"] = completed
	save()


func mark_incomplete(exercise_id: String) -> void:
	var completed: Array = data.get("completed", [])
	completed.erase(exercise_id)
	data["completed"] = completed
	save()


func is_complete(exercise_id: String) -> bool:
	return exercise_id in data.get("completed", [])


func reveal_next_hint(exercise_id: String, total_hints: int) -> int:
	var hints: Dictionary = data.get("hints_revealed", {})
	var count: int = hints.get(exercise_id, 0)
	count = mini(count + 1, total_hints)
	hints[exercise_id] = count
	data["hints_revealed"] = hints
	save()
	return count


func get_revealed_hint_count(exercise_id: String) -> int:
	return data.get("hints_revealed", {}).get(exercise_id, 0)


func completion_count() -> int:
	return data.get("completed", []).size()


func _new_data(default_exercise_id: String) -> Dictionary:
	var now := Time.get_datetime_string_from_system(true)
	return {
		"schema_version": SCHEMA_VERSION,
		"course_id": COURSE_ID,
		"current_id": default_exercise_id,
		"completed": [],
		"hints_revealed": {},
		"started_at": now,
		"updated_at": now
	}


func _normalize(default_exercise_id: String) -> void:
	data["schema_version"] = SCHEMA_VERSION
	data["course_id"] = COURSE_ID
	var current_id: Variant = data.get("current_id", "")
	if not (current_id is String):
		data["current_id"] = default_exercise_id
	elif current_id.is_empty():
		data["current_id"] = default_exercise_id
	if not (data.get("completed", []) is Array):
		data["completed"] = []
	if not (data.get("hints_revealed", {}) is Dictionary):
		data["hints_revealed"] = {}
	if not data.has("started_at"):
		data["started_at"] = Time.get_datetime_string_from_system(true)


func _backup_corrupt(raw: String) -> void:
	_ensure_data_root()
	var stamp := Time.get_datetime_string_from_system().replace(":", "-")
	var path := "%s/progress-corrupt-%s.json" % [DATA_ROOT, stamp]
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file != null:
		file.store_string(raw)


func _ensure_data_root() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(DATA_ROOT))
