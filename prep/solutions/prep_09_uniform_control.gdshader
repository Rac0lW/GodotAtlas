shader_type canvas_item;
render_mode unshaded;

uniform vec4 prep_color : source_color = vec4(0.12, 0.78, 0.72, 1.0);

void fragment() {
	COLOR = prep_color;
}
