shader_type spatial;
render_mode unshaded;

void fragment() {
	// 当前显示的是 UV，不是网格朝向。
	ALBEDO = vec3(UV, 0.2);
}

