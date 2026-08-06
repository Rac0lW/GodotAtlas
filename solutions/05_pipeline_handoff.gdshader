shader_type spatial;
render_mode unshaded;

varying float vertex_height;

void vertex() {
	vertex_height = VERTEX.y;
}

void fragment() {
	float blend = smoothstep(-0.5, 0.5, vertex_height);
	ALBEDO = mix(vec3(0.08, 0.18, 0.32), vec3(0.95, 0.48, 0.18), blend);
}

