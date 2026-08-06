shader_type spatial;

uniform vec4 base_color : source_color = vec4(0.12, 0.58, 0.64, 1.0);
uniform float roughness_value : hint_range(0.0, 1.0) = 0.28;
uniform float metallic_value : hint_range(0.0, 1.0) = 0.72;

void fragment() {
	ALBEDO = base_color.rgb;
	ROUGHNESS = roughness_value;
	METALLIC = metallic_value;
}

