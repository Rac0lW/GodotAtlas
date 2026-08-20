shader_type canvas_item;
render_mode unshaded;

void fragment() {
	COLOR = vec4(UV.x, UV.y, 0.35, 1.0);
}
