shader_type spatial;
render_mode unshaded;

varying vec3 position_ws;

void vertex() {
	position_ws = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	ALBEDO = fract(position_ws * 0.25 + 0.5);
}
