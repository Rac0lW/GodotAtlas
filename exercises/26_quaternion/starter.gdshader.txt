shader_type spatial;
render_mode unshaded;

uniform vec3 rotation_axis = vec3(0.7, 1.0, 0.25);
uniform float angle_degrees : hint_range(-180.0, 180.0) = 58.0;

void vertex() {
	// TODO: 用单位四元数旋转 VERTEX。
}

void fragment() {
	ALBEDO = NORMAL * 0.5 + 0.5;
}

