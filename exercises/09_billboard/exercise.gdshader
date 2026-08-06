shader_type spatial;
render_mode unshaded, skip_vertex_transform;

void vertex() {
	mat4 billboard = mat4(
		INV_VIEW_MATRIX[0],
		INV_VIEW_MATRIX[1],
		INV_VIEW_MATRIX[2],
		MODEL_MATRIX[3]
	);
	vec4 vertex_ws = billboard * vec4(VERTEX, 1.0);
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vertex_ws;
}

void fragment() {
	ALBEDO = vec3(0.95, 0.55, 0.16);
}
