shader_type canvas_item;

void fragment() {
	float linear_value = UV.x;
	float encoded_value = pow(linear_value, 1.0 / 2.2);
	float lower_half = step(0.5, UV.y);
	float value = mix(linear_value, encoded_value, lower_half);
	float divider = 1.0 - smoothstep(0.0, 0.006, abs(UV.y - 0.5));
	vec3 color = mix(vec3(value), vec3(0.95, 0.48, 0.12), divider);
	COLOR = vec4(color, 1.0);
}

