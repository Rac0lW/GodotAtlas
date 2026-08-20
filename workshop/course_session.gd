class_name CourseSession
extends Node

signal session_ready
signal exercise_changed(entry: Dictionary, lesson: Dictionary, shader: Shader)
signal source_external_changed(shader: Shader)
signal progress_changed(progress: Dictionary)
signal session_error(message: String)
signal developer_mode_changed(enabled: bool)

const PREP_CHECKS_PATH := "res://course/prep_checks.json"

var repository := CourseRepository.new()
var progress := ProgressStore.new()
var workspace := ShaderWorkspace.new()
var validation := ValidationRegistry.new()
var prep_validation := ValidationRegistry.new()
var lesson_parser := LessonParser.new()
var private_assets := PrivateAssetResolver.new()

var current_entry: Dictionary = {}
var current_lesson: Dictionary = {}
var current_track := "main"
var developer_mode := false


func _ready() -> void:
	set_process(false)


func initialize() -> bool:
	if not repository.load_course():
		session_error.emit(repository.last_error)
		return false
	if not validation.load_checks():
		session_error.emit(validation.last_error)
		return false
	if not prep_validation.load_checks(PREP_CHECKS_PATH):
		session_error.emit(prep_validation.last_error)
		return false

	var first_id: String = repository.get_exercise_at(0).get("id", "")
	var first_prep_id: String = repository.get_prep_exercise_at(0).get("id", "")
	var saved := progress.load_progress(first_id, first_prep_id)
	var saved_track: String = saved.get("current_track", "main")
	var restored_track := false
	if saved_track == "prep" and not repository.get_prep_exercise(saved.get("prep_current_id", first_prep_id)).is_empty():
		if not select_prep_exercise(saved.get("prep_current_id", first_prep_id), false):
			return false
		restored_track = true
	if not restored_track:
		var current_id: String = saved.get("current_id", first_id)
		if repository.get_exercise(current_id).is_empty():
			current_id = first_id
			progress.set_current(current_id, "main")
		if not select_exercise(current_id, false):
			return false
	set_process(true)
	session_ready.emit()
	return true


func _process(_delta: float) -> void:
	if workspace.poll_external_change():
		var shader := workspace.reload_current()
		source_external_changed.emit(shader)


func select_exercise(exercise_id: String, enforce_prerequisite: bool = true) -> bool:
	var entry := repository.get_exercise(exercise_id)
	if entry.is_empty():
		session_error.emit("未知练习：%s" % exercise_id)
		return false
	if enforce_prerequisite and is_locked(exercise_id, "main"):
		session_error.emit("请先完成前置练习。")
		return false
	return _select_entry(entry, "main")


func select_prep_exercise(exercise_id: String, enforce_prerequisite: bool = true) -> bool:
	var entry := repository.get_prep_exercise(exercise_id)
	if entry.is_empty():
		session_error.emit("未知预科练习：%s" % exercise_id)
		return false
	if enforce_prerequisite and is_locked(exercise_id, "prep"):
		session_error.emit("请先完成前一个预科练习。")
		return false
	return _select_entry(entry, "prep")


func next_exercise() -> Dictionary:
	if current_track == "prep":
		var prep_index := repository.get_prep_index(current_entry.get("id", ""))
		return repository.get_prep_exercise_at(prep_index + 1)
	var index := repository.get_index(current_entry.get("id", ""))
	return repository.get_exercise_at(index + 1)


func previous_exercise() -> Dictionary:
	if current_track == "prep":
		var prep_index := repository.get_prep_index(current_entry.get("id", ""))
		return repository.get_prep_exercise_at(prep_index - 1)
	var index := repository.get_index(current_entry.get("id", ""))
	return repository.get_exercise_at(index - 1)


func reveal_hint() -> Dictionary:
	var exercise_id: String = current_entry.get("id", "")
	var hints: Array = current_lesson.get("hints", [])
	var count := progress.reveal_next_hint(exercise_id, hints.size(), current_track)
	progress_changed.emit(progress.data)
	return {
		"revealed": count,
		"total": hints.size(),
		"hint": hints[count - 1] if count > 0 else ""
	}


