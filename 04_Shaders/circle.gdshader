shader_type spatial;
render_mode unshaded;

uniform vec4 foreground_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 background_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);

uniform float radius : hint_range(0.0, 1.0) = 0.3;
uniform float smoothness : hint_range(0.0, 0.5) = 0.02;

uniform vec2 tile_count = vec2(4.0, 4.0);             // How many tiles (circles) across UV
uniform vec2 circle_offset = vec2(0.0, 0.0);          // Global translation
uniform float rotation : hint_range(-6.283, 6.283) = 0.0; // Rotation in radians
uniform vec2 ellipse_scale = vec2(1.0, 1.0);          // Ellipse scaling

void fragment() {
    // Step 1: Tile and offset UVs
    vec2 tiled_uv = fract((UV + circle_offset) * tile_count);

    // Step 2: Move to center of tile
    vec2 centered = tiled_uv - vec2(0.5);

    // Step 3: Apply ellipse distortion
    vec2 scaled = centered * ellipse_scale;

    // Step 4: Apply rotation
    float s = sin(rotation);
    float c = cos(rotation);
    mat2 rot = mat2(vec2(c, -s), vec2(s, c));
    vec2 rotated = rot * scaled;

    // Step 5: Compute distance and apply smooth edge
    float dist = length(rotated);
    float edge = smoothstep(radius + smoothness, radius - smoothness, dist);

    // Step 6: Blend colors and alpha
    ALBEDO = mix(background_color.rgb, foreground_color.rgb, edge);
    ALPHA  = mix(background_color.a,   foreground_color.a,   edge);
}
