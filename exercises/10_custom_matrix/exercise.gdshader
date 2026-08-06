shader_type spatial;
render_mode unshaded;

uniform float angle_degrees : hint_range(-180.0, 180.0) = 42.0;

void vertex() {
	// TODO: 用矩阵替代这个与角度无关的偏移。
	
	mat2 t = mat2(
		vec2(cos(radians(angle_degrees)), -sin(radians(angle_degrees))), vec2(sin(radians(angle_degrees)), cos(radians(angle_degrees)))
	);
	
	VERTEX.xz = t * VERTEX.xz;
	
	//VERTEX.x += 0.18;
}

void fragment() {
	ALBEDO = NORMAL * 0.5 + 0.5;
}
