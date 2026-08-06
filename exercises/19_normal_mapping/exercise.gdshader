shader_type spatial;

uniform float frequency : hint_range(2.0, 64.0) = 28.0;
uniform float normal_strength : hint_range(0.0, 0.9) = 0.38;

void fragment() {
	vec2 normal_xy = vec2(
		sin(UV.x * frequency),
		cos(UV.y * frequency)
	) * normal_strength;
	float length_squared = clamp(dot(normal_xy, normal_xy), 0.0, 0.999);
	vec3 normal_ts = normalize(vec3(normal_xy, sqrt(1.0 - length_squared)));
	mat3 tbn = mat3(TANGENT, BINORMAL, NORMAL);
	NORMAL = normalize(tbn * normal_ts);
	float pattern = sin(UV.x * frequency) * cos(UV.y * frequency);
	ALBEDO = mix(vec3(0.04, 0.18, 0.2), vec3(0.12, 0.72, 0.64), pattern * 0.5 + 0.5);
	ROUGHNESS = 0.38;
}