func reset_current() -> Dictionary:
	var result := workspace.reset_to_starter()
	if result.get("ok", false):
		var shader := workspace.reload_current()
		exercise_changed.emit(current_entry, current_lesson, shader)
	return result


func reset_all() -> Dictionary:
	var first_id: String = repository.get_exercise_at(0).get("id", "")
	var first_prep_id: String = repository.get_prep_exercise_at(0).get("id", "")
	if first_id.is_empty():
		return {"ok": false, "error": "课程目录中没有可重置的练习。"}

	var all_entries: Array = repository.exercises.duplicate()
	all_entries.append_array(repository.prep_exercises)
	var backup_result := workspace.create_backup_directory()
	if not backup_result.get("ok", false):
		return backup_result
	var backup_directory: String = backup_result.get("backup_directory", "")
	if not progress.backup_to(backup_directory):
		return {"ok": false, "error": "无法备份课程进度：%s" % backup_directory}

	var source_result := workspace.reset_all_to_starters(all_entries, backup_directory)
	if not source_result.get("ok", false):
		return source_result

	if not progress.reset_all(first_id, first_prep_id):
		var restore_result := workspace.restore_all_from_backup(all_entries, backup_directory)
		var suffix := "" if restore_result.get("ok", false) else "，练习源码回滚也失败，请从备份目录恢复"
		return {"ok": false, "error": "无法清空课程进度%s" % suffix}

	set_developer_mode(false)
	if not select_exercise(first_id, false):
		return {"ok": false, "error": "全局重置完成，但无法载入第一题。"}
	progress_changed.emit(progress.data)
	return {"ok": true, "backup_directory": backup_directory}


func contract_result() -> Dictionary:
	return current_validation().check_contracts(current_entry.get("id", ""), workspace.current_source())


func complete_validation(visual_result: Dictionary, manual_confirmed: bool) -> Dictionary:
	var exercise_id: String = current_entry.get("id", "")
	var combined := current_validation().combine_results(exercise_id, visual_result, contract_result(), manual_confirmed)
	if combined.get("passed", false):
		progress.mark_complete(exercise_id, current_track)
		progress_changed.emit(progress.data)
	return combined


func set_developer_mode(enabled: bool) -> void:
	if developer_mode == enabled:
		return
	developer_mode = enabled
	developer_mode_changed.emit(developer_mode)


func current_validation() -> ValidationRegistry:
	return prep_validation if current_track == "prep" else validation


func current_rule() -> Dictionary:
	return current_validation().get_rule(current_entry.get("id", ""))


func is_locked(exercise_id: String, track: String = "main") -> bool:
	if developer_mode:
		return false
	if track == "prep":
		var prep_entry := repository.get_prep_exercise(exercise_id)
		return not _prerequisite_is_met(prep_entry, progress.data.get("prep_completed", []))
	var main_entry := repository.get_exercise(exercise_id)
	return not _prerequisite_is_met(main_entry, progress.data.get("completed", []))


func visible_lesson_sections() -> Array:
	var count := progress.get_revealed_hint_count(current_entry.get("id", ""), current_track)
	return lesson_parser.visible_sections(current_lesson, count)


func _select_entry(entry: Dictionary, track: String) -> bool:
	if not workspace.open_exercise(entry):
		session_error.emit("缺少练习 Shader：%s" % entry.get("exercise_path", ""))
		return false

	current_entry = entry
	current_track = track
	current_lesson = lesson_parser.parse(repository.read_lesson_for_entry(entry))
	progress.set_current(entry.get("id", ""), track)
	var shader := workspace.reload_current()
	exercise_changed.emit(current_entry, current_lesson, shader)
	return true


func _prerequisite_is_met(entry: Dictionary, completed_ids: Array) -> bool:
	var prerequisite: String = entry.get("prerequisite", "")
	return prerequisite.is_empty() or prerequisite in completed_ids
