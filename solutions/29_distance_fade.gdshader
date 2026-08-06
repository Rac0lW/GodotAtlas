shader_type spatial;
render_mode cull_disabled;

uniform vec4 base_color : source_color = vec4(0.12, 0.68, 0.58, 1.0);
uniform float fade_near : hint_range(0.0, 10.0) = 2.0;
uniform float fade_far : hint_range(0.1, 14.0) = 5.0;

varying vec3 position_ws;

void vertex() {
	position_ws = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float camera_distance = distance(position_ws, CAMERA_POSITION_WORLD);
	float opacity = 1.0 - smoothstep(fade_near, fade_far, camera_distance);
	float edge = pow(1.0 - max(dot(NORMAL, VIEW), 0.0), 2.0);
	ALBEDO = base_color.rgb + edge * vec3(0.15, 0.35, 0.3);
	ALPHA = opacity;
}

