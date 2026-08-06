vec3 atlas_hemisphere(vec3 normal_direction, vec3 sky_color, vec3 ground_color) {
	float sky_weight = normal_direction.y * 0.5 + 0.5;
	return mix(ground_color, sky_color, clamp(sky_weight, 0.0, 1.0));
}

