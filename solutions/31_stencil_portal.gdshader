shader_type spatial;
render_mode unshaded, depth_draw_never;
stencil_mode read, compare_equal, 1;

void fragment() {
	vec2 grid = abs(fract(UV * 12.0) - 0.5);
	float line = 1.0 - step(0.06, min(grid.x, grid.y));
	ALBEDO = mix(vec3(0.02, 0.09, 0.12), vec3(0.12, 0.88, 0.72), line);
}

