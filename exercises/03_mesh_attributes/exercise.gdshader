shader_type spatial;
render_mode unshaded;

void fragment() {
	// 当前显示的是 UV，不是网格朝向。

	ALBEDO.xy = NORMAL.xy * 0.5 + 0.5;
}
