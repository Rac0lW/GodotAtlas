shader_type spatial;
render_mode unshaded;

uniform vec4 cold_color : source_color = vec4(0.05, 0.22, 0.42, 1.0);
uniform vec4 warm_color : source_color = vec4(1.0, 0.48, 0.16, 1.0);
uniform float gradient_low : hint_range(-2.0, 2.0) = -0.7;
uniform float gradient_high : hint_range(-2.0, 2.0) = 0.7;

varying float height_value;

void vertex() {
	// TODO: 当前渐变仍然粘在对象上。
	height_value = (MODEL_MATRIX * vec4(VERTEX, 1.0)).y;
}

void fragment() {
	float blend = smoothstep(gradient_low, gradient_high, height_value);
	ALBEDO = mix(cold_color.rgb, warm_color.rgb, blend);
}
