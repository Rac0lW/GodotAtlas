shader_type canvas_item;

uniform vec4 ink_color : source_color = vec4(0.12, 0.78, 0.72, 1.0);

void fragment() {
	// TODO: 将这个硬编码颜色改成名为 ink_color 的 uniform。
	COLOR = ink_color;
}
