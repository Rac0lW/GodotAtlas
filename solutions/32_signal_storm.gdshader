shader_type spatial;
render_mode cull_disabled;

uniform vec4 base_color : source_color = vec4(0.035, 0.2, 0.24, 1.0);
uniform vec4 rim_color : source_color = vec4(0.14, 0.92, 0.76, 1.0);
uniform vec4 edge_color : source_color = vec4(1.0, 0.42, 0.08, 1.0);
uniform float pulse_amount : hint_range(0.0, 0.25) = 0.07;
uniform float dissolve_threshold : hint_range(0.0, 1.0) = 0.42;

varying vec3 position_ws;
varying float pulse_signal;

float hash31(vec3 point) {
	point = fract(point * 0.1031);
	point += dot(point, point.yzx + 33.33);
	return fract((point.x + point.y) * point.z);
}

void vertex() {
	pulse_signal = sin(TIME * 1.7 + VERTEX.y * 4.0) * 0.5 + 0.5;
	VERTEX += NORMAL * pulse_amount * pulse_signal;
	position_ws = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float noise_signal = hash31(floor(position_ws * 9.0 + vec3(0.0, TIME * 0.45, 0.0)));
	float signed_edge = noise_signal - dissolve_threshold;
	if (signed_edge < 0.0) {
		discard;
	}
	float edge = 1.0 - smoothstep(0.0, 0.09, signed_edge);
	float fresnel = pow(1.0 - max(dot(NORMAL, VIEW), 0.0), 3.0);
	ALBEDO = base_color.rgb + rim_color.rgb * fresnel;
	EMISSION = edge_color.rgb * edge * (1.2 + pulse_signal);
	ROUGHNESS = 0.35;
}
