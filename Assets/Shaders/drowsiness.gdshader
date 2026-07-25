shader_type canvas_item;

uniform float drowsiness : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 uv = UV;
	float dist = distance(uv, vec2(0.5, 0.5));
	float vignette = smoothstep(0.3, 0.7, dist);
	COLOR = vec4(0.0, 0.0, 0.0, vignette * drowsiness);
}