shader_type canvas_item;

uniform vec2 viewport_size = vec2(640.0, 360.0);

void fragment() {
	// TODO: 当前坐标没有居中、没有宽高比修正，也没有时间。
	vec2 point = UV;
	float signal = sin(point.x * 18.0) * sin(point.y * 18.0);
	COLOR = vec4(vec3(signal * 0.5 + 0.5), 1.0);
}

