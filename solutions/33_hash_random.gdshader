shader_type canvas_item;
render_mode unshaded;

float hash21(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + vec2(45.32));
	return fract(p.x * p.y);
}

void fragment() {
	float value = hash21(floor(UV * 12.0));
	COLOR = vec4(vec3(value), 1.0);
}
