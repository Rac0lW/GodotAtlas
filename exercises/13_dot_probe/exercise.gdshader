shader_type spatial;
render_mode unshaded;

uniform vec3 probe_direction = vec3(0.4, 0.65, 0.7);

void fragment() {
	// TODO: 当前使用绝对值，方向正负信息被抹掉了。
	vec3 signal = abs(NORMAL);
	ALBEDO = signal;
}

