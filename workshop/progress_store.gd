class_name ProgressStore
extends RefCounted

const SCHEMA_VERSION := 1
const COURSE_ID := "shader_atlas_zh"
const SAVE_PATH := "user://shader_atlas/progress.json"

var save_path := SAVE_PATH
var data: Dictionary = {}
var recovered_corrupt_save := false


func _init(custom_save_path: String = "") -> void:
	if not custom_save_path.is_empty():
		save_path = custom_save_path


func load_progress(default_exercise_id: String, default_prep_id: String = "") -> Dictionary:
	recovered_corrupt_save = false
	if not FileAccess.file_exists(save_path):
		data = _new_data(default_exercise_id, default_prep_id)
		save()
		return data

	var raw := FileAccess.get_file_as_string(save_path)
	var parsed: Variant = JSON.parse_string(raw)
	if not (parsed is Dictionary) or parsed.get("schema_version", 0) != SCHEMA_VERSION:
		_backup_corrupt(raw)
		data = _new_data(default_exercise_id, default_prep_id)
		recovered_corrupt_save = true
		save()
		return data

	data = parsed
	_normalize(default_exercise_id, default_prep_id)
	return data


func save() -> bool:
	_ensure_data_root()
	data["updated_at"] = Time.get_datetime_string_from_system(true)
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		push_error("无法保存课程进度：%s" % FileAccess.get_open_error())
		return false
	file.store_string(JSON.stringify(data, "\t", false))
	return true


func backup_to(directory: String) -> bool:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(directory))
	var path := directory.path_join("progress.json")
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(data, "\t", false))
	return true


func reset_all(default_exercise_id: String, default_prep_id: String = "") -> bool:
	var previous_data := data
	data = _new_data(default_exercise_id, default_prep_id)
	if save():
		return true
	data = previous_data
	return false


func set_current(exercise_id: String, track: String = "main") -> void:
	data[_key("current_id", track)] = exercise_id
	data["current_track"] = track
	save()


func mark_complete(exercise_id: String, track: String = "main") -> void:
	var completed: Array = data.get(_key("completed", track), [])
	if exercise_id not in completed:
		completed.append(exercise_id)
	data[_key("completed", track)] = completed
	save()


func mark_incomplete(exercise_id: String, track: String = "main") -> void:
	var completed: Array = data.get(_key("completed", track), [])
	completed.erase(exercise_id)
	data[_key("completed", track)] = completed
	save()


func is_complete(exercise_id: String, track: String = "main") -> bool:
	return exercise_id in data.get(_key("completed", track), [])


func reveal_next_hint(exercise_id: String, total_hints: int, track: String = "main") -> int:
	var hints: Dictionary = data.get(_key("hints_revealed", track), {})
	var count: int = hints.get(exercise_id, 0)
	count = mini(count + 1, total_hints)
	hints[exercise_id] = count
	data[_key("hints_revealed", track)] = hints
	save()
	return count


func get_revealed_hint_count(exercise_id: String, track: String = "main") -> int:
	return data.get(_key("hints_revealed", track), {}).get(exercise_id, 0)


func completion_count(track: String = "main") -> int:
	return data.get(_key("completed", track), []).size()


func _new_data(default_exercise_id: String, default_prep_id: String) -> Dictionary:
	var now := Time.get_datetime_string_from_system(true)
	return {
		"schema_version": SCHEMA_VERSION,
		"course_id": COURSE_ID,
		"current_id": default_exercise_id,
		"current_track": "main",
		"prep_current_id": default_prep_id,
		"completed": [],
		"prep_completed": [],
		"hints_revealed": {},
		"prep_hints_revealed": {},
		"started_at": now,
		"updated_at": now
	}


func _normalize(default_exercise_id: String, default_prep_id: String) -> void:
	data["schema_version"] = SCHEMA_VERSION
	data["course_id"] = COURSE_ID
	var current_id: Variant = data.get("current_id", "")
	if not (current_id is String) or current_id.is_empty():
		data["current_id"] = default_exercise_id
	var current_track: Variant = data.get("current_track", "main")
	if current_track not in ["main", "prep"]:
		data["current_track"] = "main"
	var prep_current_id: Variant = data.get("prep_current_id", "")
	if not (prep_current_id is String) or prep_current_id.is_empty():
		data["prep_current_id"] = default_prep_id
	if not (data.get("completed", []) is Array):
		data["completed"] = []
	if not (data.get("prep_completed", []) is Array):
		data["prep_completed"] = []
	if not (data.get("hints_revealed", {}) is Dictionary):
		data["hints_revealed"] = {}
	if not (data.get("prep_hints_revealed", {}) is Dictionary):
		data["prep_hints_revealed"] = {}
	if not data.has("started_at"):
		data["started_at"] = Time.get_datetime_string_from_system(true)


func _backup_corrupt(raw: String) -> void:
	_ensure_data_root()
	var stamp := Time.get_datetime_string_from_system().replace(":", "-")
	var path := "%s/progress-corrupt-%s.json" % [save_path.get_base_dir(), stamp]
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file != null:
		file.store_string(raw)


func _ensure_data_root() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(save_path.get_base_dir()))


func _key(base: String, track: String) -> String:
	return base if track != "prep" else "prep_%s" % base
