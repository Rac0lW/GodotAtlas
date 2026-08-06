shader_type canvas_item;

void fragment() {
	// TODO: 用有向距离场替代这张二维渐变。
	vec2 point = UV * 2.0 - 1.0;
	COLOR = vec4(vec3(0.04, 0.08, 0.12) + vec3(point.y * 0.05), 1.0);
}

