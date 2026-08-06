shader_type spatial;

uniform vec4 base_color : source_color = vec4(0.78, 0.34, 0.12, 1.0);

void fragment() {
	ALBEDO = base_color.rgb;
}

void light() {
	float ndotl = max(dot(NORMAL, LIGHT), 0.0);
	DIFFUSE_LIGHT += ALBEDO * LIGHT_COLOR * ndotl * ATTENUATION;
}

