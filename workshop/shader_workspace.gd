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

func create_backup_directory(root: String = BACKUP_ROOT) -> Dictionary:
	var stamp := Time.get_datetime_string_from_system().replace(":", "-")
	var directory := root.path_join("global-reset-%s-%d" % [stamp, Time.get_ticks_msec()])
	var error := DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(directory))
	if error != OK:
		return {"ok": false, "error": "无法创建全局重置备份目录：%s" % directory}
	return {"ok": true, "backup_directory": directory}


func reset_all_to_starters(entries: Array, backup_directory: String) -> Dictionary:
	var snapshots: Array[Dictionary] = []
	for entry in entries:
		var item: Dictionary = entry
		var item_id: String = item.get("id", "")
		var item_source_path: String = item.get("exercise_path", "")
		var item_starter_path: String = item.get("starter_path", "")
		var current := _read(item_source_path)
		var starter := _read(item_starter_path)
		if item_id.is_empty() or current.is_empty():
			return {"ok": false, "error": "无法读取练习源码：%s" % item_source_path}
		if starter.is_empty():
			return {"ok": false, "error": "缺少起始快照：%s" % item_starter_path}
		snapshots.append({
			"id": item_id,
			"source_path": item_source_path,
			"current": current,
			"starter": starter
		})

	for snapshot in snapshots:
		var backup_path := backup_directory.path_join("%s.gdshader.txt" % snapshot.get("id", ""))
		if not _write(backup_path, snapshot.get("current", "")):
			return {"ok": false, "error": "无法备份练习源码：%s" % backup_path}

	for snapshot in snapshots:
		if not _write(snapshot.get("source_path", ""), snapshot.get("starter", "")):
			var rollback_ok := _restore_snapshots(snapshots)
			var suffix := "" if rollback_ok else "，且自动回滚失败，请从备份目录恢复"
			return {"ok": false, "error": "无法恢复起始快照：%s%s" % [snapshot.get("source_path", ""), suffix]}

	_refresh_current_modified_time()
	return {"ok": true, "backup_directory": backup_directory}


func restore_all_from_backup(entries: Array, backup_directory: String) -> Dictionary:
	var snapshots: Array[Dictionary] = []
	for entry in entries:
		var item: Dictionary = entry
		var item_id: String = item.get("id", "")
		var backup_path := backup_directory.path_join("%s.gdshader.txt" % item_id)
		var backup_source := _read(backup_path)
		if backup_source.is_empty():
			return {"ok": false, "error": "缺少全局重置备份：%s" % backup_path}
		snapshots.append({
			"source_path": item.get("exercise_path", ""),
			"current": backup_source
		})

	if not _restore_snapshots(snapshots):
		return {"ok": false, "error": "无法从备份目录恢复全部练习：%s" % backup_directory}
	_refresh_current_modified_time()
	return {"ok": true}


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

func _restore_snapshots(snapshots: Array[Dictionary]) -> bool:
	var restored_all := true
	for snapshot in snapshots:
		if not _write(snapshot.get("source_path", ""), snapshot.get("current", "")):
			restored_all = false
	return restored_all


func _refresh_current_modified_time() -> void:
	if not source_path.is_empty() and FileAccess.file_exists(source_path):
		last_modified_time = FileAccess.get_modified_time(source_path)


static func _write(path: String, content: String) -> bool:
	if path.is_empty():
		return false
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(content)
	return true


static func _read(path: String) -> String:
	if path.is_empty() or not FileAccess.file_exists(path):
		return ""
	return FileAccess.get_file_as_string(path)
