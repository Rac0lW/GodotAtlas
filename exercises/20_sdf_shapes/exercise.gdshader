shader_type canvas_item;

float sd_circle(vec2 point, float radius) {
	return length(point) - radius;
}

float sd_box(vec2 point, vec2 half_size) {
	vec2 offset = abs(point) - half_size;
	return length(max(offset, vec2(0.0))) + min(max(offset.x, offset.y), 0.0);
}

void fragment() {
	vec2 point = UV - vec2(0.5);
	float circle_distance = sd_circle(point + vec2(0.13, 0.0), 0.22);
	float box_distance = sd_box(point - vec2(0.16, 0.0), vec2(0.19, 0.13));
	float distance_field = min(circle_distance, box_distance);
	float mask = 1.0 - smoothstep(-0.004, 0.004, distance_field);
	COLOR = vec4(mix(vec3(0.035, 0.055, 0.09), vec3(0.96, 0.52, 0.16), mask), 1.0);
}