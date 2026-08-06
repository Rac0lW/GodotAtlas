shader_type canvas_item;

uniform vec4 accent : source_color = vec4(0.96, 0.62, 0.18, 1.0);
uniform float sweep_speed : hint_range(0.05, 2.0) = 0.35;
uniform float sweep_width : hint_range(0.01, 0.3) = 0.08;

void fragment() {
	vec2 grid_uv = fract(UV * 12.0);
	float grid_line = step(grid_uv.x, 0.08) + step(grid_uv.y, 0.08);
	vec3 base = mix(vec3(0.035, 0.055, 0.09), vec3(0.08, 0.12, 0.17), clamp(grid_line, 0.0, 1.0));
	// TODO: 添加随时间移动且受 base 调制的高光。
	COLOR = vec4(base, 1.0);
}

