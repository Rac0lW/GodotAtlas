shader_type canvas_item;
render_mode unshaded;

void fragment() {
	vec3 warm = vec3(0.88, 0.34, 0.15);
	vec3 cool = vec3(0.12, 0.78, 0.72);
	COLOR = vec4(mix(warm, cool, UV.x), 1.0);
}
