shader_type spatial;
render_mode unshaded;

uniform vec4 base_color : source_color = vec4(0.82, 0.74, 0.58, 1.0);
uniform vec4 sky_color : source_color = vec4(0.18, 0.52, 0.92, 1.0);
uniform vec4 ground_color : source_color = vec4(0.36, 0.12, 0.055, 1.0);

void fragment() {
	// TODO: 改为调用共享 include 中的半球光函数。
	ALBEDO = base_color.rgb * sky_color.rgb;
}

