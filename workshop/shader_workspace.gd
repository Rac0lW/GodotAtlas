class_name ShaderWorkspace
extends RefCounted

signal source_reloaded(shader: Shader, source_code: String)
signal source_changed_on_disk

const BACKUP_ROOT := "user://shader_atlas/backups"

var exercise_id := ""
var source_path := ""
var starter_path := ""
var solution_path := ""
var last_modified_time := 0


func open_exercise(entry: Dictionary) -> bool:
	exercise_id = entry.get("id", "")
	source_path = entry.get("exercise_path", "")
	starter_path = entry.get("starter_path", "")
	solution_path = entry.get("solution_path", "")
	if not FileAccess.file_exists(source_path):
		return false
	last_modified_time = FileAccess.get_modified_time(source_path)
	return true


func current_source() -> String:
	return _read(source_path)


func starter_source() -> String:
	return _read(starter_path)


func solution_source() -> String:
	return _read(solution_path)


func reload_current() -> Shader:
	var code := current_source()
	var shader := Shader.new()
	shader.code = code
	last_modified_time = FileAccess.get_modified_time(source_path)
	source_reloaded.emit(shader, code)
	return shader


func solution_shader() -> Shader:
	var shader := Shader.new()
	shader.code = solution_source()
	return shader


func poll_external_change() -> bool:
	if source_path.is_empty() or not FileAccess.file_exists(source_path):
		return false
	var modified := FileAccess.get_modified_time(source_path)
	if modified > last_modified_time:
		last_modified_time = modified
		source_changed_on_disk.emit()
		return true
	return false


func reset_to_starter() -> Dictionary:
	var starter := starter_source()
	if starter.is_empty():
		return {"ok": false, "error": "缺少起始快照：%s" % starter_path}
	var backup_path := _backup_current()
	var file := FileAccess.open(source_path, FileAccess.WRITE)
	if file == null:
		return {"ok": false, "error": "无法写入：%s" % source_path}
	file.store_string(starter)
	last_modified_time = FileAccess.get_modified_time(source_path)
	return {"ok": true, "backup_path": backup_path}


func absolute_source_path() -> String:
	return ProjectSettings.globalize_path(source_path)


func _backup_current() -> String:
	var current := current_source()
	if current.is_empty():
		return ""
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(BACKUP_ROOT))
	var stamp := Time.get_datetime_string_from_system().replace(":", "-")
	var path := "%s/%s-%s.gdshader.txt" % [BACKUP_ROOT, exercise_id, stamp]
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file != null:
		file.store_string(current)
		return path
	return ""


static func _read(path: String) -> String:
	if path.is_empty() or not FileAccess.file_exists(path):
		return ""
	return FileAccess.get_file_as_string(path)
