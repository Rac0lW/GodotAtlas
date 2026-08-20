shader_type canvas_item;
render_mode unshaded;

void fragment() {
	float mask = smoothstep(0.35, 0.65, UV.x);
	COLOR = vec4(vec3(mask), 1.0);
}
