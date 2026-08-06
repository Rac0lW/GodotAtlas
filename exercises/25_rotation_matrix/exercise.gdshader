shader_type spatial;
render_mode unshaded;

uniform vec3 rotation_degrees = vec3(18.0, 38.0, 12.0);

void vertex() {
	// TODO: 构造并组合三个旋转矩阵。
}

void fragment() {
	ALBEDO = NORMAL * 0.5 + 0.5;
}

