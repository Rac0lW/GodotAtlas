shader_type canvas_item;

uniform vec4 ink_color : source_color = vec4(0.12, 0.78, 0.72, 1.0);

void fragment() {
	COLOR = ink_color;
}

