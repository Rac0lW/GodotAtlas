shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float amplitude : hint_range(0.0, 0.7) = 0.28;
uniform float frequency : hint_range(1.0, 12.0) = 5.0;
uniform float speed : hint_range(0.0, 5.0) = 1.6;

varying float wave_height;

void vertex() {
	float phase = VERTEX.x * frequency + TIME * speed;
	wave_height = sin(phase) * amplitude;
	VERTEX.y += wave_height;
}

void fragment() {
	float blend = wave_height / max(amplitude, 0.001) * 0.5 + 0.5;
	ALBEDO = mix(vec3(0.03, 0.18, 0.28), vec3(0.14, 0.82, 0.72), blend);
}

