extends SceneTree

const CourseSessionScript = preload("res://workshop/course_session.gd")
const ProgressStoreScript = preload("res://workshop/progress_store.gd")
const ShaderWorkspaceScript = preload("res://workshop/shader_workspace.gd")

var failures: Array[String] = []
var temp_root := ""


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	temp_root = "user://shader_atlas-control-smoke-%d" % Time.get_ticks_msec()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(temp_root))
	_test_global_reset()
	_test_developer_mode()
	_remove_tree(temp_root)

	if failures.is_empty():
		print("COURSE_CONTROLS_SMOKE_OK global_reset=pass developer_mode=pass")
		quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("COURSE_CONTROLS_SMOKE_FAILED count=%d" % failures.size())
	quit(1)


func _test_global_reset() -> void:
	var fixture_root := temp_root.path_join("reset")
	var first_source := fixture_root.path_join("01/exercise.gdshader")
	var first_starter := fixture_root.path_join("01/starter.gdshader.txt")
	var second_source := fixture_root.path_join("02/exercise.gdshader")
	var second_starter := fixture_root.path_join("02/starter.gdshader.txt")
	_write(first_source, "shader_type canvas_item;\n// solved one\n")
	_write(first_starter, "shader_type canvas_item;\n// starter one\n")
	_write(second_source, "shader_type canvas_item;\n// solved two\n")
	_write(second_starter, "shader_type canvas_item;\n// starter two\n")
	var entries: Array = [
		{"id": "01_fixture", "exercise_path": first_source, "starter_path": first_starter},
		{"id": "02_fixture", "exercise_path": second_source, "starter_path": second_starter}
	]

	var progress = ProgressStoreScript.new(fixture_root.path_join("progress.json"))
	progress.load_progress("01_fixture")
	progress.mark_complete("01_fixture")
	progress.reveal_next_hint("01_fixture", 3)
	var workspace = ShaderWorkspaceScript.new()
	var backup_result: Dictionary = workspace.create_backup_directory(fixture_root.path_join("backups"))
	_expect(backup_result.get("ok", false), "global reset did not create a backup directory")
	if not backup_result.get("ok", false):
		return
	var backup_directory: String = backup_result.get("backup_directory", "")
	_expect(progress.backup_to(backup_directory), "global reset did not back up progress")

	var reset_result: Dictionary = workspace.reset_all_to_starters(entries, backup_directory)
	_expect(reset_result.get("ok", false), "global reset did not restore fixture starters")
	_expect(_read(first_source) == _read(first_starter), "first fixture did not match its starter")
	_expect(_read(second_source) == _read(second_starter), "second fixture did not match its starter")
	_expect(_read(backup_directory.path_join("01_fixture.gdshader.txt")).contains("solved one"), "first solved source was not backed up")
	_expect(_read(backup_directory.path_join("02_fixture.gdshader.txt")).contains("solved two"), "second solved source was not backed up")

	_expect(progress.reset_all("01_fixture"), "global reset did not save fresh progress")
	_expect(progress.completion_count() == 0, "global reset did not clear completed exercises")
	_expect(progress.get_revealed_hint_count("01_fixture") == 0, "global reset did not clear revealed hints")
	_expect(progress.data.get("current_id", "") == "01_fixture", "global reset did not return to the first exercise")

	var restore_result: Dictionary = workspace.restore_all_from_backup(entries, backup_directory)
	_expect(restore_result.get("ok", false), "backup restore failed")
	_expect(_read(first_source).contains("solved one"), "backup restore lost the first solved source")
	_expect(_read(second_source).contains("solved two"), "backup restore lost the second solved source")


func _test_developer_mode() -> void:
	var session = CourseSessionScript.new()
	_expect(session.repository.load_course(), "developer mode test could not load the course")
	if session.repository.exercises.is_empty():
		session.free()
		return
	session.progress = ProgressStoreScript.new(temp_root.path_join("developer-progress.json"))
	var first_id: String = session.repository.get_exercise_at(0).get("id", "")
	var last_id: String = session.repository.get_exercise_at(session.repository.exercises.size() - 1).get("id", "")
	session.progress.load_progress(first_id)
	_expect(session.is_locked(last_id), "last exercise should be locked with fresh progress")
	_expect(not session.select_exercise(last_id), "normal mode unexpectedly opened a locked exercise")
	session.set_developer_mode(true)
	_expect(not session.is_locked(last_id), "developer mode did not remove the prerequisite lock")
	_expect(session.select_exercise(last_id), "developer mode could not jump to the last exercise")
	session.set_developer_mode(false)
	_expect(session.is_locked(last_id), "disabling developer mode did not restore prerequisite locks")
	session.free()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)


func _write(path: String, content: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path.get_base_dir()))
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		failures.append("could not write fixture: %s" % path)
		return
	file.store_string(content)


func _read(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""
	return FileAccess.get_file_as_string(path)


func _remove_tree(path: String) -> void:
	var directory := DirAccess.open(path)
	if directory == null:
		return
	directory.list_dir_begin()
	var name := directory.get_next()
	while not name.is_empty():
		var child := path.path_join(name)
		if directory.current_is_dir():
			_remove_tree(child)
		else:
			directory.remove(name)
		name = directory.get_next()
	directory.list_dir_end()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
