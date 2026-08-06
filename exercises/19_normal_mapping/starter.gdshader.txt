shader_type spatial;

uniform float frequency : hint_range(2.0, 64.0) = 28.0;
uniform float normal_strength : hint_range(0.0, 0.9) = 0.38;

void fragment() {
	// TODO: 目前只改变颜色，并未真正扰动法线。
	float pattern = sin(UV.x * frequency) * cos(UV.y * frequency);
	ALBEDO = mix(vec3(0.04, 0.18, 0.2), vec3(0.12, 0.72, 0.64), pattern * 0.5 + 0.5);
	ROUGHNESS = 0.38;
}

