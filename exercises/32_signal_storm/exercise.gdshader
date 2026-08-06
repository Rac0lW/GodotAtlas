shader_type spatial;
render_mode cull_disabled;

uniform vec4 base_color : source_color = vec4(0.035, 0.2, 0.24, 1.0);
uniform vec4 rim_color : source_color = vec4(0.14, 0.92, 0.76, 1.0);
uniform vec4 edge_color : source_color = vec4(1.0, 0.42, 0.08, 1.0);
uniform float pulse_amount : hint_range(0.0, 0.25) = 0.07;
uniform float dissolve_threshold : hint_range(0.0, 1.0) = 0.42;

void vertex() {
	// TODO: 沿对象空间法线加入呼吸脉动，并传递世界位置。
}

void fragment() {
	// TODO: 组合 Fresnel、世界空间噪声、discard 和边缘发光。
	ALBEDO = base_color.rgb;
	ROUGHNESS = 0.35;
}

