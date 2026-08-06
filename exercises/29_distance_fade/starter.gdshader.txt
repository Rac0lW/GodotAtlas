shader_type spatial;
render_mode cull_disabled;

uniform vec4 base_color : source_color = vec4(0.12, 0.68, 0.58, 1.0);
uniform float fade_near : hint_range(0.0, 10.0) = 2.0;
uniform float fade_far : hint_range(0.1, 14.0) = 5.0;

void fragment() {
	// TODO: 当前透明度与相机距离无关。
	ALBEDO = base_color.rgb;
	ALPHA = 0.72;
}

