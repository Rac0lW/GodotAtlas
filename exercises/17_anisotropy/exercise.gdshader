shader_type spatial;

uniform vec4 base_color : source_color = vec4(0.32, 0.12, 0.055, 1.0);
uniform float tangent_sharpness : hint_range(1.0, 80.0) = 8.0;
uniform float binormal_sharpness : hint_range(1.0, 80.0) = 42.0;

void fragment() {
	ALBEDO = base_color.rgb;
	ROUGHNESS = 0.35;
	// TODO: 自定义各向异性光照。
}

