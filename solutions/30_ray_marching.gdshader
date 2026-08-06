shader_type canvas_item;

const int MAX_STEPS = 64;
const float MAX_DISTANCE = 12.0;
const float SURFACE_EPSILON = 0.002;

float scene_distance(vec3 point) {
	return length(point) - 1.0;
}

vec3 estimate_normal(vec3 point) {
	vec2 epsilon = vec2(SURFACE_EPSILON, 0.0);
	return normalize(vec3(
		scene_distance(point + epsilon.xyy) - scene_distance(point - epsilon.xyy),
		scene_distance(point + epsilon.yxy) - scene_distance(point - epsilon.yxy),
		scene_distance(point + epsilon.yyx) - scene_distance(point - epsilon.yyx)
	));
}

void fragment() {
	vec2 point = UV * 2.0 - 1.0;
	point.x *= 1.55;
	vec3 ray_origin = vec3(0.0, 0.0, 3.2);
	vec3 ray_direction = normalize(vec3(point, -1.8));
	float travel = 0.0;
	bool hit = false;
	for (int step_index = 0; step_index < MAX_STEPS; step_index++) {
		vec3 sample_point = ray_origin + ray_direction * travel;
		float distance_to_scene = scene_distance(sample_point);
		if (distance_to_scene < SURFACE_EPSILON) {
			hit = true;
			break;
		}
		travel += distance_to_scene;
		if (travel > MAX_DISTANCE) {
			break;
		}
	}
	vec3 background = mix(vec3(0.015, 0.028, 0.055), vec3(0.05, 0.12, 0.16), UV.y);
	vec3 color = background;
	if (hit) {
		vec3 surface_point = ray_origin + ray_direction * travel;
		vec3 normal_direction = estimate_normal(surface_point);
		vec3 light_direction = normalize(vec3(-0.45, 0.7, 0.5));
		float diffuse = max(dot(normal_direction, light_direction), 0.0);
		float rim = pow(1.0 - max(dot(normal_direction, -ray_direction), 0.0), 3.0);
		color = vec3(0.06, 0.42, 0.48) * (0.18 + diffuse) + vec3(0.95, 0.48, 0.14) * rim;
	}
	COLOR = vec4(color, 1.0);
}

