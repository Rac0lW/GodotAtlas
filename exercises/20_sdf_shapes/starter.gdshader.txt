shader_type canvas_item;

float sd_circle(vec2 point, float radius) {
	return length(point) - radius;
}

void fragment() {
	vec2 point = UV - vec2(0.5);
	// TODO: 增加矩形距离函数，并与圆形合并。
	float distance_field = sd_circle(point + vec2(0.12, 0.0), 0.22);
	float mask = 1.0 - step(0.0, distance_field);
	COLOR = vec4(mix(vec3(0.035, 0.055, 0.09), vec3(0.96, 0.52, 0.16), mask), 1.0);
}

