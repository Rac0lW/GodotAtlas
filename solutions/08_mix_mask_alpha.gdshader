shader_type canvas_item;

uniform vec4 inside_color : source_color = vec4(0.95, 0.58, 0.18, 1.0);
uniform vec4 outside_color : source_color = vec4(0.05, 0.11, 0.18, 1.0);
uniform float radius : hint_range(0.1, 0.48) = 0.32;
uniform float feather : hint_range(0.001, 0.15) = 0.035;

void fragment() {
	float distance_to_center = length(UV - vec2(0.5));
	float mask = 1.0 - smoothstep(radius - feather, radius + feather, distance_to_center);
	vec3 color = mix(outside_color.rgb, inside_color.rgb, mask);
	COLOR = vec4(color, mask);
}

