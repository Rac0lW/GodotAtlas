shader_type spatial;
render_mode unshaded;

uniform vec3 probe_direction = vec3(0.4, 0.65, 0.7);

void fragment() {
	float signal = dot(NORMAL, normalize(probe_direction)) * 0.5 + 0.5;
	ALBEDO = vec3(signal);
}

