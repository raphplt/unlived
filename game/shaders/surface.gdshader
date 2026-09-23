shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx;
uniform vec4 tint : source_color = vec4(0.8, 0.7, 0.5, 1.0);
uniform float roughness_value = 0.8;
uniform float metallic_value = 0.0;
uniform float grain = 0.035;
uniform float loss = 0.0;
uniform float emission_strength = 0.0;
varying vec3 world;
float hash(vec3 p) { return fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453); }
void vertex() { world = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; }
void fragment() {
    float fleck = hash(floor(world * 180.0));
    if (loss > 0.0 && hash(floor(world * 12.0)) < loss) { discard; }
    ALBEDO = tint.rgb * (1.0 - grain + grain * fleck * 2.0);
    ROUGHNESS = roughness_value;
    METALLIC = metallic_value;
    EMISSION = tint.rgb * emission_strength;
}
