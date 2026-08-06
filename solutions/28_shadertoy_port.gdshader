shader_type canvas_item;

uniform vec2 viewport_size = vec2(640.0, 360.0);

void fragment() {
	vec2 point = UV * 2.0 - 1.0;
	point.x *= viewport_size.x / max(viewport_size.y, 1.0);
	float wave_a = sin(length(point - vec2(sin(TIME * 0.7) * 0.45, 0.0)) * 18.0 - TIME * 2.0);
	float wave_b = sin(length(point - vec2(-0.45, cos(TIME * 0.5) * 0.3)) * 15.0 + TIME * 1.4);
	float wave_c = sin((point.x - point.y) * 8.0 + TIME);
	float signal = (wave_a + wave_b + wave_c) / 3.0 * 0.5 + 0.5;
	vec3 dark = vec3(0.025, 0.045, 0.085);
	vec3 bright = vec3(0.12, 0.86, 0.72);
	vec3 accent = vec3(0.98, 0.46, 0.14);
	vec3 color = mix(dark, bright, smoothstep(0.2, 0.75, signal));
	color = mix(color, accent, smoothstep(0.78, 0.96, signal));
	COLOR = vec4(color, 1.0);
}

