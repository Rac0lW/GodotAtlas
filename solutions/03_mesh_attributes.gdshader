shader_type spatial;
render_mode unshaded;

void fragment() {
	ALBEDO = NORMAL * 0.5 + 0.5;
}

