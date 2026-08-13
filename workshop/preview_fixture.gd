class_name PreviewFixture
extends SubViewport

const RENDER_SIZE := Vector2i(512, 512)
const BACKGROUND := Color("080b0e")
const CAMERA_ROTATION_SENSITIVITY := 0.008
const CAMERA_MIN_PITCH := deg_to_rad(-80.0)
const CAMERA_MAX_PITCH := deg_to_rad(80.0)

var fixture_kind := "canvas"
var exercise_id := ""
var shader_material: ShaderMaterial
var preview_camera: Camera3D
var _camera_target := Vector3.ZERO
var _camera_distance := 0.0
var _camera_yaw := 0.0
var _camera_pitch := 0.0


class PostSource:
	extends Control

	func _draw() -> void:
		var bounds := Rect2(Vector2.ZERO, size)
		draw_rect(bounds, Color("101820"))
		var cell := size.x / 12.0
		for index in range(13):
			var coordinate := float(index) * cell
			draw_line(Vector2(coordinate, 0.0), Vector2(coordinate, size.y), Color("1d2a32"), 1.0)
			draw_line(Vector2(0.0, coordinate), Vector2(size.x, coordinate), Color("1d2a32"), 1.0)
		draw_circle(size * Vector2(0.28, 0.42), size.x * 0.15, Color("e29538"))
		draw_circle(size * Vector2(0.69, 0.64), size.x * 0.19, Color("2e8b73"))
		draw_rect(Rect2(size * Vector2(0.53, 0.16), size * Vector2(0.28, 0.17)), Color("c9d0c5"))
		draw_rect(Rect2(size * Vector2(0.13, 0.71), size * Vector2(0.27, 0.10)), Color("6f5040"))


func _init() -> void:
	size = RENDER_SIZE
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	transparent_bg = false
	gui_disable_input = true
	handle_input_locally = false
	physics_object_picking = false
	msaa_2d = Viewport.MSAA_DISABLED
	msaa_3d = Viewport.MSAA_2X
	use_debanding = true
	own_world_3d = true


func configure(kind: String, shader: Shader, target_exercise_id: String) -> void:
	fixture_kind = kind
	exercise_id = target_exercise_id
	_clear_fixture()
	shader_material = ShaderMaterial.new()
	shader_material.shader = shader

	match fixture_kind:
		"spatial_sphere":
			_build_spatial(SphereMesh.new(), Vector3(0.0, 0.12, 3.25), true)
		"spatial_cube":
			var cube := BoxMesh.new()
			cube.size = Vector3(1.35, 1.35, 1.35)
			_build_spatial(cube, Vector3(2.7, 2.05, 3.55), true)
		"spatial_quad":
			var quad := QuadMesh.new()
			quad.size = Vector2(1.65, 1.65)
			_build_spatial(quad, Vector3(1.55, 0.75, 3.05), false)
		"spatial_plane":
			_build_learning_plane()
		"stencil":
			_build_stencil_fixture()
		"post":
			_build_canvas(true)
		_:
			_build_canvas(false)


func replace_shader(shader: Shader) -> void:
	if shader_material != null:
		shader_material.shader = shader


func snapshot() -> Image:
	return get_texture().get_image()


func can_rotate_camera() -> bool:
	return is_instance_valid(preview_camera)


func rotate_camera(relative_motion: Vector2) -> void:
	if not can_rotate_camera():
		return
	_camera_yaw -= relative_motion.x * CAMERA_ROTATION_SENSITIVITY
	_camera_pitch = clampf(
		_camera_pitch - relative_motion.y * CAMERA_ROTATION_SENSITIVITY,
		CAMERA_MIN_PITCH,
		CAMERA_MAX_PITCH
	)
	_update_camera_transform()


func _clear_fixture() -> void:
	preview_camera = null
	for child in get_children():
		remove_child(child)
		child.queue_free()


func _build_canvas(is_post_effect: bool) -> void:
	if is_post_effect:
		var source := PostSource.new()
		source.position = Vector2.ZERO
		source.size = Vector2(RENDER_SIZE)
		source.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(source)

		var copy := BackBufferCopy.new()
		copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
		add_child(copy)

	var surface := ColorRect.new()
	surface.position = Vector2.ZERO
	surface.size = Vector2(RENDER_SIZE)
	surface.color = Color.WHITE
	surface.material = shader_material
	surface.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(surface)


func _build_learning_plane() -> void:
	if exercise_id == "05_pipeline_handoff":
		var vertical_plane := PlaneMesh.new()
		vertical_plane.orientation = PlaneMesh.FACE_Z
		vertical_plane.size = Vector2(2.0, 1.65)
		vertical_plane.subdivide_width = 16
		vertical_plane.subdivide_depth = 16
		_build_spatial(vertical_plane, Vector3(0.0, 0.0, 3.05), false)
		return

	var wave_plane := PlaneMesh.new()
	wave_plane.orientation = PlaneMesh.FACE_Y
	wave_plane.size = Vector2(2.35, 2.35)
	wave_plane.subdivide_width = 64
	wave_plane.subdivide_depth = 64
	_build_spatial(wave_plane, Vector3(2.45, 1.82, 2.7), false)


