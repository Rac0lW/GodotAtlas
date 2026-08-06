extends SceneTree

const CourseRepositoryScript = preload("res://workshop/course_repository.gd")
const ValidationRegistryScript = preload("res://workshop/validation_registry.gd")
const PreviewFixtureScript = preload("res://workshop/preview_fixture.gd")

var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var bounds := _requested_bounds()
	var first_number: int = bounds.x
	var last_number: int = bounds.y
	var repository := CourseRepositoryScript.new()
	var validation := ValidationRegistryScript.new()
	if not repository.load_course():
		push_error(repository.last_error)
		quit(1)
		return
	if not validation.load_checks():
		push_error(validation.last_error)
		quit(1)
		return

	var fixture_root := Node.new()
	fixture_root.name = "ShaderSmokeFixtures"
	get_root().add_child(fixture_root)
	var learner = PreviewFixtureScript.new()
	var reference = PreviewFixtureScript.new()
	fixture_root.add_child(learner)
	fixture_root.add_child(reference)

	var rendered_count := 0
	for entry in repository.exercises:
		var exercise_number: int = entry.get("number", 0)
		if exercise_number < first_number or exercise_number > last_number:
			continue
		var exercise_id: String = entry.get("id", "")
		print("BEGIN %s" % exercise_id)
		var kind: String = entry.get("preview", "canvas")
		var mode: String = entry.get("validation", "visual")
		var starter_shader := _shader_from_file(entry.get("starter_path", ""))
		var solution_shader := _shader_from_file(entry.get("solution_path", ""))
		rendered_count += 1

		reference.configure(kind, solution_shader, exercise_id)
		learner.configure(kind, solution_shader, exercise_id)
		await _settle(4)
		var solution_image: Image = learner.snapshot()
		var reference_image: Image = reference.snapshot()
		if solution_image.is_empty() or reference_image.is_empty():
			failures.append("%s produced an empty solution image" % exercise_id)
			continue

		if mode.contains("visual"):
			var solution_result: Dictionary = validation.compare_images(exercise_id, solution_image, reference_image)
			if not solution_result.get("passed", false):
				failures.append("%s solution did not match its mirror fixture" % exercise_id)

			learner.configure(kind, starter_shader, exercise_id)
			await _settle(4)
			var starter_result: Dictionary = validation.compare_images(exercise_id, learner.snapshot(), reference.snapshot())
			var mean_error: float = starter_result.get("mean_error", 0.0)
			print("VISUAL %s solution=pass starter=%s mean=%.5f" % [exercise_id, "pass" if starter_result.get("passed", false) else "fail", mean_error])
			if starter_result.get("passed", false):
				failures.append("%s starter unexpectedly passed visual validation" % exercise_id)
		else:
			print("COMPILE %s mode=%s" % [exercise_id, mode])

	fixture_root.queue_free()
	for _cleanup_frame in range(8):
		await process_frame
	await RenderingServer.frame_post_draw
	if failures.is_empty():
		print("SHADER_SMOKE_OK %d exercises rendered range=%d..%d" % [rendered_count, first_number, last_number])
		quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("SHADER_SMOKE_FAILED count=%d" % failures.size())
	quit(1)


func _shader_from_file(path: String) -> Shader:
	var shader := Shader.new()
	shader.code = FileAccess.get_file_as_string(path)
	shader.get_shader_uniform_list()
	return shader


func _settle(frame_count: int) -> void:
	for _frame in range(frame_count):
		await process_frame
	await RenderingServer.frame_post_draw


func _requested_bounds() -> Vector2i:
	var first := 1
	var last := 32
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--from="):
			first = int(argument.trim_prefix("--from="))
		elif argument.begins_with("--to="):
			last = int(argument.trim_prefix("--to="))
	return Vector2i(first, last)
