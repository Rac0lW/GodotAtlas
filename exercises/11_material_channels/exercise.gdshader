shader_type spatial;

void fragment() {
	// TODO: 把三个材质通道暴露成 uniform。
	ALBEDO = vec3(0.62, 0.62, 0.62);
	ROUGHNESS = 1.0;
	METALLIC = 0.0;
}

