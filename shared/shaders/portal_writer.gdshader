shader_type spatial;
render_mode unshaded;
stencil_mode write, 1;

void fragment() {
	ALBEDO = vec3(0.03, 0.04, 0.06);
}

