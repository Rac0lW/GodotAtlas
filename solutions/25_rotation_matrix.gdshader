shader_type spatial;
render_mode unshaded;

uniform vec3 rotation_degrees = vec3(18.0, 38.0, 12.0);

void vertex() {
	vec3 angle = radians(rotation_degrees);
	float sx = sin(angle.x);
	float cx = cos(angle.x);
	float sy = sin(angle.y);
	float cy = cos(angle.y);
	float sz = sin(angle.z);
	float cz = cos(angle.z);
	mat3 rotation_x = mat3(vec3(1.0, 0.0, 0.0), vec3(0.0, cx, -sx), vec3(0.0, sx, cx));
	mat3 rotation_y = mat3(vec3(cy, 0.0, sy), vec3(0.0, 1.0, 0.0), vec3(-sy, 0.0, cy));
	mat3 rotation_z = mat3(vec3(cz, -sz, 0.0), vec3(sz, cz, 0.0), vec3(0.0, 0.0, 1.0));
	VERTEX = rotation_z * rotation_y * rotation_x * VERTEX;
}

void fragment() {
	ALBEDO = NORMAL * 0.5 + 0.5;
}

