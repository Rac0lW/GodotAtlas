shader_type canvas_item;
render_mode unshaded;

void fragment() {
	float wave = 0.5 + 0.5 * sin(UV.x * 6.283 + TIME);
	COLOR = vec4(wave, UV.y, 0.2, 1.0);
}
