class_name CourseSession
extends Node

signal session_ready
signal exercise_changed(entry: Dictionary, lesson: Dictionary, shader: Shader)
signal source_external_changed(shader: Shader)
signal progress_changed(progress: Dictionary)
signal session_error(message: String)

var repository := CourseRepository.new()
var progress := ProgressStore.new()
var workspace := ShaderWorkspace.new()
var validation := ValidationRegistry.new()
var lesson_parser := LessonParser.new()
var private_assets := PrivateAssetResolver.new()

var current_entry: Dictionary = {}
var current_lesson: Dictionary = {}


func _ready() -> void:
	set_process(false)


func initialize() -> bool:
	if not repository.load_course():
		session_error.emit(repository.last_error)
		return false
	if not validation.load_checks():
		session_error.emit(validation.last_error)
		return false

	var first_id: String = repository.get_exercise_at(0).get("id", "")
	var saved := progress.load_progress(first_id)
	var current_id: String = saved.get("current_id", first_id)
	if repository.get_exercise(current_id).is_empty():
		current_id = first_id
		progress.set_current(current_id)

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
	if enforce_prerequisite and not repository.prerequisite_is_met(exercise_id, progress.data.get("completed", [])):
		session_error.emit("请先完成前置练习。")
		return false
	if not workspace.open_exercise(entry):
		session_error.emit("缺少练习 Shader：%s" % entry.get("exercise_path", ""))
		return false

	current_entry = entry
	current_lesson = lesson_parser.parse(repository.read_lesson(exercise_id))
	progress.set_current(exercise_id)
	var shader := workspace.reload_current()
	exercise_changed.emit(current_entry, current_lesson, shader)
	return true


func next_exercise() -> Dictionary:
	var index := repository.get_index(current_entry.get("id", ""))
	return repository.get_exercise_at(index + 1)


func previous_exercise() -> Dictionary:
	var index := repository.get_index(current_entry.get("id", ""))
	return repository.get_exercise_at(index - 1)


func reveal_hint() -> Dictionary:
	var exercise_id: String = current_entry.get("id", "")
	var hints: Array = current_lesson.get("hints", [])
	var count := progress.reveal_next_hint(exercise_id, hints.size())
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


func contract_result() -> Dictionary:
	return validation.check_contracts(current_entry.get("id", ""), workspace.current_source())


func complete_validation(visual_result: Dictionary, manual_confirmed: bool) -> Dictionary:
	var exercise_id: String = current_entry.get("id", "")
	var combined := validation.combine_results(exercise_id, visual_result, contract_result(), manual_confirmed)
	if combined.get("passed", false):
		progress.mark_complete(exercise_id)
		progress_changed.emit(progress.data)
	return combined


func current_rule() -> Dictionary:
	return validation.get_rule(current_entry.get("id", ""))


func is_locked(exercise_id: String) -> bool:
	return not repository.prerequisite_is_met(exercise_id, progress.data.get("completed", []))


func visible_lesson_sections() -> Array:
	var count := progress.get_revealed_hint_count(current_entry.get("id", ""))
	return lesson_parser.visible_sections(current_lesson, count)
