shader_type spatial;
render_mode unshaded;

uniform vec4 base_color : source_color = vec4(0.035, 0.08, 0.14, 1.0);
uniform vec4 rim_color : source_color = vec4(0.2, 0.95, 0.82, 1.0);
uniform float rim_power : hint_range(0.5, 8.0) = 3.0;

void fragment() {
	float fresnel = pow(1.0 - max(dot(NORMAL, VIEW), 0.0), rim_power);
	ALBEDO = base_color.rgb + rim_color.rgb * fresnel;
}

