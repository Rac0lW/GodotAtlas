shader_type canvas_item;

float circle_mask(vec2 point, float radius, float softness) {
	return 1.0 - smoothstep(radius - softness, radius + softness, length(point));
}

void fragment() {
	vec2 point = UV - vec2(0.5);
	float head = circle_mask(point, 0.34, 0.004);
	float left_eye = circle_mask(point - vec2(-0.12, -0.07), 0.038, 0.004);
	float right_eye = circle_mask(point - vec2(0.12, -0.07), 0.038, 0.004);
	float eyes = max(left_eye, right_eye);
	vec2 mouth_point = point - vec2(0.0, 0.02);
	float mouth_ring = abs(length(mouth_point) - 0.17) - 0.014;
	float mouth = (1.0 - smoothstep(-0.003, 0.003, mouth_ring)) * step(0.04, mouth_point.y);
	vec3 background = vec3(0.025, 0.045, 0.075);
	vec3 skin = vec3(0.93, 0.58, 0.25);
	vec3 ink = vec3(0.035, 0.055, 0.08);
	vec3 color = mix(background, skin, head);
	color = mix(color, ink, max(eyes, mouth) * head);
	COLOR = vec4(color, 1.0);
}

