shader_type spatial;
render_mode unshaded;

varying vec3 position_os;

void vertex() {
	// TODO: 这里仍然是对象空间。
	position_os = VERTEX;
	
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	position_os = world_pos;
	
}

void fragment() {
	ALBEDO = fract(position_os * 0.25 + 0.5);
}
