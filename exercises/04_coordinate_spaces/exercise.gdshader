shader_type spatial;
render_mode unshaded;

varying vec3 position_os;

void vertex() {
	// TODO: 这里仍然是对象空间。
	position_os = VERTEX;
}

void fragment() {
	ALBEDO = fract(position_os * 0.25 + 0.5);
}
