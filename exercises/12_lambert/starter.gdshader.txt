shader_type spatial;
render_mode unshaded;

uniform vec4 base_color : source_color = vec4(0.78, 0.34, 0.12, 1.0);

void fragment() {
	// 当前完全忽略灯光。
	ALBEDO = base_color.rgb;
}

