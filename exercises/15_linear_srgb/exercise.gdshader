shader_type canvas_item;

void fragment() {
	float linear_value = UV.x;
	// TODO: 下半区还没有进行显示编码。
	float value = linear_value;
	COLOR = vec4(vec3(value), 1.0);
}

