shader_type spatial;
render_mode unshaded;

#include "res://shared/shaders/atlas_lighting.gdshaderinc"

uniform vec4 base_color : source_color = vec4(0.82, 0.74, 0.58, 1.0);
uniform vec4 sky_color : source_color = vec4(0.18, 0.52, 0.92, 1.0);
uniform vec4 ground_color : source_color = vec4(0.36, 0.12, 0.055, 1.0);

void fragment() {
	vec3 environment_light = atlas_hemisphere(NORMAL, sky_color.rgb, ground_color.rgb);
	ALBEDO = base_color.rgb * environment_light;
}

