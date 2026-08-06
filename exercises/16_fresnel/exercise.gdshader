shader_type spatial;
render_mode unshaded;

uniform vec4 base_color : source_color = vec4(0.035, 0.08, 0.14, 1.0);
uniform vec4 rim_color : source_color = vec4(0.2, 0.95, 0.82, 1.0);
uniform float rim_power : hint_range(0.5, 8.0) = 3.0;

void fragment() {
	// TODO: 让轮廓响应观察角度。
	float f = dot(NORMAL, VIEW);
	float ff = 1.0 - f;
	
	float fre = pow(ff, rim_power);
	
	ALBEDO = base_color.rgb + rim_color.rgb * fre;
}
