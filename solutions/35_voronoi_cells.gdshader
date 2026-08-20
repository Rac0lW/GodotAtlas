shader_type canvas_item;
render_mode unshaded;

float hash21(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + vec2(45.32));
	return fract(p.x * p.y);
}

void fragment() {
	vec2 scaled_uv = UV * 6.0;
	vec2 cell = floor(scaled_uv);
	vec2 local = fract(scaled_uv);
	float min_dist = 1.0;
	for (int y = -1; y <= 1; y++) {
		for (int x = -1; x <= 1; x++) {
			vec2 offset = vec2(float(x), float(y));
			vec2 point = vec2(hash21(cell + offset), hash21(cell + offset + vec2(19.19, 7.77)));
			min_dist = min(min_dist, length(offset + point - local));
		}
	}
	float cell_value = 1.0 - smoothstep(0.0, 0.9, min_dist);
	COLOR = vec4(vec3(cell_value), 1.0);
}
