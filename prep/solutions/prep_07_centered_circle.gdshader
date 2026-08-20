shader_type canvas_item;
render_mode unshaded;

void fragment() {
	vec2 centered = UV - vec2(0.5);
	float distance_to_center = length(centered);
	float circle = 1.0 - smoothstep(0.22, 0.24, distance_to_center);
	COLOR = vec4(vec3(circle), 1.0);
}
