shader_type spatial;
render_mode unshaded;

uniform vec3 rotation_axis = vec3(0.7, 1.0, 0.25);
uniform float angle_degrees : hint_range(-180.0, 180.0) = 58.0;

vec4 quaternion_from_axis_angle(vec3 axis, float angle) {
	float half_angle = angle * 0.5;
	return vec4(normalize(axis) * sin(half_angle), cos(half_angle));
}

vec3 rotate_by_quaternion(vec3 value, vec4 quaternion) {
	return value + 2.0 * cross(
		quaternion.xyz,
		cross(quaternion.xyz, value) + quaternion.w * value
	);
}

void vertex() {
	vec4 quaternion = quaternion_from_axis_angle(rotation_axis, radians(angle_degrees));
	VERTEX = rotate_by_quaternion(VERTEX, quaternion);
}

void fragment() {
	ALBEDO = NORMAL * 0.5 + 0.5;
}
