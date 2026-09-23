shader_type spatial;
render_mode unshaded, cull_disabled, shadows_disabled;
uniform sampler2D reflected_view : source_color, filter_linear;
uniform float strength = 0.0;
void fragment() {
    // The mirrored camera has a right-handed basis. Reverse its horizontal axis
    // to recover the physical reflection in this plane (including reversed text).
    ALBEDO = texture(reflected_view, vec2(1.0 - SCREEN_UV.x, SCREEN_UV.y)).rgb;
    ALPHA = strength;
}
