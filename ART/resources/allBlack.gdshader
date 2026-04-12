shader_type canvas_item;

// This grabs the pixels currently on the screen behind the object
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec4 back_color = texture(screen_texture, SCREEN_UV);
    
    vec4 tex_color = texture(TEXTURE, UV);
    
    vec3 inverted_rgb = vec3(1.0) - back_color.rgb;
    
    if (tex_color.a > 0.1) {
        COLOR = vec4(inverted_rgb, tex_color.a);
    } else {
        discard;
    }
}