func _build_spatial(mesh: PrimitiveMesh, camera_position: Vector3, include_floor: bool) -> void:
	_add_environment()
	_add_camera(camera_position)
	_add_lights()

	if exercise_id in ["04_coordinate_spaces", "06_world_gradient"]:
		_add_world_space_subjects(mesh)
	else:
		var subject := MeshInstance3D.new()
		subject.mesh = mesh
		subject.material_override = shader_material
		add_child(subject)

	if include_floor:
		_add_floor()


func _add_world_space_subjects(mesh: PrimitiveMesh) -> void:
	var positions := [
		Vector3(-0.72, -0.24, 0.0),
		Vector3(0.0, 0.16, 0.0),
		Vector3(0.72, 0.48, 0.0)
	]
	for subject_position in positions:
		var subject := MeshInstance3D.new()
		subject.mesh = mesh
		subject.material_override = shader_material
		subject.position = subject_position
		subject.scale = Vector3.ONE * 0.54
		add_child(subject)


func _build_stencil_fixture() -> void:
	_add_environment()
	_add_camera(Vector3(0.0, 0.0, 3.2))
	_add_lights()

	var writer_shader := Shader.new()
	writer_shader.code = FileAccess.get_file_as_string("res://shared/shaders/portal_writer.gdshader")
	var writer_material := ShaderMaterial.new()
	writer_material.shader = writer_shader
	writer_material.render_priority = -8

	var writer_mesh := PlaneMesh.new()
	writer_mesh.orientation = PlaneMesh.FACE_Z
	writer_mesh.size = Vector2(1.35, 1.75)
	var writer := MeshInstance3D.new()
	writer.mesh = writer_mesh
	writer.position = Vector3(0.0, 0.0, 0.01)
	writer.material_override = writer_material
	add_child(writer)

	shader_material.render_priority = 4
	var reader_mesh := PlaneMesh.new()
	reader_mesh.orientation = PlaneMesh.FACE_Z
	reader_mesh.size = Vector2(2.45, 2.15)
	reader_mesh.subdivide_width = 8
	reader_mesh.subdivide_depth = 8
	var reader := MeshInstance3D.new()
	reader.mesh = reader_mesh
	reader.position = Vector3(0.0, 0.0, 0.04)
	reader.material_override = shader_material
	add_child(reader)

	_add_portal_frame()


func _add_environment() -> void:
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = BACKGROUND
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("9aa6a2")
	environment.ambient_light_energy = 0.42
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC

	var world_environment := WorldEnvironment.new()
	world_environment.environment = environment
	add_child(world_environment)


func _add_camera(camera_position: Vector3) -> void:
	preview_camera = Camera3D.new()
	preview_camera.fov = 42.0
	add_child(preview_camera)

	_camera_target = Vector3.ZERO
	_camera_distance = maxf(camera_position.distance_to(_camera_target), 0.01)
	var offset := camera_position - _camera_target
	_camera_yaw = atan2(offset.x, offset.z)
	_camera_pitch = asin(clampf(offset.y / _camera_distance, -1.0, 1.0))
	_update_camera_transform()
	preview_camera.current = true


func _update_camera_transform() -> void:
	if not can_rotate_camera():
		return
	var horizontal_distance := cos(_camera_pitch) * _camera_distance
	var offset := Vector3(
		sin(_camera_yaw) * horizontal_distance,
		sin(_camera_pitch) * _camera_distance,
		cos(_camera_yaw) * horizontal_distance
	)
	preview_camera.position = _camera_target + offset
	preview_camera.look_at(_camera_target, Vector3.UP)


func _add_lights() -> void:
	var key := DirectionalLight3D.new()
	key.rotation_degrees = Vector3(-42.0, -32.0, 0.0)
	key.light_color = Color("ffe0b2")
	key.light_energy = 1.3
	key.shadow_enabled = true
	add_child(key)

	var fill := OmniLight3D.new()
	fill.position = Vector3(-1.8, 1.1, 2.0)
	fill.light_color = Color("89a7a0")
	fill.light_energy = 1.0
	fill.omni_range = 5.0
	add_child(fill)


func _add_floor() -> void:
	var floor_mesh := PlaneMesh.new()
	floor_mesh.size = Vector2(5.5, 5.5)
	var floor_material := StandardMaterial3D.new()
	floor_material.albedo_color = Color("11191e")
	floor_material.roughness = 0.88

	var floor := MeshInstance3D.new()
	floor.mesh = floor_mesh
	floor.position = Vector3(0.0, -0.86, 0.0)
	floor.material_override = floor_material
	add_child(floor)


func _add_portal_frame() -> void:
	var frame_material := StandardMaterial3D.new()
	frame_material.albedo_color = Color("6d4d28")
	frame_material.metallic = 0.62
	frame_material.roughness = 0.34
	var frame_parts := [
		{"position": Vector3(-0.78, 0.0, 0.08), "size": Vector3(0.12, 2.02, 0.12)},
		{"position": Vector3(0.78, 0.0, 0.08), "size": Vector3(0.12, 2.02, 0.12)},
		{"position": Vector3(0.0, 0.95, 0.08), "size": Vector3(1.68, 0.12, 0.12)},
		{"position": Vector3(0.0, -0.95, 0.08), "size": Vector3(1.68, 0.12, 0.12)}
	]
	for part in frame_parts:
		var box := BoxMesh.new()
		box.size = part.size
		var instance := MeshInstance3D.new()
		instance.mesh = box
		instance.position = part.position
		instance.material_override = frame_material
		add_child(instance)
