shader_type spatial;

uniform vec4 base_color : source_color = vec4(0.1, 0.42, 0.72, 1.0);
uniform float shininess : hint_range(2.0, 128.0) = 48.0;

void fragment() {
	ALBEDO = base_color.rgb;
}

void light() {
	float ndotl = max(dot(NORMAL, LIGHT), 0.0);
	DIFFUSE_LIGHT += ALBEDO * LIGHT_COLOR * ndotl * ATTENUATION;
	
	vec3 half = normalize(LIGHT + VIEW);
	
	float f = dot(half, NORMAL);
	
	float p_f = max(f, 0.0);
	
	float high_light = pow(p_f, shininess);
	
	SPECULAR_LIGHT += high_light; 
	// TODO: 添加 Blinn-Phong 高光。
}
