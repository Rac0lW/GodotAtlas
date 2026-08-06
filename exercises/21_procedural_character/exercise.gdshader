shader_type canvas_item;

float circle_mask(vec2 point, float radius, float softness) {
	return 1.0 - smoothstep(radius - softness, radius + softness, length(point));
}

void fragment() {
	vec2 point = UV - vec2(0.5);
	float head = circle_mask(point, 0.34, 0.004);
	// TODO: 添加眼睛和弧形嘴。
	vec3 color = mix(vec3(0.025, 0.045, 0.075), vec3(0.93, 0.58, 0.25), head);
	COLOR = vec4(color, 1.0);
}

