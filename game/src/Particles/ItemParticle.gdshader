shader_type canvas_item;

uniform vec4 color: hint_color = vec4(1, 1, 0, 1);

void fragment() {
	vec4 og_color = texture(TEXTURE, UV);
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = color.rgb;
	COLOR.a = og_color.a;
}