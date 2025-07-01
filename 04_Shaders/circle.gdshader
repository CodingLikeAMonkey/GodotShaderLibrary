shader_type spatial;
render_mode unshaded;

uniform vec4 foreground_color : source_color = vec4(1.0);
uniform vec4 background_color : source_color = vec4(0.0);

uniform float radius : hint_range(0.0, 1.0) = 0.2;
uniform float smoothness : hint_range(0.0001, 0.5) = 0.01;
uniform vec2 tile_count = vec2(4.0, 4.0); // Number of circles in X and Y

void fragment() {
    vec2 tiled_uv = UV * tile_count;
    vec2 cell_uv = fract(tiled_uv);
    vec2 centered = cell_uv - vec2(0.5);
    float dist = length(centered);

    // Soft edge control
    float edge = smoothstep(radius + smoothness, radius - smoothness, dist);

    // Blend
    ALBEDO = mix(background_color.rgb, foreground_color.rgb, edge);
    ALPHA  = mix(background_color.a,   foreground_color.a,   edge);
}
