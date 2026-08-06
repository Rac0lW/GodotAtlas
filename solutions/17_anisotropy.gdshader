shader_type spatial;

uniform vec4 base_color : source_color = vec4(0.32, 0.12, 0.055, 1.0);
uniform float tangent_sharpness : hint_range(1.0, 80.0) = 8.0;
uniform float binormal_sharpness : hint_range(1.0, 80.0) = 42.0;

varying vec3 tangent_view;
varying vec3 binormal_view;

void fragment() {
	ALBEDO = base_color.rgb;
	ROUGHNESS = 0.35;
	tangent_view = normalize(TANGENT);
	binormal_view = normalize(BINORMAL);
}

void light() {
	vec3 half_direction = normalize(LIGHT + VIEW);
	float tangent_term = pow(dot(half_direction, tangent_view), 2.0) * tangent_sharpness;
	float binormal_term = pow(dot(half_direction, binormal_view), 2.0) * binormal_sharpness;
	float anisotropic = exp(-tangent_term - binormal_term);
	float ndotl = max(dot(NORMAL, LIGHT), 0.0);
	DIFFUSE_LIGHT += ALBEDO * LIGHT_COLOR * ndotl * ATTENUATION;
	SPECULAR_LIGHT += LIGHT_COLOR * anisotropic * ndotl * ATTENUATION;
}

