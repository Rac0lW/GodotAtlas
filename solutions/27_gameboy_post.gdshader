shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixel_size : hint_range(1.0, 12.0, 1.0) = 5.0;

vec3 palette(float level) {
	if (level < 0.5) {
		return vec3(0.055, 0.16, 0.13);
	}
	if (level < 1.5) {
		return vec3(0.18, 0.34, 0.22);
	}
	if (level < 2.5) {
		return vec3(0.48, 0.58, 0.28);
	}
	return vec3(0.78, 0.82, 0.42);
}

void fragment() {
	vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 pixel_coordinate = SCREEN_UV * screen_size;
	vec2 snapped = floor(pixel_coordinate / pixel_size) * pixel_size + pixel_size * 0.5;
	vec3 source = texture(screen_texture, snapped / screen_size).rgb;
	float luminance = dot(source, vec3(0.2126, 0.7152, 0.0722));
	float level = floor(clamp(luminance, 0.0, 0.9999) * 4.0);
	COLOR = vec4(palette(level), 1.0);
}

