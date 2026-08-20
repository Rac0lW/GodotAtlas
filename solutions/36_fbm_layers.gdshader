shader_type canvas_item;
render_mode unshaded;

float hash21(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + vec2(45.32));
	return fract(p.x * p.y);
}

float value_noise(vec2 p) {
	vec2 cell = floor(p);
	vec2 local = fract(p);
	local = local * local * (3.0 - 2.0 * local);
	float a = hash21(cell);
	float b = hash21(cell + vec2(1.0, 0.0));
	float c = hash21(cell + vec2(0.0, 1.0));
	float d = hash21(cell + vec2(1.0, 1.0));
	return mix(mix(a, b, local.x), mix(c, d, local.x), local.y);
}

void fragment() {
	float total = 0.0;
	float amplitude = 0.5;
	vec2 sample_uv = UV * 3.0;
	for (int octave = 0; octave < 5; octave++) {
		total += value_noise(sample_uv) * amplitude;
		sample_uv = sample_uv * 2.0 + vec2(17.0, 31.0);
		amplitude *= 0.5;
	}
	COLOR = vec4(vec3(total), 1.0);
}
