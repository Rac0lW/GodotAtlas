shader_type canvas_item;

void fragment() {
	// TODO: 让颜色直接显示 UV 坐标。
	float red = UV.x;
	float green = UV.y;
	COLOR = vec4(red, green, 0.35, 1.0);
}
