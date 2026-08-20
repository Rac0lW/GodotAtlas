shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

void fragment() {
	vec2 centered = SCREEN_UV - vec2(0.5);
	float radius = length(centered);
	vec2 warped_uv = SCREEN_UV + centered * sin(radius * 18.0 - TIME * 1.5) * 0.025;
	COLOR = texture(screen_texture, warped_uv);
}
