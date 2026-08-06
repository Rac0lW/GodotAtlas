shader_type spatial;

uniform float bump_strength : hint_range(0.0, 1.0) = 0.35;

void fragment() {
	vec2 wave = vec2(sin(UV.x * 38.0), cos(UV.y * 38.0)) * bump_strength;
	vec3 normal_ts = normalize(vec3(wave, 1.0));
	// TODO: normal_ts 还不属于当前需要的空间。
	NORMAL = normal_ts;
	ALBEDO = vec3(0.16, 0.56, 0.62);
	ROUGHNESS = 0.45;
}

