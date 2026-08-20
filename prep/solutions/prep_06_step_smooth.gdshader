shader_type canvas_item;
render_mode unshaded;

void fragment() {
	float hard_edge = step(0.5, UV.x);
	float soft_edge = smoothstep(0.25, 0.75, UV.x);
	COLOR = vec4(hard_edge, soft_edge, 0.18, 1.0);
}
