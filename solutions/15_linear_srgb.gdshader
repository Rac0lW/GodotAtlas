shader_type canvas_item;

void fragment() {
	float linear_value = UV.x;
	float encoded_value = pow(linear_value, 1.0 / 2.2);
	float lower_half = step(0.5, UV.y);
	float value = mix(linear_value, encoded_value, lower_half);
	COLOR = vec4(vec3(value), 1.0);
}

