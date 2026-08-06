shader_type canvas_item;

uniform vec4 color_a : source_color = vec4(0.1, 0.82, 0.72, 1.0);
uniform vec4 color_b : source_color = vec4(0.96, 0.44, 0.14, 1.0);
uniform float pulse_speed : hint_range(0.2, 6.0) = 2.0;

void fragment() {
	vec2 point = UV - vec2(0.5);
	// TODO: 使用 TIME 替代固定半径与颜色。
	float ring = 1.0 - smoothstep(0.012, 0.022, abs(length(point) - 0.28));
	COLOR = vec4(mix(vec3(0.02, 0.035, 0.06), color_a.rgb, ring), 1.0);
}

