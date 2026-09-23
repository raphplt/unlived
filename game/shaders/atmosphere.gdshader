shader_type canvas_item;
render_mode unshaded;
uniform float strength = 0.22;
void fragment() {
    vec2 p = UV - 0.5;
    float vignette = smoothstep(0.23, 0.72, length(p));
    float noise = fract(sin(dot(UV * 2300.0, vec2(12.9898, 78.233))) * 43758.5453);
    COLOR = vec4(vec3(0.035, 0.047, 0.043), vignette * strength + noise * 0.016);
}
