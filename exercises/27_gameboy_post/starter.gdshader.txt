shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixel_size : hint_range(1.0, 12.0, 1.0) = 5.0;

void fragment() {
	// TODO: 对采样坐标像素化，并把亮度量化到四色。
	COLOR = texture(screen_texture, SCREEN_UV);
}

