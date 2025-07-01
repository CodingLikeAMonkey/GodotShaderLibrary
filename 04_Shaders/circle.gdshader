shader_type spatial;
render_mode unshaded;

uniform vec4 foreground_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 background_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float radius : hint_range(0.0, 1.0) = 0.5;
uniform float smoothness : hint_range(0.0001, 1.0) = 0.0;

void fragment() {
	vec2 centered = UV - vec2(0.5);
	float dist = length(centered);
	float edge = smoothstep(radius + smoothness, radius - smoothness, dist);
	
	ALBEDO = mix(background_color.rgb, foreground_color.rgb, edge);
    ALPHA  = mix(background_color.a,   foreground_color.a,   edge);
}