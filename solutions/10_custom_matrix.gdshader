shader_type spatial;
render_mode unshaded;

uniform float angle_degrees : hint_range(-180.0, 180.0) = 42.0;

void vertex() {
	float angle = radians(angle_degrees);
	float c = cos(angle);
	float s = sin(angle);
	mat2 rotation = mat2(vec2(c, -s), vec2(s, c));
	VERTEX.xz = rotation * VERTEX.xz;
}

void fragment() {
	ALBEDO = NORMAL * 0.5 + 0.5;
}
