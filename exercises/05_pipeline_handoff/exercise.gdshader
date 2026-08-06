shader_type spatial;
render_mode unshaded;

varying float vertex_height;

void vertex() {
	// TODO: 把顶点高度交给片元阶段。
	vertex_height = 0.0;
}

void fragment() {
	float blend = smoothstep(-0.5, 0.5, vertex_height);
	ALBEDO = mix(vec3(0.08, 0.18, 0.32), vec3(0.95, 0.48, 0.18), blend);
}

